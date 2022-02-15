//
//  ViewController.swift
//  RecipeHelper
//
//  Created by Antbook on 20.01.2022.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
  
    var viewModel : ViewModel!

    private var timer: Timer?
    
    let tableView = UITableView()
    let viewForTableView = UIView()
    let closeTableView = UIView()
    
    private var minimizedTopAnchorForConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorForConstraint: NSLayoutConstraint!
    private var closeTableViewTopAnchorConstraint: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //когда обращаемся к searchBar, если текст уже введен
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //когда произошла фильтрация по имени или же нет
    var isFiltering: Bool {
        if isApiModeEnable == false {
            return false
        } else {
            return searchController.isActive && !searchBarIsEmpty
        }
    }
    
    var isApiModeEnable: Bool = true
    
    var openCloseTableView = true
    
    lazy var loadingLabel : UILabel = {
        let label = UILabel()
        label.text = " Loading... "
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 23)
        label.frame = CGRect(x: view.center.x - 60, y: view.center.y - 60, width: 120, height: 120)
        label.numberOfLines = 1
        return label
    }()
    
  

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
   
        let startColor = #colorLiteral(red: 0.7110412717, green: 0.7906122804, blue: 0.8905088305, alpha: 1), endColor = #colorLiteral(red: 0.9450980392, green: 0.8509803922, blue: 0.9568627451, alpha: 1)
        view.applyGradients(cornerRadius: 0, startColor: startColor, endColor: endColor)
        
        setupTableView()
        dissmisTableViewGesture ()
        setupSearchBar()
        
       
       
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(loadingLabel)
        
        viewModel.requestSearchFilterData(searchText: "Apple") {
            self.tableView.reloadData()
            self.loadingLabel.text = ""
        }

        
        
    }
    
    // MARK: - SetupSearchBar
    func setupSearchBar () {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - SetupTableView
    func setupTableView () {
       // viewModel.setupTableView()
        
        tableView.backgroundColor = .none
        
        tableView.register(MyCustomCell.self, forCellReuseIdentifier: "cell")
        
        viewForTableView.translatesAutoresizingMaskIntoConstraints = false
        closeTableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        viewForTableView.backgroundColor = .brown
        //closeTableView.backgroundColor = .red
        
        
        
        view.addSubview(viewForTableView)
        viewForTableView.addSubview(tableView)
        viewForTableView.addSubview(closeTableView)
        //  view.insertSubview(tableView, belowSubview: closeTableView)
        
        maximizedTopAnchorForConstraint = viewForTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        minimizedTopAnchorForConstraint = viewForTableView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        maximizedTopAnchorForConstraint.isActive = true
        minimizedTopAnchorForConstraint.isActive = false
        
        closeTableViewTopAnchorConstraint = closeTableView.topAnchor.constraint(equalTo: viewForTableView.topAnchor)
        closeTableViewTopAnchorConstraint.constant = 140
        closeTableViewTopAnchorConstraint.isActive = true
        
        
        
        NSLayoutConstraint.activate([
            // viewForTableView.topAnchor.constraint(equalTo: view.topAnchor),
            viewForTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewForTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewForTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.topAnchor.constraint(equalTo: closeTableView.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: viewForTableView.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: viewForTableView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: viewForTableView.rightAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            closeTableView.heightAnchor.constraint(equalToConstant: 15),
            closeTableView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
        
      
    }
}

    //MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(isFiltering: isFiltering)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCustomCell {
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8509803922, blue: 0.9568627451, alpha: 1)
            cell.selectedBackgroundView = backgroundView
            
            viewModel.cellForRowAt(cell: cell, indexPath: indexPath, isFiltering: isFiltering)
            return cell
        }
        fatalError("could not dequeueReusableCell")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        let detailViewController = DetailViewController()
        
        detailViewController.detailViewModel = viewModel.didSelectRowAt(indexPath: indexPath, isFiltering: isFiltering)
        
        
        
        
       present(detailViewController, animated: true, completion: nil)
      
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame:  CGRect(x: 0,y: 0,width: view.frame.width, height: 30))
        // header.backgroundColor = .gray
        
        let button = UIButton(frame: CGRect(x: 10 , y: 0, width: 175, height: 30))
        
        let apiModeButton = UIButton(frame: CGRect(x: Int(view.frame.width) - 150 , y: 0, width: 125 , height: 30))
        // apiModeButton.backgroundColor = .red
        apiModeButton.setTitle("API Mode", for: .normal)
        apiModeButton.setTitleColor( .orange, for: .normal)
        apiModeButton.addTarget(self, action:  #selector(apiModeButtonAction), for: .touchUpInside)
        
        button.setTitle("Sorted by name:", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.addTarget(self, action:  #selector(sortedButtonAction), for: .touchUpInside)
        
        header.addSubview(button)
        header.addSubview(apiModeButton)
        
        return header
    }
    
    @objc func apiModeButtonAction () {
        print("apiModeButtonAction clicked")
        
            if isApiModeEnable {
                print("apiMode Enable")
                isApiModeEnable = false
                tableView.reloadData()
            } else {
                print("apiMode Disable")
                isApiModeEnable = true
               // tableView.reloadData()
            }
        }
    
    @objc func sortedButtonAction() {
        print("sortedButtonAction clicked")
        
        viewModel.sortedButtonAction {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.heightForHeaderInSection()
        
    }
}
//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
        print(viewModel.recipeModel.value.first?.label)

        
        viewModel.updateSearchResults(searchController: searchController, isApiModeEnable: isApiModeEnable) {
      
                self.tableView.reloadData()
            
        }
    }
}


//MARK: - GestureRecognizer (open/close tableView)
extension ViewController {

    func dissmisTableViewGesture () {
        closeTableView.backgroundColor = .lightGray
        let image = UIImage(systemName: "square.and.arrow.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: (375 - 130) / 2 , y: 0, width: 130, height: 10)
        
        closeTableView.addSubview(imageView)
        closeTableView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    //    @objc func handleTapMinMax (view: UIView) {
    //        print("Tapped min/max")
    //
    //        if openCloseTableView {
    //            minimizeTableView(view: view)
    //            openCloseTableView = false
    //        } else {
    //            maximizeTableView(view: view)
    //            openCloseTableView = true
    //        }
    //    }
    
    @objc func handlePan (gesture: UIPanGestureRecognizer) {
        //print("Tapping")
        switch gesture.state { //.state состояние
        case .began:
            
            print("нажали")
            // handleDissmisPan (gesture: gesture)
        case .changed:
            
            //print("тянем координаты \(gesture.translation(in: self.viewForTableView))")
            handlePanChange (gesture: gesture)
        case .ended:
            
            print("отпустили зажатие на координатах \(gesture.translation(in: self.viewForTableView))")
            
            handlePanEnded (gesture: gesture)
            
        @unknown default:
            print("unknown default gesture")
        }
    }
    
    private func handlePanChange (gesture: UIPanGestureRecognizer) {
        //get coordinate
        let translation = gesture.translation(in: self.viewForTableView)
        //логика что бы наш контроллер двигался за движением пальца (по Y)
        viewForTableView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        //уменьшаем альфу в зависимости от положения нашего viewForTableView
        let newAlpha = 2 + -translation.y / 200
        self.tableView.alpha = newAlpha
        print(newAlpha)
        print(self.tableView.alpha)
    }
    
    private func handlePanEnded (gesture: UIPanGestureRecognizer) {
        //get coordinate and speed gesture
        let translation = gesture.translation(in: self.viewForTableView)
        let speed = gesture.velocity(in: self.viewForTableView)//получам/фиксируем скорость
        
        //логика что бы наш контроллер двигался за движением пальца (либо на верх либо вниз, по Y)
        viewForTableView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        if -translation.y > -200 && speed.y < -500  { //если подняли 200 поинтов от начального состояния и если скорость ниже чем -500
            self.maximizeTableView()
        } else {
            self.minimizeTableView()
        }
        print(-translation.y, speed.y )  //-translation.y / 200
    }
    
    
    func maximizeTableView() {
        print("maximizeTrackDetailsController")
        maximizedTopAnchorForConstraint.isActive = true
        minimizedTopAnchorForConstraint.isActive = false
        
        closeTableViewTopAnchorConstraint.constant = 140
        maximizedTopAnchorForConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()//обновляет каждую милисекунду(иначе мы не увидим)
            self.viewForTableView.transform = .identity //изначальное состояние (иначе все будет съезжать)
            self.tableView.alpha = 1
        },
                       completion: nil)
    }
    
    func minimizeTableView() {
        
        maximizedTopAnchorForConstraint.isActive = false
        minimizedTopAnchorForConstraint.isActive = true
        closeTableViewTopAnchorConstraint.constant = 0
        // minimizedTopAnchorForConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()//обновляет каждую милисекунду(иначе мы не увидим)
            self.viewForTableView.transform = .identity //изначальное состояние (иначе все будет съезжать)
            self.tableView.alpha = 0
        },
                       completion: nil)
    }
    
    
    
    
}




   


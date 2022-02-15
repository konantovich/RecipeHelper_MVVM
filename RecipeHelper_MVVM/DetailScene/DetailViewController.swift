//
//  DetailViewController.swift
//  RecipeHelper
//
//  Created by Antbook on 10.02.2022.
//

import Foundation
import UIKit
import SDWebImage


class DetailViewController: UIViewController {

    var detailViewModel : DetailViewModel!
    
    private var timer: Timer?
    
    private var collectionView: UICollectionView!

    private var viewForCollectionView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    lazy var recipeLabel : UILabel = {
        let label = UILabel()
        label.text = " Label recipe "
        label.textAlignment = .left
        label.font = UIFont(name: label.font.fontName, size: 20)
        label.numberOfLines = 2
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var recipeDescription : UILabel = {
        let label = UILabel()
        label.text = "description recipe description recipe description recipe description recipe description recipe description recipe description recipe description recipe "
        label.numberOfLines = 10
        label.font = UIFont(name: label.font.fontName, size: 12)
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var instructionDescription : UITextView = {
        let textView = UITextView()
        
        textView.textAlignment = .left
        textView.text = "Hello World with https://google.com"
        textView.font = UIFont(name: UILabel().font.fontName, size: 12)
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.isSelectable = true
        textView.isEditable = false
        textView.isUserInteractionEnabled = true
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .none
        //…
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var tryAlsoLabel : UILabel = {
        let label = UILabel()
        label.text = " Try also "
        label.numberOfLines = 1
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imagesFromUrl : [String]?

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailViewModel = detailViewModel else {return}
        
       
        
        detailViewModel.tryAlsoForSelectedRecipe {
            
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.collectionView.reloadData()
               
            })
          
        }
        
        print(detailViewModel.selectedRecipe.label)
        
        //detailViewModel = DetailViewModel(selectedRecipe: detailViewModel.selectedRecipe, tryAlso: detailViewModel.tryAlso ?? [])
        
        view.applyGradients(cornerRadius: 0, startColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
    
        // view.backgroundColor = .white
        viewForCollectionView.backgroundColor = .none
    
        setupCollectionView()
        reloadData()
        setupConstraint()
        setupScrollView ()
        setupDataSource()
        
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: - setupDataSource
    private func setupDataSource() {
        
        guard let recipe = detailViewModel.selectedRecipe else {return}
        
        //   self.photoRecipe.sd_setImage(with: URL(string: recipe.image ?? ""), completed: nil)
        self.recipeLabel.text = recipe.label
        self.recipeDescription.text = recipe.ingredientLines?.joined(separator: ", ").replacingOccurrences(of: "(optional)", with: "", options: NSString.CompareOptions.literal, range: nil)  //replacingOccurrences revome word from text
        
        self.instructionDescription.text = "See a full recipe: \(URL(string: recipe.url ?? "")!)"
        
        print("selectedRecipeModel", recipe)
    }
    
    //MARK: - setupScrollView
    private func setupScrollView () {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        // stackView.spacing = 10
       // stackView.backgroundColor = .green
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // stackView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        scrollView.addSubview(stackView)
        
       
        let imagesFromUrl = [detailViewModel.selectedRecipe?.images?.large?.url ?? "", detailViewModel.selectedRecipe?.images?.regular?.url ?? "", detailViewModel.selectedRecipe?.images?.small?.url ?? ""]
       
        for i in 0..<imagesFromUrl.count {
            let imagesForSwipe = detailViewModel.getImageFromUrl(urlString: imagesFromUrl)
            let imageView = imagesForSwipe[i]
            imageView.backgroundColor = .red
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            // imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            imageView.contentMode = .scaleAspectFill
            
            //add image on stackview
            stackView.insertArrangedSubview(imageView, at: i)
            stackView.backgroundColor = .green
            
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
    }
  
    //MARK: - reloadData
    private func reloadData () {

        view.addSubview(scrollView)
        view.addSubview(recipeLabel)
        view.addSubview(recipeDescription)
        view.addSubview(instructionDescription)
        view.addSubview(viewForCollectionView)
        view.addSubview(tryAlsoLabel)
        //        photoRecipe.addSubview(scrollView)
    }
    
    //MARK: - setupCollectionView
    private func setupCollectionView () {
        
        // create a layout to be used
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        // make sure that there is a slightly larger gap at the top of each row
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        // set a standard item size of 60 * 60
        layout.itemSize = CGSize(width: 100, height: 100)
        // the layout scrolls horizontally
        layout.scrollDirection = .horizontal
        // set the frame and layout
        
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // set the dataSource
        self.collectionView.dataSource = self
        // set the delegate
        self.collectionView.delegate = self
        // bounce at the bottom of the collection view
       // self.collectionView.alwaysBounceVertical = true
        // set the background to be white
        self.collectionView.backgroundColor = .none
        
        self.viewForCollectionView = collectionView
    }
    //MARK: - SetupConstraint
    private func setupConstraint () {

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.heightAnchor.constraint(equalToConstant: 400 / 2)
        ])

        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
            recipeLabel.leadingAnchor.constraint(equalTo: viewForCollectionView.leadingAnchor, constant: 0),
            recipeLabel.heightAnchor.constraint(equalToConstant: 50),
            recipeLabel.widthAnchor.constraint(equalToConstant: 300),
        ])
        
        NSLayoutConstraint.activate([
            recipeDescription.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 5 ),
            recipeDescription.leadingAnchor.constraint(equalTo: viewForCollectionView.leadingAnchor, constant: 0),
            recipeDescription.heightAnchor.constraint(equalToConstant: 120),
            recipeDescription.widthAnchor.constraint(equalToConstant: view.center.x + 80),
        ])

        NSLayoutConstraint.activate([
            
            instructionDescription.topAnchor.constraint(equalTo: recipeDescription.bottomAnchor, constant: 20),
            instructionDescription.leadingAnchor.constraint(equalTo: viewForCollectionView.leadingAnchor, constant: 0),
            instructionDescription.heightAnchor.constraint(equalToConstant: 40),
            instructionDescription.widthAnchor.constraint(equalToConstant: view.center.x + 80),
        ])
        
        NSLayoutConstraint.activate([
            tryAlsoLabel.bottomAnchor.constraint(equalTo: viewForCollectionView.topAnchor, constant: 10),
            tryAlsoLabel.leadingAnchor.constraint(equalTo: viewForCollectionView.leadingAnchor, constant: 0),
            tryAlsoLabel.heightAnchor.constraint(equalToConstant: 40),
            tryAlsoLabel.widthAnchor.constraint(equalToConstant: view.center.x + 80),
        ])
        
        NSLayoutConstraint.activate([
            viewForCollectionView.topAnchor.constraint(equalTo: instructionDescription.bottomAnchor, constant: 60),
            
            viewForCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewForCollectionView.heightAnchor.constraint(equalToConstant: 100),
            viewForCollectionView.widthAnchor.constraint(equalToConstant: view.center.x + 150),
        ])
    }
}

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tryAlso = detailViewModel.tryAlso?.prefix(3).count else {return 0}
        return tryAlso
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dequeue the standard cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell {
            //    let data = self.collectionViewData[indexPath.item]
            guard let tryAlso = detailViewModel.tryAlso?.prefix(3)[indexPath.row] else {
                
                fatalError("Unable to dequeue subclassed cell")
            }
            
            cell.setupCell(recipe: tryAlso )
            return cell
            
        } else {
            fatalError("Unable to dequeue subclassed cell")
        }
        
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")

        guard let tryAlso = detailViewModel.tryAlso?[indexPath.row] else {
            fatalError("Unable to dequeue subclassed cell")
        }
        detailViewModel.selectedRecipe = tryAlso
        detailViewModel.tryAlsoForSelectedRecipe {
            self.collectionView.reloadData()
            self.setupDataSource()
            self.setupScrollView()
        }
        
//        guard let url = URL(string: tryAlso.url ?? "") else { return }
//        UIApplication.shared.open(url)
    }
}

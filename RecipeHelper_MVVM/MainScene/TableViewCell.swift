


import UIKit


class MyCustomCell: UITableViewCell {
    
    lazy var photoRecipe: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "square.and.arrow.up")
       // imgView.contentMode = .scaleAspectFit
     
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var recipeLabel : UILabel = {
        let label = UILabel()
        label.text = " Label recipe "
        label.numberOfLines = 1
       
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var recipeDescription : UILabel = {
        let label = UILabel()
        label.text = "description recipe description recipe description recipe description recipe description recipe description recipe description recipe description recipe "
        label.numberOfLines = 2
        label.font = UIFont(name: label.font.fontName, size: 7)
        
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //recipeLabel.backgroundColor = UIColor.yellow
       // recipeDescription.backgroundColor = .green
      
        backgroundColor = .none
        addSubview(photoRecipe)
        addSubview(recipeLabel)
        addSubview(recipeDescription)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    
        
        // recipeLabel.frame = CGRect(x: 20, y: 0, width: 70, height: 30)
        
        NSLayoutConstraint.activate([
            photoRecipe.topAnchor.constraint(equalTo: topAnchor),
            photoRecipe.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoRecipe.leftAnchor.constraint(equalTo: leftAnchor),
            photoRecipe.widthAnchor.constraint(equalTo: photoRecipe.heightAnchor)
        ])
        
        recipeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12.0).isActive = true
        recipeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        recipeLabel.leftAnchor.constraint(equalTo: photoRecipe.rightAnchor, constant: 12).isActive = true
        recipeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        recipeDescription.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor, constant: 10.0).isActive = true
        recipeDescription.heightAnchor.constraint(equalToConstant: 20).isActive = true
        recipeDescription.leftAnchor.constraint(equalTo: photoRecipe.rightAnchor, constant: 12).isActive = true
        recipeDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        recipeDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        
    }
}

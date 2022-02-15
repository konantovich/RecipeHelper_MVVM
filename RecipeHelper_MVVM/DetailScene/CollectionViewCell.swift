//
//  CollectionViewCell.swift
//  RecipeHelper
//
//  Created by Antbook on 10.02.2022.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    
    lazy var photoRecipe: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "square.and.arrow.up")
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var recipeLabel : UILabel = {
        let label = UILabel()
        label.text = " Label recipe "
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 10)
        label.numberOfLines = 2
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    lazy var ingredientsLabel : UILabel = {
        let label = UILabel()
        label.text = " Ingredients Count Label "
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 6)
        label.numberOfLines = 1
        //…
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var recipesCount: UILabel = {
        let label = UILabel()
        label.text = " 0 "
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stackView = UIStackView()
    
    // must call super
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView = UIStackView(arrangedSubviews: [recipesCount, ingredientsLabel])
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 	2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(photoRecipe)
        addSubview(recipeLabel)
        addSubview(stackView)
        setupConstraint()
        
    }
    
    // we have to implement this initializer, but will only ever use this class programmatically
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(recipe: Recipe) {
        
       // self.backgroundColor = .lightGray
        self.photoRecipe.sd_setImage(with: URL(string: recipe.image ?? ""), completed: nil)
        self.recipeLabel.text = recipe.label
        self.recipesCount.text = "\(recipe.ingredients?.count ?? 0)"
        self.ingredientsLabel.text = "Ingredients"
        
    }
    

    
    
    func setupConstraint() {
        
        NSLayoutConstraint.activate([
            photoRecipe.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            photoRecipe.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            photoRecipe.widthAnchor.constraint(equalToConstant: 60),
            photoRecipe.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: photoRecipe.bottomAnchor, constant: 0),
            recipeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            recipeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            recipeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
          //  stackView.leadingAnchor.constraint(equalTo: photoRecipe.leadingAnchor, constant: 0),
          //  stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),

            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
    }
    
    
    
}

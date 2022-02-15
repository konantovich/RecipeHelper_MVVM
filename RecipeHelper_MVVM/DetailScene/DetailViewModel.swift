//
//  RecipeManager.swift
//  RecipeHelper
//
//  Created by Antbook on 10.02.2022.
//

import Foundation
import UIKit
import SDWebImage

class DetailViewModel {
    
    var selectedRecipe: Recipe!
    
    var tryAlso: [Recipe]?
    
    let networkService = NetworkService()
    
    
    init (selectedRecipe: Recipe, tryAlso: [Recipe]) {
        self.selectedRecipe = selectedRecipe
        //self.tryAlso = tryAlso
    }

    func getImageFromUrl (urlString: [String]) -> [UIImageView] {
        
        let image = UIImageView()
        var urlImage = [UIImageView]()
        
        urlString.forEach { url in
            image.sd_setImage(with: URL(string: url), completed: nil)
            urlImage.append(image)
        }
        return urlImage
    }
    init () {
        
    }
    
    
    func tryAlsoForSelectedRecipe (completion: @escaping () -> () ) -> Void  {
        
        networkService.fetchEdamamRecipes(search: String(selectedRecipe.label?.prefix(5) ?? "")) { recipe in
           
            guard let recipe = recipe,
                  let hits = recipe.hits?.prefix(10).compactMap({ $0.recipe }),
                  hits.count > 0 else  {
                      print("nil search")
                      return
                  }
            
            var tryAlsoArray = hits.filter { $0 != self.selectedRecipe }
            
            tryAlsoArray.shuffle()
            self.tryAlso = tryAlsoArray
            completion()
           
        }
        
    }

    
    
}




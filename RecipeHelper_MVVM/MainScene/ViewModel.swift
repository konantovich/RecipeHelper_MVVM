//
//  ViewModel.swift
//  RecipeHelper
//
//  Created by Antbook on 13.02.2022.
//

import Foundation
import UIKit
import SDWebImage


class ViewModel {
    
    private var timer: Timer?
    
    var recipeModel:  Observable<[Recipe]> = Observable([])
    var filterRecipeModel: Observable<[Recipe]> = Observable([])
    
    let networkService = NetworkService()

    
    var sortRecipeInTableView = true
    
  //  var recipeListener: Observable<[Recipe]> = Observable([])
    
    
    //MARK: - Network Request
    func requestSearchData (searchText: String, completion: @escaping (RecipeSearchModel) -> () ) -> Void  {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
            self.networkService.fetchEdamamRecipes(search: searchText) { [weak self] recipe in
                
                guard let recipe = recipe,
                      let hits = recipe.hits,
                      hits.count > 0 else  {
                          print("nil search")
                          return
                      }
                
                //                recipe.hits?.prefix(10).compactMap { $0.recipe }
                
                completion(recipe)
                
            }
        })
    }
    
    //MARK: - Network Request
    func requestSearchFilterData (searchText: String, completion: @escaping () -> () ) {
        
        requestSearchData(searchText: searchText) { recipe in
            self.recipeModel = Observable(recipe.hits?.prefix(10).compactMap { $0.recipe } ?? [])
            completion()
           
        }
    }
    
    func numberOfRowsInSection (isFiltering: Bool) -> Int {
        if isFiltering {
            return filterRecipeModel.value.prefix(10).count
        }
        return recipeModel.value.prefix(10).count
    }
    
    func cellForRowAt (cell: MyCustomCell, indexPath: IndexPath, isFiltering: Bool)  {
        
        if isFiltering {
            let recipe = filterRecipeModel.value.prefix(10)[indexPath.row]
            
            cell.recipeLabel.text = recipe.label
            cell.recipeDescription.text = recipe.ingredientLines?.joined(separator: ", ")
            cell.photoRecipe.sd_setImage(with: URL(string: recipe.image ?? ""), completed: nil)
            
        } else {
            let recipe = recipeModel.value[indexPath.row]
            
            cell.recipeLabel.text = recipe.label
            cell.recipeDescription.text = recipe.ingredientLines?.joined(separator: ", ")
            cell.photoRecipe.sd_setImage(with: URL(string: recipe.image ?? ""), completed: nil)
        }
        
    }
    
    func didSelectRowAt(indexPath: IndexPath, isFiltering: Bool) -> DetailViewModel {
        
       
        if isFiltering {
            var tryAlsoArray = filterRecipeModel.value.filter { $0 != filterRecipeModel.value[indexPath.row] }
            tryAlsoArray.shuffle()
  
          return DetailViewModel(selectedRecipe: filterRecipeModel.value[indexPath.row], tryAlso: tryAlsoArray)
            
           // detailViewModel.tryAlso = tryAlsoArray
        } else {
            
            var tryAlsoArray = recipeModel.value.filter { $0 != recipeModel.value[indexPath.row] }
            tryAlsoArray.shuffle()
            
            
            return DetailViewModel(selectedRecipe: recipeModel.value[indexPath.row], tryAlso: tryAlsoArray)
            
           
            
           // detailViewModel.selectedRecipe = recipeModel.value[indexPath.row]
           // detailViewModel.tryAlso = tryAlsoArray
            
            //            if recipeModel[indexPath.row] == RecipeManager.shared.tryAlso?[indexPath.row] {
            //                RecipeManager.shared.tryAlso?.remove(at: indexPath.row)
            //                RecipeManager.shared.tryAlso?.shuffle()
            //            }
            //
          
            
           
           
        }
    }
    
    func heightForRowAt () -> CGFloat {
        return 70
    }
    
    func sortedButtonAction(completion: () -> ())  {
        if sortRecipeInTableView {
            recipeModel.value.sort() { ($0.label)! < ($1.label)! }
            sortRecipeInTableView = false
            completion()
            
        } else {
            recipeModel.value.sort() { ($0.label)! > ($1.label)! }
            sortRecipeInTableView = true
            completion()
        }
    }
    
    func heightForHeaderInSection () -> CGFloat {
        return 30
    }
    
    func updateSearchResults(searchController: UISearchController, isApiModeEnable: Bool, completion: @escaping () -> ()) {
        if isApiModeEnable {
            
                recipeModel.bind { recipe in
                self.filterRecipeModel = Observable(recipe.filter {
                    $0.label!.contains(searchController.searchBar.text!)
                })
            }
            completion()
            
           
        } else {
            requestSearchFilterData(searchText: searchController.searchBar.text!) {
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                    completion()
                })
               
            }
            
        }
       
    }
    
}


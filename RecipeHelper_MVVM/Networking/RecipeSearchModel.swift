// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct RecipeSearchModel: Codable {
    let from, to, count: Int
    var hits: [Hit]?

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case hits
    }
}



// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?

    enum CodingKeys: String, CodingKey {
        case recipe
       
    }
}





// MARK: - Recipe
struct Recipe: Codable, Equatable {
 
    
    let uri: String?
    let label: String?
    let image: String?
   let images: Images?
    let source: String?
    let url: String?
    let shareAs: String?
    let yield: Int?
    let ingredientLines: [String]?
    let ingredients: [Ingredient]?
    let calories, totalWeight: Double?
    let totalTime: Double
    let cuisineType: [String]?
    
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uri == rhs.uri
    }

}






// MARK: - Images
struct Images: Codable {
    let thumbnail, small: Large?
    let regular, large: Large?

    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

// MARK: - Large
struct Large: Codable {
    let url: String?
    let width, height: Int?
}

// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String?
    let quantity: Double?
    let measure: String?
    let food: String?
    let weight: Double?
    let foodCategory: String?
    let foodId: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case text, quantity, measure, food, weight, foodCategory
        case foodId = "foodId"
        case image
    }
}



//
//  Networking.swift
//  RecipeHelper
//
//  Created by Antbook on 20.01.2022.
//

import Foundation


class NetworkService {
    
    static let edamamAppId = "8fab659c"
    
    static let edamamAppKey = "7468549e31571735175ddab07193295e"
    
    //static let shared = NetworkService()
    
    let mainLink = "https://api.edamam.com/api/recipes/v2?q=chiken&app_id=\(edamamAppId)&app_key=\(edamamAppKey)&type=public"
    
    
    
    
 
    
    func fetchEdamamRecipes (search: String, completion: @escaping (RecipeSearchModel?) -> () ) {
        
        let urlString = "https://api.edamam.com/api/recipes/v2?q=\(search)&app_id=\(NetworkService.edamamAppId)&app_key=\(NetworkService.edamamAppKey)&type=public"
        print(urlString)
        
        fetchGenericJSONData(urlString: urlString, response: completion)
        
    }
    
    private func request(url: String, completion: @escaping (Data?, Error?) -> ())  {
        //let urlString = "https://jsonplaceholder.typicode.com/posts/1"
    
        guard let url = URL(string: url) else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            //  guard let jsonString = String(data: data, encoding: .utf8) else {return}
            DispatchQueue.main.async {
                completion(data, error)
               
            }
        }
        task.resume()
    }
    
    
    //связующая функция между Request и парсингом
   private func fetchGenericJSONData <T: Decodable> (urlString: String, response: @escaping (T?) -> ()) {
        
        request(url: urlString) { data, error in
            
            if let error = error {
                print("Error request data: ", error.localizedDescription)
                print(String(describing: error))
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: T.self, data: data)
            response(decoded)
        }
        
    }
    

    //parse JSON
    private func decodeJSON<T: Decodable> (type: T.Type, data: Data?) -> T? {
        
        let decoder = JSONDecoder()
        
        guard let data = data else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            
            return objects
        } catch let jsonError {
            print("failed to decode JSON: ", jsonError.localizedDescription)
            print(String(describing: jsonError))
            return nil
        }
        
    }
    

    
    
}


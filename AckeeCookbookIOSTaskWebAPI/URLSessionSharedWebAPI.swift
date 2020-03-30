//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public class URLSessionSharedWebAPI: WebAPI {

    private let session = URLSession.shared

    public init() {
        
    }

    public func getRecipesList(offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesListResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "cookbook.ack.ee"
        urlComponents.path = "/api/v1/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                        return
                    }
                    var recipes: [Recipe] = []
                    for recipeJson in json {
                        guard let identifier = recipeJson["id"] as? String else { return }
                        guard let name = recipeJson["name"] as? String else { return }
                        guard let duration = recipeJson["duration"] as? UInt else { return }
                        let recipe = RecipeStructure(identifier: identifier, name: name, duration: duration)
                        recipes.append(recipe)
                     }
                    completionHandler(.list(recipes))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }

}

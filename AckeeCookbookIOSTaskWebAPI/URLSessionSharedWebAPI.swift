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
                    var recipes: [RecipeInList] = []
                    for recipeJson in json {
                        guard let id = recipeJson["id"] as? String else { return }
                        guard let name = recipeJson["name"] as? String else { return }
                        guard let duration = recipeJson["duration"] as? UInt else { return }
                        guard let score = (recipeJson["score"] as? NSNumber)?.floatValue else { return }
                        let recipe = StructureRecipeInList(id: id, name: name, duration: duration, score: score)
                        recipes.append(recipe)
                     }
                    completionHandler(.recipesList(recipes))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }

    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (CreateRecipeResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "cookbook.ack.ee"
        urlComponents.path = "/api/v1/recipes"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["name"] = recipe.name
        bodyJSON["description"] = recipe.description
        bodyJSON["ingredients"] = recipe.ingredients
        bodyJSON["duration"] = recipe.duration
        bodyJSON["info"] = recipe.info
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        return
                    }
                    guard let id = json["id"] as? String else { return }
                    guard let name = json["name"] as? String else { return }
                    guard let description = json["description"] as? String else { return }
                    guard let info = json["info"] as? String else { return }
                    guard let ingredients = json["ingredients"] as? [String] else { return }
                    guard let duration = json["duration"] as? UInt else { return }
                    guard let score = (json["score"] as? NSNumber)?.floatValue else { return }
                    let recipe = RecipeStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
                    completionHandler(.createdRecipe(recipe))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }

}

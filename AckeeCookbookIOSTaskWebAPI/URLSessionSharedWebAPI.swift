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
    private let scheme = "https"
    private let host = "cookbook.ack.ee"

    public init() {
        
    }

    private let getRecipesListPath = "/api/v1/recipes"
    public func getRecipesList(offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesListResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = getRecipesListPath
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.error(error))
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonArray = json as? [[String: Any]] {
                            var recipes: [RecipeInList] = []
                            for recipeJson in jsonArray {
                                guard let id = recipeJson["id"] as? String else {
                                    let error = JSONParsingError()
                                    completionHandler(.error(error))
                                    return
                                }
                                guard let name = recipeJson["name"] as? String else {
                                    let error = JSONParsingError()
                                    completionHandler(.error(error))
                                    return
                                }
                                guard let duration = recipeJson["duration"] as? UInt else {
                                    let error = JSONParsingError()
                                    completionHandler(.error(error))
                                    return
                                }
                                guard let score = (recipeJson["score"] as? NSNumber)?.floatValue else {
                                    let error = JSONParsingError()
                                    completionHandler(.error(error))
                                    return
                                }
                                let recipe = StructureRecipeInList(id: id, name: name, duration: duration, score: score)
                                recipes.append(recipe)
                             }
                            completionHandler(.recipesList(recipes))
                        } else if let jsonObject = json as? [String: Any] {
                            guard let name = jsonObject["name"] as? String else {
                                let error = JSONParsingError()
                                completionHandler(.error(error))
                                return
                            }
                            guard let code = jsonObject["errorCode"] as? Int else {
                                let error = JSONParsingError()
                                completionHandler(.error(error))
                                return
                            }
                            let error = StructureWebAPIError(code: code, name: name)
                            completionHandler(.error(error))
                        } else {
                            
                        }
                    } catch {
                        completionHandler(.error(error))
                    }
                } else {
                    let error = UnknownError()
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }

    private let createRecipePath = "/api/v1/recipes"
    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (CreateRecipeResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = createRecipePath
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
                    let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
                    completionHandler(.createdRecipe(recipe))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }
    
    private let getRecipeInDetailsPath = "/api/v1/recipes/%@"
    public func getRecipeInDetails(_ recipeId: String, completionHandler: @escaping (GetRecipeInDetailsResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = String(format: getRecipeInDetailsPath, recipeId)
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                    let ingredients = json["ingredients"] as? [String] ?? []
                    guard let duration = json["duration"] as? UInt else { return }
                    guard let score = (json["score"] as? NSNumber)?.floatValue else { return }
                    let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
                    completionHandler(.recipeInDetails(recipe))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }
    
    private let deleteRecipePath = "/api/v1/recipes/%@"
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (DeleteRecipeResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = String(format: getRecipeInDetailsPath, recipeId)
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode == 204 {
                completionHandler(.deleted)
            }
        }
        dataTask.resume()
    }
    
    
    private let updateRecipePath = "/api/v1/recipes/%@"
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (UpdateRecipeResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = recipe.id
        let path = String(format: updateRecipePath, recipeId)
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
                    let ingredients = json["ingredients"] as? [String] ?? []
                    guard let duration = json["duration"] as? UInt else { return }
                    guard let score = (json["score"] as? NSNumber)?.floatValue else { return }
                    let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
                    completionHandler(.updatedRecipe(recipe))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }
    
    private let setRecipeScorePath = "/api/v1/recipes/%@/ratings"
    public func setRecipeScore(_ recipeId: String, score: Float, completionHandler: @escaping (SetRecipeScoreResult) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = String(format: setRecipeScorePath, recipeId)
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
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
                    guard let score = (json["score"] as? NSNumber)?.floatValue else { return }
                    completionHandler(.recipeScore(score))
                } catch {
                    completionHandler(.error(error))
                }
            }
        }
        dataTask.resume()
    }

}

//
//  Version.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

class Version1SchemeHost: Version1 {
        
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    // MARK: Get recipes
    
    func getRecipesRequest(limit: UInt = 10, offset: UInt = 0) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        return request
    }
    
    func getRecipesResponse(response: URLResponse, data: Data) -> GetRecipesResponse {
        do {
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                let error = JSONParsingError()
                return .error(error)
            }
            var recipes: [RecipeInList] = []
            for recipeJson in jsonArray {
                guard let id = recipeJson["id"] as? String else {
                    let error = JSONParsingError()
                    return .error(error)
                }
                guard let name = recipeJson["name"] as? String else {
                    let error = JSONParsingError()
                    return .error(error)
                }
                guard let duration = (recipeJson["duration"] as? NSNumber)?.uintValue else {
                    let error = JSONParsingError()
                    return .error(error)
                }
                guard let score = (recipeJson["score"] as? NSNumber)?.floatValue else {
                    let error = JSONParsingError()
                    return .error(error)
                }
                let recipe = StructureRecipeInList(id: id, name: name, duration: duration, score: score)
                recipes.append(recipe)
             }
            return .recipes(recipes)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Create new recipe
    
    func createNewRecipeRequest(name: String, description: String, ingredients: [String]?, duration: UInt?, info: String?) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJson: [String: Any] = [:]
        bodyJson["name"] = name
        bodyJson["description"] = description
        bodyJson["ingredients"] = ingredients
        bodyJson["duration"] = duration
        bodyJson["info"] = info
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        let body = try! JSONSerialization.data(withJSONObject: bodyJson, options: [])
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func createNewRecipeResponse(response: URLResponse, data: Data) -> CreateNewRecipeResponse {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                let error = JSONParsingError()
                return .error(error)
            }
            let recipe = try parse(json: json)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Get recipe
    
    func getRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getRecipeResponse(response: URLResponse, data: Data) -> GetRecipeResponse {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                let error = JSONParsingError()
                return .error(error)
            }
            let recipe = try parse(json: json)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Update recipe
    
    func updateRecipeRequest(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: UInt?, info: String? = nil) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = id
        urlComponents.path = "/api/v1/recipes/\(recipeId)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["name"] = name
        bodyJSON["description"] = description
        bodyJSON["ingredients"] = ingredients
        bodyJSON["duration"] = duration
        bodyJSON["info"] = info
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func updateRecipeResponse(response: URLResponse, data: Data) -> UpdateRecipeResponse {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                let error = JSONParsingError()
                return .error(error)
            }
            let recipe = try parse(json: json)
            return .recipe(recipe)
        } catch {
            return .error(error)
        }
    }
    
    // MARK: Delete recipe
    
    func deleteRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/api/v1/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    func deleteRecipeResponse(response: URLResponse, data: Data) -> DeleteRecipeResponse {
        if (response as? HTTPURLResponse)?.statusCode == 204 {
            return .deleted
        } else {
            let error = JSONParsingError()
            return .error(error)
        }
    }
    
    // MARK: Add new rating
    
    func addNewRatingRequest(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = "/api/v1/recipes/\(id)/ratings"
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
        return request
    }
    
    func addNewRatingResponse(response: URLResponse, data: Data) -> AddNewRatingResponse {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                let error = JSONParsingError()
                return .error(error)
            }
            guard let score = (json["score"] as? NSNumber)?.floatValue else {
                let error = JSONParsingError()
                return .error(error)
            }
            return .score(score)
        } catch {
            return .error(error)
        }
    }
    
    /// MARK: Parsing
    
    private func parse(json: [String: Any]) throws -> RecipeInDetails {
        guard let id = json["id"] as? String else {
            let error = JSONParsingError()
            throw error
        }
        guard let name = json["name"] as? String else {
            let error = JSONParsingError()
            throw error
        }
        guard let description = json["description"] as? String else {
            let error = JSONParsingError()
            throw error
        }
        guard let info = json["info"] as? String else {
            let error = JSONParsingError()
            throw error
        }
        guard let ingredients = json["ingredients"] as? [String] else {
            let error = JSONParsingError()
            throw error
        }
        guard let duration = json["duration"] as? UInt else {
            let error = JSONParsingError()
            throw error
        }
        guard let score = (json["score"] as? NSNumber)?.floatValue else {
            let error = JSONParsingError()
            throw error
        }
        let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
}

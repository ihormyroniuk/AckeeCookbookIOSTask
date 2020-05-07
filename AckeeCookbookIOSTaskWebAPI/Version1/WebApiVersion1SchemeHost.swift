//
//  Version.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation
import AckeeCookbookIOSTaskBusiness

class WebApiVersion1SchemeHost: WebApiVersion1 {
        
    let scheme: String
    let host: String
    private let basePath: String = "/api/v1"
    private let contentTypeHeaderKey = "Content-Type"
    private let contentTypeHeaderValueJson = "application/json"
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    // MARK: Get recipes
    
    func getRecipesRequest(limit: UInt, offset: UInt) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        return request
    }
    
    func getRecipesResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipesResponse {
        do {
            let statusCode = response.statusCode
            if statusCode == 200 {
                let jsonArray = try JSONSerialization.objectsArray(with: data, options: [])
                var recipes: [RecipeInList] = []
                for jsonObject in jsonArray {
                    let recipe = try recipeInList(jsonObject: jsonObject)
                    recipes.append(recipe)
                }
                return .recipes(recipes)
            } else {
                let jsonObject = try JSONSerialization.object(with: data, options: [])
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: Create new recipe
    
    func createNewRecipeRequest(name: String, description: String, ingredients: [String]?, duration: UInt?, info: String?) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
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
        headers[contentTypeHeaderKey] = contentTypeHeaderValueJson
        let body = try! JSONSerialization.data(withJSONObject: bodyJson, options: [])
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func createNewRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1CreateNewRecipeResponse {
        do {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let statusCode = response.statusCode
            if statusCode == 200 {
                let recipe = try recipeInDetails(jsonObject: jsonObject)
                return .recipe(recipe)
            } else {
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: Get recipe
    
    func getRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func getRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipeResponse {
        do {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let statusCode = response.statusCode
            if statusCode == 200 {
                let recipe = try recipeInDetails(jsonObject: jsonObject)
                return .recipe(recipe)
            } else {
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: Update recipe
    
    func updateRecipeRequest(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: UInt?, info: String? = nil) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = id
        urlComponents.path = basePath + "/recipes/\(recipeId)"
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
        headers[contentTypeHeaderKey] = contentTypeHeaderValueJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func updateRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1UpdateRecipeResponse {
        do {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let statusCode = response.statusCode
            if statusCode == 200 {
                let recipe = try recipeInDetails(jsonObject: jsonObject)
                return .recipe(recipe)
            } else {
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: Delete recipe
    
    func deleteRecipeRequest(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        return request
    }
    
    func deleteRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1DeleteRecipeResponse {
        do {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let statusCode = response.statusCode
            if statusCode == 204 {
                return .success
            } else {
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: Add new rating
    
    func addNewRatingRequest(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(id)/ratings"
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers[contentTypeHeaderKey] = contentTypeHeaderValueJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func addNewRatingResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1AddNewRatingResponse {
        do {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let statusCode = response.statusCode
            if statusCode == 200 {
                let addedNewRating = try self.addedNewRating(jsonObject: jsonObject)
                return .rating(addedNewRating)
            } else {
                let error = try self.error(jsonObject: jsonObject)
                return .error(error)
            }
        } catch {
            fatalError()
        }
    }
    
    // MARK: JSON Parsing
    
    private func error(jsonObject: JsonObject) throws -> WebApiVersion1Error {
        let code = try jsonObject.numberForKey("errorCode").intValue
        let status = try jsonObject.numberForKey("status").intValue
        let name = try jsonObject.stringForKey("name")
        let error = WebApiVersion1ErrorStructure(code: code, status: status, name: name)
        return error
    }
    
    private func recipeInList(jsonObject: JsonObject) throws -> RecipeInList {
        let id = try jsonObject.stringForKey("id")
        let name = try jsonObject.stringForKey("name")
        let duration = try jsonObject.numberForKey("duration").uintValue
        let score = try jsonObject.numberForKey("score").floatValue
        let recipe = RecipeInListStructure(id: id, name: name, duration: duration, score: score)
        return recipe
    }
    
    private func recipeInDetails(jsonObject: JsonObject) throws -> RecipeInDetails {
        let id = try jsonObject.stringForKey("id")
        let name = try jsonObject.stringForKey("name")
        let description = try jsonObject.stringForKey("description")
        let info = try jsonObject.stringForKey("info")
        let ingredients = try jsonObject.stringsArrayForKey("ingredients")
        let duration = try jsonObject.numberForKey("duration").uintValue
        let score = try jsonObject.numberForKey("score").floatValue
        let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
    
    private func addedNewRating(jsonObject: JsonObject) throws -> AddedNewRating {
        let id = try jsonObject.stringForKey("id")
        let recipeId = try jsonObject.stringForKey("recipe")
        let score = try jsonObject.numberForKey("score").floatValue
        let addedNewRating = AddedNewRatingStructure(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
}

private struct WebApiVersion1ErrorStructure: WebApiVersion1Error {
    let code: Int
    let status: Int
    let name: String
}

//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1GetRecipesResponse {
    case recipes([RecipeInList])
    case error(WebApiVersion1Error)
}

class ApiVersion1EndpointGetRecipes: ApiVersion1Endpoint {
    
    func request(limit: Int, offset: Int) -> URLRequest {
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
    
    func response(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipesResponse {
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
    }
    
    func recipeInList(jsonObject: JsonObject) throws -> RecipeInList {
        let id = try jsonObject.stringForKey("id")
        let name = try jsonObject.stringForKey("name")
        let duration = try jsonObject.numberForKey("duration").intValue
        let score = try jsonObject.numberForKey("score").floatValue
        let recipe = RecipeInListStructure(id: id, name: name, duration: duration, score: score)
        return recipe
    }
    
}

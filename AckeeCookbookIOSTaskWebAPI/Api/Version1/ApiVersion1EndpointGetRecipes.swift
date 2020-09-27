//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1EndpointGetRecipes: ApiVersion1Endpoint {
    
    func request(limit: Int, offset: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = ApiVersion1.basePath + "/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Api.Method.get
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<[RecipeInList], ApiVersion1Error> {
        let statusCode = response.statusCode
        if statusCode == Api.StatusCode.ok {
            let jsonArray = try JsonSerialization.jsonArrayObjects(data)
            var recipes: [RecipeInList] = []
            for jsonObject in jsonArray {
                let recipe = try recipeInList(jsonObject: jsonObject)
                recipes.append(recipe)
            }
            return .success(recipes)
        } else {
            let jsonObject = try JsonSerialization.jsonObject(data)
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
    func recipeInList(jsonObject: JsonObject) throws -> RecipeInList {
        let id = try jsonObject.string("id")
        let name = try jsonObject.string("name")
        let duration = try jsonObject.number("duration").intValue
        let score = try jsonObject.number("score").floatValue
        let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
        return recipe
    }
    
}

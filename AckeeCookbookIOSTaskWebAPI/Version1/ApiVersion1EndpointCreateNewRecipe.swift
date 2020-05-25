//
//  ApiVersion1EndpointCreateNewRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1CreateNewRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

class ApiVersion1EndpointCreateNewRecipe: ApiVersion1Endpoint {
    
    func request(name: String, description: String, ingredients: [String]?, duration: Int?, info: String?) -> URLRequest {
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
    
    func response(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1CreateNewRecipeResponse {
        let jsonObject = try JSONSerialization.object(with: data, options: [])
        let statusCode = response.statusCode
        if statusCode == 200 {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .recipe(recipe)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .error(error)
        }
    }
    
}

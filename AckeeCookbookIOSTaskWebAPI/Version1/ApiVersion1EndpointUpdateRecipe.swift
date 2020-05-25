//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1UpdateRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

class ApiVersion1EndpointUpdateRecipe: ApiVersion1Endpoint {
    
    func request(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: Int?, info: String? = nil) -> URLRequest {
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
    
    func response(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1UpdateRecipeResponse {
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

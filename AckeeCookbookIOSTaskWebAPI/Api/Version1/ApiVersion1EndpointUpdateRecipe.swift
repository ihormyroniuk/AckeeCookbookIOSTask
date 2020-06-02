//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1EndpointUpdateRecipe: ApiVersion1Endpoint {
    
    func request(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: Int?, info: String? = nil) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = id
        urlComponents.path = ApiVersion1.basePath + "/recipes/\(recipeId)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Api.Method.put
        var bodyJSON: [String: Any] = [:]
        bodyJSON["name"] = name
        bodyJSON["description"] = description
        bodyJSON["ingredients"] = ingredients
        bodyJSON["duration"] = duration
        bodyJSON["info"] = info
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers[Api.Header.contentType] = Api.Header.contentTypeJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<RecipeInDetails, ApiVersion1Error> {
        let jsonObject = try JSONSerialization.object(with: data, options: [])
        let statusCode = response.statusCode
        if statusCode == Api.StatusCode.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .success(recipe)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
}

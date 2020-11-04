//
//  ApiVersion1EndpointCreateNewRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation
import AckeeCookbookIOSTaskBusiness

class CreateNewRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<Result<RecipeInDetails, ApiVersion1Error>> {
    
    private let name: String
    private let description: String
    private let ingredients: [String]?
    private let duration: Int?
    private let info: String?
    
    init(scheme: String, host: String, name: String, description: String, ingredients: [String]?, duration: Int?, info: String?) {
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.info = info
        super.init(scheme: scheme, host: host)
    }
    
    func request() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Http.Method.post
        var bodyJson: [String: Any] = [:]
        bodyJson["name"] = name
        bodyJson["description"] = description
        bodyJson["ingredients"] = ingredients
        bodyJson["duration"] = duration
        bodyJson["info"] = info
        var headers: [String: String] = [:]
        headers[Api.Header.contentType] = Api.Header.contentTypeJson
        let body = try! JSONSerialization.data(withJSONObject: bodyJson, options: [])
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<RecipeInDetails, ApiVersion1Error> {
        let jsonObject = try JSONSerialization.json(data).object()
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

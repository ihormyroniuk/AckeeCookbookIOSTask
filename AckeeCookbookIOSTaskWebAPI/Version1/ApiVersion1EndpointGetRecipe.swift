//
//  ApiVersion1EndpointGetRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1GetRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

class ApiVersion1EndpointGetRecipe: ApiVersion1Endpoint {
    
    func request(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipeResponse {
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


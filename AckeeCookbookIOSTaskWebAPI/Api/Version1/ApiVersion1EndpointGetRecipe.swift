//
//  ApiVersion1EndpointGetRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1EndpointGetRecipe: ApiVersion1Endpoint {
    
    func request(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = ApiVersion1.basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Api.Method.get
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<RecipeInDetails, ApiVersion1Error> {
        let jsonObject = try JsonSerialization.jsonObject(data)
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


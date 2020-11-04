//
//  ApiVersion1EndpointDeleteRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class DeleteRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<ApiVersion1Error?> {
    
    func request(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Http.Method.delete
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> ApiVersion1Error? {
        let statusCode = response.statusCode
        if statusCode == Api.StatusCode.noContent {
            return nil
        } else {
            let jsonObject = try JSONSerialization.json(data).object()
            let error = try self.error(jsonObject: jsonObject)
            return error
        }
    }
    
}

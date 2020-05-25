//
//  ApiVersion1EndpointDeleteRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1EndpointDeleteRecipe: ApiVersion1Endpoint {
    
    func request(id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = ApiVersion1.Method.delete
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> ApiVersion1Error? {
        let statusCode = response.statusCode
        if statusCode == ApiVersion1.StatusCode.noContent {
            return nil
        } else {
            let jsonObject = try JSONSerialization.object(with: data, options: [])
            let error = try self.error(jsonObject: jsonObject)
            return error
        }
    }
    
}

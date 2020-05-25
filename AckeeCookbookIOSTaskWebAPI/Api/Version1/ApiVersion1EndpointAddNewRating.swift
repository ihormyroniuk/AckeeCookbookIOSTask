//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1EndpointAddNewRating: ApiVersion1Endpoint {
    
    func request(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(id)/ratings"
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = ApiVersion1.Method.post
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers[contentTypeHeaderKey] = contentTypeHeaderValueJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<AddedNewRating, ApiVersion1Error> {
        let jsonObject = try JSONSerialization.object(with: data, options: [])
        let statusCode = response.statusCode
        if statusCode == ApiVersion1.StatusCode.ok {
            let addedNewRating = try self.addedNewRating(jsonObject: jsonObject)
            return .success(addedNewRating)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
    private func addedNewRating(jsonObject: JsonObject) throws -> AddedNewRating {
        let id = try jsonObject.stringForKey("id")
        let recipeId = try jsonObject.stringForKey("recipe")
        let score = try jsonObject.numberForKey("score").floatValue
        let addedNewRating = AddedNewRating(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}

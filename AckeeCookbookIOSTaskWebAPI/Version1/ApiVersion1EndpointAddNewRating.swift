//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1AddNewRatingResponse {
    case rating(AddedNewRating)
    case error(WebApiVersion1Error)
}

class ApiVersion1EndpointAddNewRating: ApiVersion1Endpoint {
    
    func request(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(id)/ratings"
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers[contentTypeHeaderKey] = contentTypeHeaderValueJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1AddNewRatingResponse {
        let jsonObject = try JSONSerialization.object(with: data, options: [])
        let statusCode = response.statusCode
        if statusCode == 200 {
            let addedNewRating = try self.addedNewRating(jsonObject: jsonObject)
            return .rating(addedNewRating)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .error(error)
        }
    }
    
    private func addedNewRating(jsonObject: JsonObject) throws -> AddedNewRating {
        let id = try jsonObject.stringForKey("id")
        let recipeId = try jsonObject.stringForKey("recipe")
        let score = try jsonObject.numberForKey("score").floatValue
        let addedNewRating = AddedNewRatingStructure(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}

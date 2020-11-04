//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class AddNewRatingApiVersion1HttpExchange: ApiVersion1HttpExchange<Result<AddedNewRating, ApiVersion1Error>> {
    
    func request(id: String, score: Float) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(id)/ratings"
        urlComponents.path = path
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = Http.Method.post
        var bodyJSON: [String: Any] = [:]
        bodyJSON["score"] = score
        let body = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        request.httpBody = body
        var headers: [String: String] = [:]
        headers[Api.Header.contentType] = Api.Header.contentTypeJson
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func response(response: HTTPURLResponse, data: Data) throws -> Result<AddedNewRating, ApiVersion1Error> {
        let jsonObject = try JSONSerialization.json(data).object()
        let statusCode = response.statusCode
        if statusCode == Api.StatusCode.ok {
            let addedNewRating = try self.addedNewRating(jsonObject: jsonObject)
            return .success(addedNewRating)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
    private func addedNewRating(jsonObject: JsonObject) throws -> AddedNewRating {
        let id = try jsonObject.string("id")
        let recipeId = try jsonObject.string("recipe")
        let score = try jsonObject.number("score").float
        let addedNewRating = AddedNewRating(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}

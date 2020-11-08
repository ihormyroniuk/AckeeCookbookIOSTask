//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class AddNewRatingApiVersion1HttpExchange: ApiVersion1HttpExchange<AddedNewRating> {
    
    private let recipeId: String
    private let score: Float
    
    init(scheme: String, host: String, recipeId: String, score: Float) {
        self.recipeId = recipeId
        self.score = score
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(recipeId)/ratings"
        urlComponents.path = path
        let requestUri = urlComponents.url!
        var headerFields: [String: String] = [:]
        headerFields[Http.HeaderField.contentType] = MediaType.json()
        var jsonValue: JsonObject = JsonObject()
        jsonValue["score"] = score
        let entityBody = try JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: headerFields, entityBody: entityBody)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> AddedNewRating {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        let jsonObject = try JSONSerialization.json(data: messageBody).object()
        if statusCode == Http.StatusCode.ok {
            let id = try jsonObject.string("id")
            let recipeId = try jsonObject.string("recipe")
            let score = try jsonObject.number("score").float
            let addedNewRating = AddedNewRating(id: id, recipeId: recipeId, score: score)
            return addedNewRating
        } else {
            let error = try! self.error(jsonObject: jsonObject)
            throw error
        }
    }
    
}

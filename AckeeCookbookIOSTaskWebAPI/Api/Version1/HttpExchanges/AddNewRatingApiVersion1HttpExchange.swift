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
    
    private let id: String
    private let score: Float
    
    init(scheme: String, host: String, id: String, score: Float) {
        self.id = id
        self.score = score
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() -> Result<HttpRequest, Error> {
        let method = Http.Method.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(id)/ratings"
        urlComponents.path = path
        let requestUri = urlComponents.url!
        var headerFields: [String: String] = [:]
        headerFields[Http.HeaderField.contentType] = MediaType.json()
        var jsonValue: JsonObject = JsonObject()
        jsonValue["score"] = score
        let entityBody = try! JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: headerFields, entityBody: entityBody)
        return .success(httpRequest)
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) -> Result<AddedNewRating, Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        let jsonObject = try! JSONSerialization.json(data: messageBody).object()
        if statusCode == Http.StatusCode.ok {
            let id = try! jsonObject.string("id")
            let recipeId = try! jsonObject.string("recipe")
            let score = try! jsonObject.number("score").float
            let addedNewRating = AddedNewRating(id: id, recipeId: recipeId, score: score)
            return .success(addedNewRating)
        } else {
            let error = try! self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
}

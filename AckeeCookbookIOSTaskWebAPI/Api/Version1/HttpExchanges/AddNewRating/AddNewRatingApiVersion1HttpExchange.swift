//
//  ApiVersion1EndpointAddNewRating.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class AddNewRatingApiVersion1HttpExchange: ApiVersion1HttpExchange<AddedRating> {
    
    private let addingRating: AddingRating
    
    init(scheme: String, host: String, addingRating: AddingRating) {
        self.addingRating = addingRating
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let path = basePath + "/recipes/\(addingRating.recipeId)/ratings"
        urlComponents.path = path
        let url = try urlComponents.constructUrl()
        var headers: [String: String] = [:]
        headers[Http.HeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue["score"] = addingRating.score
        let body = try JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, uri: url, version: Http.Version.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> AddedRating {
        let code = httpResponse.code
        guard code == Http.code.ok else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonObject = try JSONSerialization.json(data: body).object()
        let id = try jsonObject.string("id")
        let recipeId = try jsonObject.string("recipe")
        let score = try jsonObject.number("score").float
        let addedNewRating = AddedRating(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}

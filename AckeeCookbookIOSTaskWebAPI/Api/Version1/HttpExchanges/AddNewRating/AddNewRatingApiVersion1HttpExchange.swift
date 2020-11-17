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
        let uri = "\(scheme)://\(host)\(basePath)/recipes/\(addingRating.recipeId)/ratings"
        var headers: [String: String] = [:]
        headers[Http.HeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue["score"] = addingRating.score
        let body = Array(try JSONSerialization.data(jsonValue: jsonValue))
        let httpRequest = PlainHttpRequest(method: method, uri: uri, version: Http.Version.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> AddedRating {
        let code = httpResponse.code
        guard code == Http.Code.ok else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        let body = Data(httpResponse.body ?? [])
        let jsonObject = try JSONSerialization.json(data: body).object()
        let id = try jsonObject.string("id")
        let recipeId = try jsonObject.string("recipe")
        let score = try jsonObject.number("score").float
        let addedNewRating = AddedRating(id: id, recipeId: recipeId, score: score)
        return addedNewRating
    }
    
}

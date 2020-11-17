//
//  ApiVersion1EndpointCreateNewRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation

class CreateNewRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<CreateNewRecipeResult> {
    
    private let creatingRecipe: CreatingRecipe
    
    init(scheme: String, host: String, creatingRecipe: CreatingRecipe) {
        self.creatingRecipe = creatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.post
        let uri = "\(scheme)://\(host)\(basePath)/recipes"
        var headers: [String: String] = [:]
        headers[Http.HeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = creatingRecipe.name
        jsonValue["description"] = creatingRecipe.description
        jsonValue["ingredients"] = creatingRecipe.ingredients
        jsonValue["duration"] = creatingRecipe.duration
        jsonValue["info"] = creatingRecipe.info
        let body = Array(try JSONSerialization.data(jsonValue: jsonValue))
        let httpRequest = PlainHttpRequest(method: method, uri: uri, version: Http.Version.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> CreateNewRecipeResult {
        let code = httpResponse.code
        let body = Data(httpResponse.body ?? [])
        let jsonObject = try JSONSerialization.json(data: body).object()
        if code == Http.Code.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .createdNewRecipe(recipe)
        } else if code == Http.Code.badRequest {
            let message = try jsonObject.string("message")
            if message == ApiVersion1.ErrorMessage.recipeInfoIsRequired {
                return .infoIsRequired
            } else if message == ApiVersion1.ErrorMessage.recipeDescriptionIsRequired {
                return .descriptionIsRequired
            } else if message == ApiVersion1.ErrorMessage.recipeNameMustContainAckee {
                return .nameMustContainAckee
            } else if message == ApiVersion1.ErrorMessage.recipeNameIsRequired {
                return .nameIsRequired
            } else {
                let error = UnexpectedHttpResponseCode(code: code)
                throw error
            }
        } else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
    }
    
}

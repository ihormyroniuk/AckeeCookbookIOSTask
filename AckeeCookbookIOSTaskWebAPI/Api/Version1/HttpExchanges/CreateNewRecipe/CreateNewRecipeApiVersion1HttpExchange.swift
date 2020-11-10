//
//  ApiVersion1EndpointCreateNewRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AFoundation

class CreateNewRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<RecipeInDetails> {
    
    private let creatingRecipe: CreatingRecipe
    
    init(scheme: String, host: String, creatingRecipe: CreatingRecipe) {
        self.creatingRecipe = creatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.post
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
        let requestUri = try urlComponents.constructUrl()
        var headerFields: [String: String] = [:]
        headerFields[Http.HeaderField.contentType] = MediaType.json()
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = creatingRecipe.name
        jsonValue["description"] = creatingRecipe.description
        jsonValue["ingredients"] = creatingRecipe.ingredients
        jsonValue["duration"] = creatingRecipe.duration
        jsonValue["info"] = creatingRecipe.info
        let entityBody = try JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: headerFields, entityBody: entityBody)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> RecipeInDetails {
        let statusCode = httpResponse.statusCode
        guard statusCode == Http.StatusCode.ok else {
            let error = UnexpectedHttpResponseStatusCode(statusCode: statusCode)
            throw error
        }
        let entityBody = httpResponse.entityBody ?? Data()
        let jsonObject = try JSONSerialization.json(data: entityBody).object()
        let recipe = try recipeInDetails(jsonObject: jsonObject)
        return recipe
    }
    
}

//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UpdateRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<UpdateRecipeResult> {
    
    private let updatingRecipe: UpdatingRecipe
    
    init(scheme: String, host: String, updatingRecipe: UpdatingRecipe) {
        self.updatingRecipe = updatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.put
        let uri = "\(scheme)://\(host)\(basePath)/recipes/\(updatingRecipe.recipeId)"
        var headers: [String: String] = [:]
        headers[Http.HeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = updatingRecipe.name
        jsonValue["description"] = updatingRecipe.description
        jsonValue["ingredients"] = updatingRecipe.ingredients
        jsonValue["duration"] = updatingRecipe.duration
        jsonValue["info"] = updatingRecipe.info
        let body = Array(try JSONSerialization.data(jsonValue: jsonValue))
        let httpRequest = PlainHttpRequest(method: method, uri: uri, version: Http.Version.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> UpdateRecipeResult {
        let code = httpResponse.code
        let body = Data(httpResponse.body ?? [])
        let jsonObject = try JSONSerialization.json(data: body).object()
        if code == Http.Code.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .updatedRecipe(recipe)
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

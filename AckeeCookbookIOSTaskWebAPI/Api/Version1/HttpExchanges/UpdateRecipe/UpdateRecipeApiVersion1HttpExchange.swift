//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UpdateRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<RecipeInDetails> {
    
    private let updatingRecipe: UpdatingRecipe
    
    init(scheme: String, host: String, updatingRecipe: UpdatingRecipe) {
        self.updatingRecipe = updatingRecipe
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.put
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(updatingRecipe.recipeId)"
        let url = try urlComponents.constructUrl()
        var headers: [String: String] = [:]
        headers[Http.HeaderField.contentType] = MediaType.json
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = updatingRecipe.name
        jsonValue["description"] = updatingRecipe.description
        jsonValue["ingredients"] = updatingRecipe.ingredients
        jsonValue["duration"] = updatingRecipe.duration
        jsonValue["info"] = updatingRecipe.info
        let body = try JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, uri: url, version: Http.Version.http1dot1, headers: headers, body: body)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> RecipeInDetails {
        let code = httpResponse.code
        guard code == Http.code.ok else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonObject = try JSONSerialization.json(data: body).object()
        let recipe = try recipeInDetails(jsonObject: jsonObject)
        return recipe
    }
    
}

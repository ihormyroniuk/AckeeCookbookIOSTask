//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UpdateRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<RecipeInDetails> {
    
    private let recipeId: String
    private let name: String?
    private let description: String?
    private let ingredients: [String]?
    private let duration: Int?
    private let info: String?
    
    init(scheme: String, host: String, recipeId: String, name: String?, description: String?, ingredients: [String]?, duration: Int?, info: String?) {
        self.recipeId = recipeId
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.info = info
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.put
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(recipeId)"
        let requestUri = try urlComponents.constructUrl()
        var headerFields: [String: String] = [:]
        headerFields[Http.HeaderField.contentType] = MediaType.json()
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = name
        jsonValue["description"] = description
        jsonValue["ingredients"] = ingredients
        jsonValue["duration"] = duration
        jsonValue["info"] = info
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

//
//  ApiVersion1EndpointUpdateRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class UpdateRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<Result<RecipeInDetails, ApiVersion1Error>> {
    
    private let id: String
    private let name: String?
    private let description: String?
    private let ingredients: [String]?
    private let duration: Int?
    private let info: String?
    
    init(scheme: String, host: String, id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: Int? = nil, info: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.ingredients = ingredients
        self.duration = duration
        self.info = info
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() -> HttpRequest {
        let method = Http.Method.put
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        let recipeId = id
        urlComponents.path = basePath + "/recipes/\(recipeId)"
        let requestUri = urlComponents.url!
        var headerFields: [String: String] = [:]
        headerFields[Http.HeaderField.contentType] = MediaType.json()
        var jsonValue: JsonObject = JsonObject()
        jsonValue["name"] = name
        jsonValue["description"] = description
        jsonValue["ingredients"] = ingredients
        jsonValue["duration"] = duration
        jsonValue["info"] = info
        let messageBody = try! JSONSerialization.data(jsonValue: jsonValue)
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: headerFields, messageBody: messageBody)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> Result<RecipeInDetails, ApiVersion1Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.messageBody ?? Data()
        let jsonObject = try JSONSerialization.json(data: messageBody).object()
        if statusCode == Http.StatusCode.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return .success(recipe)
        } else {
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
}

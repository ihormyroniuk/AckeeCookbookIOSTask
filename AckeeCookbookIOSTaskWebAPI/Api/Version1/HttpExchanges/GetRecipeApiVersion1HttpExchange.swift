//
//  ApiVersion1EndpointGetRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class GetRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<RecipeInDetails> {
    
    private let recipeId: String
    
    init(scheme: String, host: String, recipeId: String) {
        self.recipeId = recipeId
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(recipeId)"
        let requestUri = try urlComponents.constructUrl()
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: nil, entityBody: nil)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> RecipeInDetails {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        let jsonObject = try JSONSerialization.json(data: messageBody).object()
        if statusCode == Http.StatusCode.ok {
            let recipe = try recipeInDetails(jsonObject: jsonObject)
            return recipe
        } else {
            let error = try self.error(jsonObject: jsonObject)
            throw error
        }
    }
    
}


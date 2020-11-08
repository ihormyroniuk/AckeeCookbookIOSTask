//
//  ApiVersion1EndpointDeleteRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class DeleteRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<Nothing> {
    
    private let recipeId: String
    
    init(scheme: String, host: String, recipeId: String) {
        self.recipeId = recipeId
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.delete
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(recipeId)"
        let requestUri = urlComponents.url!
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: nil, entityBody: nil)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> Nothing {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        if statusCode == Http.StatusCode.noContent {
            return Nothing()
        } else {
            let jsonObject = try JSONSerialization.json(data: messageBody).object()
            let error = try self.error(jsonObject: jsonObject)
            throw error
        }
    }
    
}

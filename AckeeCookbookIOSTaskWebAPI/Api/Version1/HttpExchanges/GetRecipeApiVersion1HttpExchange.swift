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
    
    private let id: String
    
    init(scheme: String, host: String, id: String) {
        self.id = id
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() -> HttpRequest {
        let method = Http.Method.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let requestUri = urlComponents.url!
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) -> Result<RecipeInDetails, Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.messageBody ?? Data()
        let jsonObject = try! JSONSerialization.json(data: messageBody).object()
        if statusCode == Http.StatusCode.ok {
            let recipe = try! recipeInDetails(jsonObject: jsonObject)
            return .success(recipe)
        } else {
            let error = try! self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
}


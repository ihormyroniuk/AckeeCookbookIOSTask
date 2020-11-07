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
    
    private let id: String
    
    init(scheme: String, host: String, id: String) {
        self.id = id
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() -> Result<HttpRequest, Error> {
        let method = Http.Method.delete
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes/\(id)"
        let requestUri = urlComponents.url!
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1, headerFields: nil, entityBody: nil)
        return .success(httpRequest)
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) -> Result<Nothing, Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        if statusCode == Http.StatusCode.noContent {
            return .success(Nothing())
        } else {
            let jsonObject = try! JSONSerialization.json(data: messageBody).object()
            let error = try! self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
}

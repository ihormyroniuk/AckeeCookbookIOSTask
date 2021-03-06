//
//  ApiVersion1EndpointDeleteRecipe.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class DeleteRecipeApiVersion1HttpExchange: ApiVersion1HttpExchange<Void> {
    
    private let recipeId: String
    
    init(scheme: String, host: String, recipeId: String) {
        self.recipeId = recipeId
        super.init(scheme: scheme, host: host)
    }
    
    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.delete
        let uri = "\(scheme)://\(host)\(basePath)/recipes/\(recipeId)"
        let httpRequest = PlainHttpRequest(method: method, uri: uri, version: Http.Version.http1dot1, headers: nil, body: nil)
        return httpRequest
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) throws -> Void {
        let code = httpResponse.code
        guard code == Http.Code.noContent else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        return ()
    }
    
}

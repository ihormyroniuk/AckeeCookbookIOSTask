//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class GetRecipesApiVersion1HttpExchange: ApiVersion1HttpExchange<[RecipeInList]> {
    
    private let limit: Int
    private let offset: Int
    
    init(scheme: String, host: String, limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
        super.init(scheme: scheme, host: host)
    }

    override func constructHttpRequest() -> Result<HttpRequest, Error> {
        let method = Http.Method.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let requestUri = urlComponents.url!
        let httpVersion = Http.Version.http1dot1
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: httpVersion, headerFields: nil, entityBody: nil)
        return .success(httpRequest)
    }

    override func parseHttpResponse(httpResponse: HttpResponse) -> Result<[RecipeInList], Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.entityBody ?? Data()
        if statusCode == Http.StatusCode.ok {
            var recipes: [RecipeInList] = []
            do {
                let jsonArray = try JSONSerialization.json(data: messageBody).array().arrayObjects()
                for jsonObject in jsonArray {
                    let id = try jsonObject.string("id")
                    let name = try jsonObject.string("name")
                    let duration = try jsonObject.number("duration").int
                    let score = try jsonObject.number("score").float
                    let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
                    recipes.append(recipe)
                }
            } catch {
                
            }
            return .success(recipes)
        } else {
            let error = UnexpectedHttpResponseStatusCode(statusCode: statusCode)
            return .failure(error)
        }
    }

    
}

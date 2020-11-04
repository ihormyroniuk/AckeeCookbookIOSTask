//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class GetRecipesApiVersion1HttpExchange: ApiVersion1HttpExchange<Result<[RecipeInList], ApiVersion1Error>> {
    
    private let limit: Int
    private let offset: Int
    
    init(scheme: String, host: String, limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
        super.init(scheme: scheme, host: host)
    }

    override func constructHttpRequest() -> HttpRequest {
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
        let httpRequest = PlainHttpRequest(method: method, requestUri: requestUri, httpVersion: Http.Version.http1dot1)
        return httpRequest
    }

    override func parseHttpResponse(httpResponse: HttpResponse) throws -> Result<[RecipeInList], ApiVersion1Error> {
        let statusCode = httpResponse.statusCode
        let messageBody = httpResponse.messageBody ?? Data()
        if statusCode == Http.StatusCode.ok {
            let jsonArray = try JSONSerialization.json(data: messageBody).array().arrayObjects()
            var recipes: [RecipeInList] = []
            for jsonObject in jsonArray {
                let recipe = try recipeInList(jsonObject: jsonObject)
                recipes.append(recipe)
            }
            return .success(recipes)
        } else {
            let jsonObject = try JSONSerialization.json(data: messageBody).object()
            let error = try self.error(jsonObject: jsonObject)
            return .failure(error)
        }
    }
    
    private func recipeInList(jsonObject: JsonObject) throws -> RecipeInList {
        let id = try jsonObject.string("id")
        let name = try jsonObject.string("name")
        let duration = try jsonObject.number("duration").int
        let score = try jsonObject.number("score").float
        let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
        return recipe
    }
    
}

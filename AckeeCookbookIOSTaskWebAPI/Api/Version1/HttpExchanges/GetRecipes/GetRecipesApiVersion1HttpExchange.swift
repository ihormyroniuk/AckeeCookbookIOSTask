//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class GetRecipesApiVersion1HttpExchange: ApiVersion1HttpExchange<[RecipeInList]> {
    
    private let part: Part
    
    init(scheme: String, host: String, part: Part) {
        self.part = part
        super.init(scheme: scheme, host: host)
    }

    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.get
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = basePath + "/recipes"
        let offsetQueryItem = URLQueryItem(name: "offset", value: "\(part.offset)")
        let limitQueryItem = URLQueryItem(name: "limit", value: "\(part.limit)")
        let queryItems = [offsetQueryItem, limitQueryItem]
        urlComponents.queryItems = queryItems
        let url = try urlComponents.constructUrl()
        let version = Http.Version.http1dot1
        let httpRequest = PlainHttpRequest(method: method, uri: url, version: version, headers: nil, body: nil)
        return httpRequest
    }

    override func parseHttpResponse(httpResponse: HttpResponse) throws -> [RecipeInList] {
        let code = httpResponse.code
        guard code == Http.code.ok else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        let body = httpResponse.body ?? Data()
        let jsonArray = try JSONSerialization.json(data: body).array().arrayObjects()
        var recipes: [RecipeInList] = []
        for jsonObject in jsonArray {
            let id = try jsonObject.string("id")
            let name = try jsonObject.string("name")
            let duration = try jsonObject.number("duration").int
            let score = try jsonObject.number("score").float
            let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
            recipes.append(recipe)
        }
        return recipes
    }

    
}

//
//  ApiVersion1GetRecipes.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class GetRecipesApiVersion1HttpExchange: ApiVersion1HttpExchange<[RecipeInList]> {
    
    private let portion: Portion
    
    init(scheme: String, host: String, portion: Portion) {
        self.portion = portion
        super.init(scheme: scheme, host: host)
    }

    override func constructHttpRequest() throws -> HttpRequest {
        let method = Http.Method.get
        let uri = "\(scheme)://\(host)\(basePath)/recipes?offset=\(portion.offset)&limit=\(portion.limit)"
        let version = Http.Version.http1dot1
        let httpRequest = PlainHttpRequest(method: method, uri: uri, version: version, headers: nil, body: nil)
        return httpRequest
    }

    override func parseHttpResponse(httpResponse: HttpResponse) throws -> [RecipeInList] {
        let code = httpResponse.code
        guard code == Http.Code.ok else {
            let error = UnexpectedHttpResponseCode(code: code)
            throw error
        }
        let body = Data(httpResponse.body ?? [])
        let jsonArray = try JSONSerialization.json(data: body).array().arrayObjects()
        var recipes: [RecipeInList] = []
        for jsonObject in jsonArray {
            let id = try jsonObject.string("id")
            let name = try jsonObject.string("name")
            let duration = (try jsonObject.number("duration")).int
            let score = (try jsonObject.number("score")).float
            let recipe = RecipeInList(id: id, name: name, duration: duration, score: score)
            recipes.append(recipe)
        }
        return recipes
    }

    
}

//
//  ApiVersion1Endpoint.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1HttpExchange<ParsedHttpResponse>: SchemeHostHttpExchange<ParsedHttpResponse> {
    
    let basePath: String = "/api/v1"
    
    override func constructHttpRequest() -> HttpRequest {
        fatalError()
    }
    
    override func parseHttpResponse(httpResponse: HttpResponse) -> Result<ParsedHttpResponse, Error> {
        fatalError()
    }
    
    func error(jsonObject: JsonObject) throws -> ApiVersion1Error {
        let message = try jsonObject.string("message")
        let errorObject = try jsonObject.object("err")
        let code = try errorObject.number("errorCode").int
        let status = try errorObject.number("status").int
        let name = try errorObject.string("name")
        let error = ApiVersion1Error(code: code, status: status, name: name, message: message)
        return error
    }
    
    func recipeInDetails(jsonObject: JsonObject) throws -> RecipeInDetails {
        let id = try jsonObject.string("id")
        let name = try jsonObject.string("name")
        let description = try jsonObject.string("description")
        let info = try jsonObject.string("info")
        let ingredients = try jsonObject.array("ingredients").arrayStrings()
        let duration = try jsonObject.number("duration").int
        let score = try jsonObject.number("score").float
        let recipe = RecipeInDetails(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
    
}

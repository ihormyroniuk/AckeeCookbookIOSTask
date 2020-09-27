//
//  ApiVersion1Endpoint.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiVersion1Endpoint {
    
    let scheme: String
    let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    func error(jsonObject: JsonObject) throws -> ApiVersion1Error {
        let message = try jsonObject.string("message")
        let errorObject = try jsonObject.object("err")
        let code = try errorObject.number("errorCode").intValue
        let status = try errorObject.number("status").intValue
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
        let duration = try jsonObject.number("duration").intValue
        let score = try jsonObject.number("score").floatValue
        let recipe = RecipeInDetails(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
    
}

struct ApiVersion1Error: Error, LocalizedError {
    
    let code: Int
    let status: Int
    let name: String
    let message: String
    
    var errorDescription: String? {
        return message
    }

}

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
        let message = try jsonObject.stringForKey("message")
        let errorObject = try jsonObject.objectForKey("err")
        let code = try errorObject.numberForKey("errorCode").intValue
        let status = try errorObject.numberForKey("status").intValue
        let name = try errorObject.stringForKey("name")
        let error = ApiVersion1Error(code: code, status: status, name: name, message: message)
        return error
    }
    
    func recipeInDetails(jsonObject: JsonObject) throws -> RecipeInDetails {
        let id = try jsonObject.stringForKey("id")
        let name = try jsonObject.stringForKey("name")
        let description = try jsonObject.stringForKey("description")
        let info = try jsonObject.stringForKey("info")
        let ingredients = try jsonObject.stringsArrayForKey("ingredients")
        let duration = try jsonObject.numberForKey("duration").intValue
        let score = try jsonObject.numberForKey("score").floatValue
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

//
//  ApiVersion1Endpoint.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 25.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

struct WebApiVersion1Error: Error {
    let code: Int
    let status: Int
    let name: String
}

class ApiVersion1Endpoint {
    
    let scheme: String
    let host: String
    let basePath: String = "/api/v1"
    let contentTypeHeaderKey = "Content-Type"
    let contentTypeHeaderValueJson = "application/json"
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    func error(jsonObject: JsonObject) throws -> WebApiVersion1Error {
        let code = try jsonObject.numberForKey("errorCode").intValue
        let status = try jsonObject.numberForKey("status").intValue
        let name = try jsonObject.stringForKey("name")
        let error = WebApiVersion1Error(code: code, status: status, name: name)
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
        let recipe = RecipeInDetailsStructure(id: id, name: name, duration: duration, description: description, info: info, ingredients: ingredients, score: score)
        return recipe
    }
    
}

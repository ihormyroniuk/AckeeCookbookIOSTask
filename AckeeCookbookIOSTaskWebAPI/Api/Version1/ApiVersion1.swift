//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

class ApiVersion1 {
    
    let scheme: String
    let host: String
    
    public init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    func getRecipesHttpExchange(limit: Int, offset: Int) -> GetRecipesApiVersion1HttpExchange {
        let httpExchange = GetRecipesApiVersion1HttpExchange(scheme: scheme, host: host, limit: limit, offset: offset)
        return httpExchange
    }
    
    func createNewRecipeHttpExchange(name: String, description: String, ingredients: [String]? = nil, duration: Int? = nil, info: String? = nil) -> CreateNewRecipeApiVersion1HttpExchange {
        let httpExchange = CreateNewRecipeApiVersion1HttpExchange(scheme: scheme, host: host, name: name, description: description, ingredients: ingredients, duration: duration, info: info)
        return httpExchange
    }
    
    func getRecipesHttpExchange(id: String) -> GetRecipeApiVersion1HttpExchange {
        let httpExchange = GetRecipeApiVersion1HttpExchange(scheme: scheme, host: host, id: id)
        return httpExchange
    }
    
    func updateRecipeHttpExchange(id: String, name: String? = nil, description: String? = nil, ingredients: [String]? = nil, duration: Int? = nil, info: String? = nil) -> UpdateRecipeApiVersion1HttpExchange {
        let httpExchange = UpdateRecipeApiVersion1HttpExchange(scheme: scheme, host: host, id: id, name: name, description: description, ingredients: ingredients, duration: duration, info: info)
        return httpExchange
    }
    
    func deleteRecipeHttpExchange(id: String) -> DeleteRecipeApiVersion1HttpExchange {
        let httpExchange = DeleteRecipeApiVersion1HttpExchange(scheme: scheme, host: host, id: id)
        return httpExchange
    }
    
    func addNewRatingHttpExchange(id: String, score: Float) -> AddNewRatingApiVersion1HttpExchange {
        let httpExchange = AddNewRatingApiVersion1HttpExchange(scheme: scheme, host: host, id: id, score: score)
        return httpExchange
    }
    
}

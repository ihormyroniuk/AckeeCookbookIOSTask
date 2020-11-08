//
//  ApiVersion1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

class ApiVersion1 {
    
    private let scheme: String
    private let host: String
    
    init(scheme: String, host: String) {
        self.scheme = scheme
        self.host = host
    }
    
    func getRecipesHttpExchange(limit: Int, offset: Int) -> GetRecipesApiVersion1HttpExchange {
        let httpExchange = GetRecipesApiVersion1HttpExchange(scheme: scheme, host: host, limit: limit, offset: offset)
        return httpExchange
    }
    
    func createNewRecipeHttpExchange(name: String, description: String, ingredients: [String]?, duration: Int?, info: String?) -> CreateNewRecipeApiVersion1HttpExchange {
        let httpExchange = CreateNewRecipeApiVersion1HttpExchange(scheme: scheme, host: host, name: name, description: description, ingredients: ingredients, duration: duration, info: info)
        return httpExchange
    }
    
    func getRecipeHttpExchange(id: String) -> GetRecipeApiVersion1HttpExchange {
        let httpExchange = GetRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: id)
        return httpExchange
    }
    
    func updateRecipeHttpExchange(id: String, name: String?, description: String?, ingredients: [String]?, duration: Int?, info: String?) -> UpdateRecipeApiVersion1HttpExchange {
        let httpExchange = UpdateRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: id, name: name, description: description, ingredients: ingredients, duration: duration, info: info)
        return httpExchange
    }
    
    func deleteRecipeHttpExchange(id: String) -> DeleteRecipeApiVersion1HttpExchange {
        let httpExchange = DeleteRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: id)
        return httpExchange
    }
    
    func addNewRatingHttpExchange(id: String, score: Float) -> AddNewRatingApiVersion1HttpExchange {
        let httpExchange = AddNewRatingApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: id, score: score)
        return httpExchange
    }
    
}

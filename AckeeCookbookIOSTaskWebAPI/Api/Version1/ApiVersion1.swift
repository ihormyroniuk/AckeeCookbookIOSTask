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
    
    func createNewRecipeHttpExchange(creatingRecipe: CreatingRecipe) -> CreateNewRecipeApiVersion1HttpExchange {
        let httpExchange = CreateNewRecipeApiVersion1HttpExchange(scheme: scheme, host: host, creatingRecipe: creatingRecipe)
        return httpExchange
    }
    
    func getRecipeHttpExchange(recipeId: String) -> GetRecipeApiVersion1HttpExchange {
        let httpExchange = GetRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: recipeId)
        return httpExchange
    }
    
    func updateRecipeHttpExchange(updatingRecipe: UpdatingRecipe) -> UpdateRecipeApiVersion1HttpExchange {
        let httpExchange = UpdateRecipeApiVersion1HttpExchange(scheme: scheme, host: host, updatingRecipe: updatingRecipe)
        return httpExchange
    }
    
    func deleteRecipeHttpExchange(recipeId: String) -> DeleteRecipeApiVersion1HttpExchange {
        let httpExchange = DeleteRecipeApiVersion1HttpExchange(scheme: scheme, host: host, recipeId: recipeId)
        return httpExchange
    }
    
    func addNewRatingHttpExchange(addingRating: AddingRating) -> AddNewRatingApiVersion1HttpExchange {
        let httpExchange = AddNewRatingApiVersion1HttpExchange(scheme: scheme, host: host, addingRating: addingRating)
        return httpExchange
    }
    
}

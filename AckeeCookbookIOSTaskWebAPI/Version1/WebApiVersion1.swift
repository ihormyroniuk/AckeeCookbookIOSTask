//
//  Version1.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 04.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

enum WebApiVersion1GetRecipesResponse {
    case recipes([RecipeInList])
    case error(WebApiVersion1Error)
}

enum WebApiVersion1CreateNewRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

enum WebApiVersion1GetRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

enum WebApiVersion1UpdateRecipeResponse {
    case recipe(RecipeInDetails)
    case error(WebApiVersion1Error)
}

enum WebApiVersion1DeleteRecipeResponse {
    case success
    case error(WebApiVersion1Error)
}

enum WebApiVersion1AddNewRatingResponse {
    case rating(AddedNewRating)
    case error(WebApiVersion1Error)
}

protocol WebApiVersion1Error: Error {
    var code: Int { get }
    var status: Int { get }
    var name: String { get }
}

protocol WebApiVersion1 {
    
    var scheme: String { get }
    var host: String { get }
    
    // MARK: Recipes
    
    func getRecipesRequest(limit: Int, offset: Int) -> URLRequest
    func getRecipesResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipesResponse
    
    // MARK: Create new recipe
    
    func createNewRecipeRequest(name: String, description: String, ingredients: [String]?, duration: Int?, info: String?) -> URLRequest
    func createNewRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1CreateNewRecipeResponse
    
    // MARK: Get recipe
    
    func getRecipeRequest(id: String) -> URLRequest
    func getRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1GetRecipeResponse
    
    // MARK: Update recipe
    
    func updateRecipeRequest(id: String, name: String?, description: String?, ingredients: [String]?, duration: Int?, info: String?) -> URLRequest
    func updateRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1UpdateRecipeResponse
    
    // MARK: Delete recipe
    
    func deleteRecipeRequest(id: String) -> URLRequest
    func deleteRecipeResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1DeleteRecipeResponse
    
    // MARK: Add new rating
    
    func addNewRatingRequest(id: String, score: Float) -> URLRequest
    func addNewRatingResponse(response: HTTPURLResponse, data: Data) throws -> WebApiVersion1AddNewRatingResponse
}

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
    case error(Error)
}

enum WebApiVersion1CreateNewRecipeResponse {
    case recipe(RecipeInDetails)
    case error(Error)
}

enum WebApiVersion1GetRecipeResponse {
    case recipe(RecipeInDetails)
    case error(Error)
}

enum WebApiVersion1UpdateRecipeResponse {
    case recipe(RecipeInDetails)
    case error(Error)
}

enum WebApiVersion1DeleteRecipeResponse {
    case deleted
    case error(Error)
}

enum WebApiVersion1AddNewRatingResponse {
    case rating(AddedNewRating)
    case error(Error)
}

protocol WebApiVersion1Error: Error {
    var code: Int { get }
    var status: Int { get }
    var name: String { get }
}

protocol WebApiVersion1 {
    
    // MARK: Recipes
    
    func getRecipesRequest(limit: UInt, offset: UInt) -> URLRequest
    func getRecipesResponse(response: URLResponse, data: Data) -> WebApiVersion1GetRecipesResponse
    
    // MARK: Create new recipe
    
    func createNewRecipeRequest(name: String, description: String, ingredients: [String]?, duration: UInt?, info: String?) -> URLRequest
    func createNewRecipeResponse(response: URLResponse, data: Data) -> WebApiVersion1CreateNewRecipeResponse
    
    // MARK: Get recipe
    
    func getRecipeRequest(id: String) -> URLRequest
    func getRecipeResponse(response: URLResponse, data: Data) -> WebApiVersion1GetRecipeResponse
    
    // MARK: Update recipe
    
    func updateRecipeRequest(id: String, name: String?, description: String?, ingredients: [String]?, duration: UInt?, info: String?) -> URLRequest
    func updateRecipeResponse(response: URLResponse, data: Data) -> WebApiVersion1UpdateRecipeResponse
    
    // MARK: Delete recipe
    
    func deleteRecipeRequest(id: String) -> URLRequest
    func deleteRecipeResponse(response: URLResponse, data: Data) -> WebApiVersion1DeleteRecipeResponse
    
    // MARK: Add new rating
    
    func addNewRatingRequest(id: String, score: Float) -> URLRequest
    func addNewRatingResponse(response: URLResponse, data: Data) -> WebApiVersion1AddNewRatingResponse
}

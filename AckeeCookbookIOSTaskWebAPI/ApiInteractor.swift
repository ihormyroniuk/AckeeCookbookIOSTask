//
//  WebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public protocol ApiInteractor {
    func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ())
    func createNewRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func getRecipe(_ recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func deleteRecipe(_ recipeId: String, completionHandler: @escaping (Error?) -> ())
    func addNewRating(_ recipeId: String, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ())
}

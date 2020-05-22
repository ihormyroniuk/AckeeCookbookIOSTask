//
//  Presentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit
import AckeeCookbookIOSTaskBusiness

public enum GetRecipesResult {
    case recipes([RecipeInList])
    case error(Error)
}

public protocol PresentationDelegate: class {
    func presentationGetRecipes(_ presentation: Presentation, offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesResult) -> ())
    func presentationCreateRecipe(_ presentation: Presentation, recipe: CreatingRecipe)
    func presentationGetRecipe(_ presentation: Presentation, recipe: RecipeInList)
    func presentationDeleteRecipe(_ presentation: Presentation, recipe: RecipeInDetails)
    func presentationScoreRecipe(_ presentation: Presentation, recipe: RecipeInDetails, score: Float)
    func presentationUpdateRecipe(_ presentation: Presentation, recipe: UpdatingRecipe)
}

public protocol Presentation {
    func showRecipesList()
    var delegate: PresentationDelegate? { get set }
    func takeCreatedRecipe(_ recipe: RecipeInDetails)
    func errorCreatedRecipe(_ error: Error, recipe: CreatingRecipe)
    func takeRecipeInDetails(_ recipe: RecipeInDetails, recipeInList: RecipeInList)
    func errorGetRecipeInDetails(_ error: Error, recipeInList: RecipeInList)
    func deleteRecipeInDetails(_ recipe: RecipeInDetails)
    func errorDeleteRecipe(_ error: Error, recipe: RecipeInDetails)
    func scoreRecipe(_ recipe: RecipeInDetails, score: Float)
    func errorScoreRecipe(_ error: Error, recipe: RecipeInDetails, score: Float)
    func updateRecipe(_ recipe: RecipeInDetails)
    func errorUpdateRecipe(_ error: Error, recipe: UpdatingRecipe)
}

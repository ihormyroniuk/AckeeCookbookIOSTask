//
//  Presentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit
import AckeeCookbookIOSTaskBusiness

public protocol PresentationDelegate: class {
    func presentationGetRecipes(_ presentation: Presentation, offset: UInt, limit: UInt, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ())
    func presentationCreateRecipe(_ presentation: Presentation, recipe: CreatingRecipe)
    func presentationGetRecipe(_ presentation: Presentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func presentationDeleteRecipe(_ presentation: Presentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ())
    func presentationScoreRecipe(_ presentation: Presentation, recipe: RecipeInDetails, score: Float)
    func presentationUpdateRecipe(_ presentation: Presentation, recipe: UpdatingRecipe)
}

public protocol Presentation {
    func showRecipesList()
    var delegate: PresentationDelegate? { get set }
    func takeCreatedRecipe(_ recipe: RecipeInDetails)
    func errorCreatedRecipe(_ error: Error, recipe: CreatingRecipe)
    func scoreRecipe(_ recipe: RecipeInDetails, score: Float)
    func errorScoreRecipe(_ error: Error, recipe: RecipeInDetails, score: Float)
    func updateRecipe(_ recipe: RecipeInDetails)
    func errorUpdateRecipe(_ error: Error, recipe: UpdatingRecipe)
}

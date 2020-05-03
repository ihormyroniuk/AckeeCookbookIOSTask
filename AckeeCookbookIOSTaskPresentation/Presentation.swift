//
//  Presentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public protocol PresentationDelegate: class {
    func presentationGetRecipesList(_ presentation: Presentation, offset: UInt, limit: UInt)
    func presentationCreateRecipe(_ presentation: Presentation, recipe: CreatingRecipe)
    func presentationGetRecipeInDetails(_ presentation: Presentation, recipeInList: RecipeInList)
    func presentationDeleteRecipe(_ presentation: Presentation, recipe: RecipeInDetails)
    func presentationScoreRecipe(_ presentation: Presentation, recipe: RecipeInDetails, score: Float)
    func presentationUpdateRecipe(_ presentation: Presentation, recipe: UpdatingRecipe)
}

public protocol Presentation: AUIPresentation {
    var delegate: PresentationDelegate? { get set }
    func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt)
    func takeCreatedRecipe(_ recipe: RecipeInDetails)
    func takeRecipeInDetails(_ recipe: RecipeInDetails, recipeInList: RecipeInList)
    func deleteRecipeInDetails(_ recipe: RecipeInDetails)
    func changeRecipeScore(_ recipe: RecipeInDetails, score: Float)
    func updateRecipe(_ recipe: RecipeInDetails)
    func showRecipesList()
}

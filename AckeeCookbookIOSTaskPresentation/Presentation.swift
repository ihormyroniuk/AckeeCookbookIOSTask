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
    func presentationCreateRecipe(_ presentation: Presentation, creatingRecipe: CreatingRecipe)
    func presentationGetRecipeInDetails(_ presentation: Presentation, recipeInList: RecipeInList)
    func presentationDeleteRecipeInDetails(_ presentation: Presentation, recipeInDetails: RecipeInDetails)
}

public protocol Presentation: AUIPresentation {
    var delegate: PresentationDelegate? { get set }
    func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt)
    func takeCreatedRecipe(_ recipe: RecipeInDetails)
    func takeRecipeInDetails(_ recipeInDetails: RecipeInDetails, recipeInList: RecipeInList)
    func deleteRecipeInDetails(_ recipeInDetails: RecipeInDetails)
    func showRecipesList()
}

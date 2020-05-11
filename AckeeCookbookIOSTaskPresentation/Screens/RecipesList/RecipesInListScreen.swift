//
//  RecipesListScreen.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/27/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

protocol RecipesInListScreenDelegate: class {
    func recipesInListScreenAddRecipe(_ recipesListScreen: RecipesInListScreen)
    func recipesInListScreenGetRecipes(_ recipesListScreen: RecipesInListScreen, offset: UInt, limit: UInt)
    func recipesInListScreenShowRecipeInDetails(_ recipesListScreen: RecipesInListScreen, recipeInList: RecipeInList)
}

protocol RecipesInListScreen: AUIScreen {
    var delegate: RecipesInListScreenDelegate? { get set }
    func takeRecipesInList(_ recipes: [RecipeInList], offset: UInt, limit: UInt)
    func takeErrorGetRecipesInList(_ error: Error, offset: UInt, limit: UInt)
    func knowRecipeWasAdded(_ recipe: RecipeInList)
    func knowRecipeWasDeleted(_ recipe: RecipeInList)
    func knowRecipeScoreWasChanged(_ recipe: RecipeInList, score: Float)
    func knowRecipeWasUpdated(_ recipe: RecipeInList)
}

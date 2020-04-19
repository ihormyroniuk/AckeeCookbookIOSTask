//
//  RecipesListScreen.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/27/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

protocol RecipesListScreenDelegate: class {
    func recipesListScreenAddRecipe(_ recipesListScreen: RecipesListScreen)
    func recipesListScreenGetList(_ recipesListScreen: RecipesListScreen, offset: UInt, limit: UInt)
    func recipesListScreenShowRecipeInDetails(_ recipesListScreen: RecipesListScreen, recipeInList: RecipeInList)
}

protocol RecipesListScreen: AUIScreen {
    var delegate: RecipesListScreenDelegate? { get set }
    func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt)
    func knowRecipeCreated(_ recipe: RecipeInDetails)
    func deleteRecipe(_ recipe: RecipeInList)
}

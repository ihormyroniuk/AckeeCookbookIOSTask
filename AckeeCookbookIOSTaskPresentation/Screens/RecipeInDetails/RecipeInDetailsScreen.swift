//
//  RecipeDetailsScreen.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 4/5/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

protocol RecipesInDetailsScreenDelegate: class {
    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeInDetailsScreen)
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInList: RecipeInList)
    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInDetails: RecipeInDetails)
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipe: RecipeInDetails, score: Float)
}

protocol RecipeInDetailsScreen: AUIScreen {
    var delegate: RecipesInDetailsScreenDelegate? { get set }
    func takeRecipeInDetails(_ recipeInDetails: RecipeInDetails, recipeInList: RecipeInList)
    func changeRecipeScore(_ recipe: RecipeInDetails, score: Float)
}

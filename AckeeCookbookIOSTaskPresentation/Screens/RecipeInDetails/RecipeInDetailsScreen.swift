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
    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipesListScreen)
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipesListScreen, recipeInList: RecipeInList)
}

protocol RecipeInDetailsScreen: AUIScreen {
    var delegate: RecipesInDetailsScreenDelegate? { get set }
    func takeRecipeInDetails(_ recipeInDetails: Recipe, recipeInList: RecipeInList)
}

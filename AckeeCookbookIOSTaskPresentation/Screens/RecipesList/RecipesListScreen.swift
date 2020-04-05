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
    func recipesListScreenGetList(offset: UInt, limit: UInt)
}

protocol RecipesListScreen: AUIScreen {
    var delegate: RecipesListScreenDelegate? { get set }
    func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt)
    func knowRecipeCreated(_ recipe: Recipe)
}

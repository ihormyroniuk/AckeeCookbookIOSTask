//
//  Application.swift
//  AckeeCookbookIOSTask
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskPresentation
import AckeeCookbookIOSTaskWebAPI
import AckeeCookbookIOSTaskBusiness

class Application: AUIEmptyApplication, PresentationDelegate {
    
    // MARK: Launching

    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentation.showRecipesList()
        sleep(4)
    }

    // MARK: Presentation

    private lazy var presentation: Presentation = {
        let presentation = IPhonePresentation(window: window)
        presentation.delegate = self
        return presentation
    }()

    func presentationGetRecipes(_ presentation: Presentation, offset: UInt, limit: UInt) {
        webApi.getRecipes(offset: offset, limit: limit) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .recipes(recipes):
                self.presentation.takeRecipes(recipes, offset: offset, limit: limit)
            case let .error(error):
                self.presentation.errorGetRecipes(error, offset: offset, limit: limit)
            }
        }
    }

    func presentationCreateRecipe(_ presentation: Presentation, recipe: CreatingRecipe) {
        webApi.createRecipe(recipe) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .recipe(recipe):
                self.presentation.takeCreatedRecipe(recipe)
            case let .error(error):
                self.presentation.errorCreatedRecipe(error, recipe: recipe)
            }
        }
    }
    
    func presentationGetRecipe(_ presentation: Presentation, recipe: RecipeInList) {
        let recipeId = recipe.id
        webApi.getRecipe(recipeId) { (result) in
            switch result {
            case let .recipe(recipe):
                self.presentation.takeRecipeInDetails(recipe, recipeInList: recipe)
            case let .error(error):
                self.presentation.errorGetRecipeInDetails(error, recipeInList: recipe)
            }
        }
    }
    
    func presentationDeleteRecipe(_ presentation: Presentation, recipe: RecipeInDetails) {
        let recipeId = recipe.id
        webApi.deleteRecipe(recipeId) { (result) in
            switch result {
            case .deleted:
                self.presentation.deleteRecipeInDetails(recipe)
            case let .error(error):
                self.presentation.errorDeleteRecipe(error, recipe: recipe)
            }
        }
    }
    
    func presentationScoreRecipe(_ presentation: Presentation, recipe: RecipeInDetails, score: Float) {
        let recipeId = recipe.id
        webApi.scoreRecipe(recipeId, score: score) { (result) in
            switch result {
            case let .score(score):
                self.presentation.scoreRecipe(recipe, score: score)
            case let .error(error):
                self.presentation.errorScoreRecipe(error, recipe: recipe, score: score)
            }
        }
    }
    
    func presentationUpdateRecipe(_ presentation: Presentation, recipe: UpdatingRecipe) {
        webApi.updateRecipe(recipe) { (result) in
            switch result {
            case let .recipe(recipe):
                self.presentation.updateRecipe(recipe)
            case let .error(error):
                self.presentation.errorUpdateRecipe(error, recipe: recipe)
            }
        }
    }

    // MARK: WebAPI

    private lazy var webApi: WebApiPerformer = {
        let webAPI = WebApiPerformerUrlSessionShared()
        return webAPI
    }()
}

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
        window?.makeKeyAndVisible()
    }

    // MARK: Presentation
    
    private lazy var presentation: Presentation = {
        let presentation = IPhonePresentation(window: window)
        presentation.delegate = self
        return presentation
    }()

    func presentationGetRecipes(_ presentation: Presentation, offset: UInt, limit: UInt, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        webApi.getRecipes(offset: offset, limit: limit) { (result) in
            let presentationResult: Result<[RecipeInList], Error>
            switch result {
            case .recipes(let recipes):
                presentationResult = .success(recipes)
            case .error(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
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
    
    func presentationGetRecipe(_ presentation: Presentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let recipeId = recipe.id
        webApi.getRecipe(recipeId) { (result) in
            let presentationResult: Result<RecipeInDetails, Error>
            switch result {
            case .recipe(let recipe):
                presentationResult = .success(recipe)
            case .error(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func presentationDeleteRecipe(_ presentation: Presentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ()) {
        let recipeId = recipe.id
        webApi.deleteRecipe(recipeId) { (result) in
            switch result {
            case .deleted:
                completionHandler(nil)
            case let .error(error):
                completionHandler(error)
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
        let webApi = WebApiPerformerUrlSessionShared()
        return webApi
    }()
}

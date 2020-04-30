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
    }

    // MARK: Presentation

    private lazy var presentation: Presentation = {
        let presentation = IPhonePresentation(window: window)
        presentation.delegate = self
        return presentation
    }()

    func presentationGetRecipesList(_ presentation: Presentation, offset: UInt, limit: UInt) {
        webAPI.getRecipesList(offset: offset, limit: limit) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .recipesList(recipes):
                self.presentation.takeRecipesList(recipes, offset: offset, limit: limit)
            case let .error(error):
                print(error)
                break
            }
        }
    }

    func presentationCreateRecipe(_ presentation: Presentation, creatingRecipe: CreatingRecipe) {
        webAPI.createRecipe(creatingRecipe) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .createdRecipe(recipe):
                self.presentation.takeCreatedRecipe(recipe)
            case let .error(error):
                print(error)
                break
            }
        }
    }
    
    func presentationGetRecipeInDetails(_ presentation: Presentation, recipeInList: RecipeInList) {
        let recipeId = recipeInList.id
        webAPI.getRecipeInDetails(recipeId) { (result) in
            switch result {
            case let .recipeInDetails(recipe):
                self.presentation.takeRecipeInDetails(recipe, recipeInList: recipeInList)
            case let .error(error):
                print(error)
                break
            }
        }
    }
    
    func presentationDeleteRecipeInDetails(_ presentation: Presentation, recipeInDetails: RecipeInDetails) {
        let recipeId = recipeInDetails.id
        webAPI.deleteRecipe(recipeId) { (result) in
            switch result {
            case .deleted:
                self.presentation.deleteRecipeInDetails(recipeInDetails)
            case let .error(error):
                print(error)
                break
            }
        }
    }
    
    func presentationSetRecipeScore(_ presentation: Presentation, recipe: RecipeInDetails, score: Float) {
        let recipeId = recipe.id
        webAPI.setRecipeScore(recipeId, score: score) { (result) in
            switch result {
            case let .recipeScore(score):
                self.presentation.changeRecipeScore(recipe, score: score)
            case let .error(error):
                print(error)
                break
            }
        }
    }

    // MARK: WebAPI

    private lazy var webAPI: WebAPI = {
        let webAPI = URLSessionSharedWebAPI()
        return webAPI
    }()
}

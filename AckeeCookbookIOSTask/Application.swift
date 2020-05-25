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

class Application: AUIEmptyApplication, IPhonePresentationDelegate {
    
    // MARK: Launching
    
    override func didFinishLaunching() {
        super.didFinishLaunching()
        iPhonePresentation.showRecipesList()
        window?.makeKeyAndVisible()
    }

    // MARK: Presentation
    
    private lazy var iPhonePresentation: IPhonePresentation = {
        let iPhonePresentation = IPhonePresentation(window: window!)
        iPhonePresentation.delegate = self
        return iPhonePresentation
    }()

    func iPhonePresentationGetRecipes(_ iPhonePresentation: IPhonePresentation, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
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

    func iPhonePresentationCreateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: CreatingRecipe,  completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        webApi.createRecipe(recipe) { (result) in
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
    
    func iPhonePresentationGetRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        webApi.getRecipe(recipe.id) { (result) in
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
    
    func iPhonePresentationDeleteRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ()) {
        webApi.deleteRecipe(recipe.id) { (result) in
            switch result {
            case .deleted:
                completionHandler(nil)
            case let .error(error):
                completionHandler(error)
            }
        }
    }
    
    func iPhonePresentationScoreRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        webApi.scoreRecipe(recipe.id, score: score) { (result) in
            let presentationResult: Result<Float, Error>
            switch result {
            case let .score(score):
                presentationResult = .success(score)
            case let .error(error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationUpdateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        webApi.updateRecipe(recipe) { (result) in
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

    // MARK: WebAPI

    private lazy var webApi: WebApiPerformer = {
        let webApi = WebApiPerformerUrlSessionShared()
        return webApi
    }()
}

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
        presentationWindow.makeKeyAndVisible()
        iPhonePresentation.showRecipesList()
    }

    // MARK: Presentation
    
    private lazy var presentationWindow: UIWindow = {
        return window ?? UIWindow()
    }()
    
    private lazy var iPhonePresentation: IPhonePresentation = {
        let iPhonePresentation = IPhonePresentation(window: presentationWindow)
        iPhonePresentation.delegate = self
        return iPhonePresentation
    }()

    func iPhonePresentationGetRecipes(_ iPhonePresentation: IPhonePresentation, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        apiInteractor.getRecipes(offset: offset, limit: limit) { (result) in
            let presentationResult: Result<[RecipeInList], Error>
            switch result {
            case .success(let recipes):
                presentationResult = .success(recipes)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }

    func iPhonePresentationCreateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: CreatingRecipe,  completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        apiInteractor.createNewRecipe(recipe) { (result) in
            let presentationResult: Result<RecipeInDetails, Error>
            switch result {
            case .success(let recipe):
                presentationResult = .success(recipe)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationGetRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        apiInteractor.getRecipe(recipe.id) { (result) in
            let presentationResult: Result<RecipeInDetails, Error>
            switch result {
            case .success(let recipe):
                presentationResult = .success(recipe)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationDeleteRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ()) {
        apiInteractor.deleteRecipe(recipe.id) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func iPhonePresentationScoreRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        apiInteractor.addNewRating(recipe.id, score: score) { (result) in
            let presentationResult: Result<Float, Error>
            switch result {
            case let .success(addedNewRating):
                let score = addedNewRating.score
                presentationResult = .success(score)
            case let .failure(error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }
    
    func iPhonePresentationUpdateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        apiInteractor.updateRecipe(recipe) { (result) in
            let presentationResult: Result<RecipeInDetails, Error>
            switch result {
            case .success(let recipe):
                presentationResult = .success(recipe)
            case .failure(let error):
                presentationResult = .failure(error)
            }
            completionHandler(presentationResult)
        }
    }

    // MARK: WebAPI

    private lazy var apiInteractor: ApiInteractor = {
        let apiInteractor = ApiInteractors.production
        return apiInteractor
    }()
    
}

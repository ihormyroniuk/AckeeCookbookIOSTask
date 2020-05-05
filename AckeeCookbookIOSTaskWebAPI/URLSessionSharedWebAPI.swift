//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public class URLSessionSharedWebAPI: WebAPI {

    private let session = URLSession.shared
    
    private let version1: Version1

    public init() {
        let version1Scheme = "https"
        let version1Host = "cookbook.ack.ee"
        self.version1 = Version1SchemeHost(scheme: version1Scheme, host: version1Host)
    }

    public func getRecipesList(offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesListResult) -> ()) {
        let request = version1.getRecipesRequest(limit: limit, offset: offset)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.getRecipesResponse(response: response, data: data)
                switch response {
                case .recipes(let recipes):
                    completionHandler(.recipesList(recipes))
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }

    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (CreateRecipeResult) -> ()) {
        let request = version1.createNewRecipeRequest(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.createNewRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.createdRecipe(recipe))
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    public func getRecipeInDetails(_ recipeId: String, completionHandler: @escaping (GetRecipeInDetailsResult) -> ()) {
        let request = version1.getRecipeRequest(id: recipeId)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.getRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.recipeInDetails(recipe))
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (UpdateRecipeResult) -> ()) {
        let request = version1.updateRecipeRequest(id: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.updateRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.updatedRecipe(recipe))
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (DeleteRecipeResult) -> ()) {
        let request = version1.deleteRecipeRequest(id: recipeId)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.deleteRecipeResponse(response: response, data: data)
                switch response {
                case .deleted:
                    completionHandler(.deleted)
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    public func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (SetRecipeScoreResult) -> ()) {
        let request = version1.addNewRatingRequest(id: recipeId, score: score)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.addNewRatingResponse(response: response, data: data)
                switch response {
                case .score(let score):
                    completionHandler(.recipeScore(score))
                case .error(let error):
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }

}

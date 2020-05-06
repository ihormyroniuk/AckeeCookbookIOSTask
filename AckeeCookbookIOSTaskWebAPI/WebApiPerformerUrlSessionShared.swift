//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation
import AckeeCookbookIOSTaskBusiness

public class WebApiPerformerUrlSessionShared: WebApiPerformer {

    private let session = URLSession.shared
    
    private let version1: WebApiVersion1

    public init() {
        let version1Scheme = "https"
        let version1Host = "cookbook.ack.ee"
        self.version1 = WebApiVersion1SchemeHost(scheme: version1Scheme, host: version1Host)
    }

    public func getRecipes(offset: UInt, limit: UInt, completionHandler: @escaping (WebApiPerformerGetRecipesResult) -> ()) {
        let request = version1.getRecipesRequest(limit: limit, offset: offset)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.getRecipesResponse(response: response, data: data)
                switch response {
                case .recipes(let recipes):
                    completionHandler(.recipes(recipes))
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

    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (WebApiPerformerCreateRecipeResult) -> ()) {
        let request = version1.createNewRecipeRequest(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.createNewRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.recipe(recipe))
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
    
    public func getRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerGetRecipeResult) -> ()) {
        let request = version1.getRecipeRequest(id: recipeId)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.getRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.recipe(recipe))
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
    
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (WebApiPerformerUpdateRecipeResult) -> ()) {
        let request = version1.updateRecipeRequest(id: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.updateRecipeResponse(response: response, data: data)
                switch response {
                case .recipe(let recipe):
                    completionHandler(.recipe(recipe))
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
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerDeleteRecipeResult) -> ()) {
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
    
    public func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (WebApiPerformerScoreRecipeResult) -> ()) {
        let request = version1.addNewRatingRequest(id: recipeId, score: score)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response {
                let response = self.version1.addNewRatingResponse(response: response, data: data)
                switch response {
                case .rating(let rating):
                    completionHandler(.score(rating.score))
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

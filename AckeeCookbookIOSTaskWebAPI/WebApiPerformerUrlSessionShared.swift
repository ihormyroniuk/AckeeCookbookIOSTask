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
    
    public init() { }
    
    private let session = URLSession.shared
    
    let version1Scheme = "https"
    let version1Host = "cookbook.ack.ee"
    
    private lazy var version1GetRecipes = ApiVersion1EndpointGetRecipes(scheme: version1Scheme, host: version1Host)
    
    public func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (WebApiPerformerGetRecipesResult) -> ()) {
        let request = version1GetRecipes.request(limit: limit, offset: offset)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1GetRecipes.response(response: response, data: data)
                    switch version1Response {
                    case .recipes(let recipes):
                        completionHandler(.recipes(recipes))
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    private lazy var version1CreateNewRecipe = ApiVersion1EndpointCreateNewRecipe(scheme: version1Scheme, host: version1Host)

    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (WebApiPerformerCreateRecipeResult) -> ()) {
        let request = version1CreateNewRecipe.request(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1CreateNewRecipe.response(response: response, data: data)
                    switch version1Response {
                    case .recipe(let recipe):
                        completionHandler(.recipe(recipe))
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    private lazy var version1GetRecipe = ApiVersion1EndpointGetRecipe(scheme: version1Scheme, host: version1Host)
    
    public func getRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerGetRecipeResult) -> ()) {
        let request = version1GetRecipe.request(id: recipeId)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1GetRecipe.response(response: response, data: data)
                    switch version1Response {
                    case .recipe(let recipe):
                        completionHandler(.recipe(recipe))
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    private lazy var version1UpdateRecipe = ApiVersion1EndpointUpdateRecipe(scheme: version1Scheme, host: version1Host)
    
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (WebApiPerformerUpdateRecipeResult) -> ()) {
        let request = version1UpdateRecipe.request(id: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1UpdateRecipe.response(response: response, data: data)
                    switch version1Response {
                    case .recipe(let recipe):
                        completionHandler(.recipe(recipe))
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    private lazy var version1DeleteRecipe = ApiVersion1EndpointDeleteRecipe(scheme: version1Scheme, host: version1Host)
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (WebApiPerformerDeleteRecipeResult) -> ()) {
        let request = version1DeleteRecipe.request(id: recipeId)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response  = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1DeleteRecipe.response(response: response, data: data)
                    switch version1Response {
                    case .success:
                        completionHandler(.deleted)
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            } else {
                let error = UnknownError()
                completionHandler(.error(error))
            }
        }
        dataTask.resume()
    }
    
    private lazy var version1AddNewRating = ApiVersion1EndpointAddNewRating(scheme: version1Scheme, host: version1Host)
    
    public func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (WebApiPerformerScoreRecipeResult) -> ()) {
        let request = version1AddNewRating.request(id: recipeId, score: score)
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completionHandler(.error(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try self.version1AddNewRating.response(response: response, data: data)
                    switch version1Response {
                    case .rating(let rating):
                        sleep(3)
                        completionHandler(.score(rating.score))
                    case .error(let error):
                        completionHandler(.error(error))
                    }
                } catch {
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

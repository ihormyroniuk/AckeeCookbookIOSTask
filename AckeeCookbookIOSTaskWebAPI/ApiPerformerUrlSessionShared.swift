//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiPerformerUrlSessionShared: ApiPerformer {
    
    private let session = URLSession.shared
    
    private let version1Scheme: String
    private let version1Host: String
    
    public init(version1Scheme: String, version1Host: String) {
        self.version1Scheme = version1Scheme
        self.version1Host = version1Host
    }
    
    public func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        let endpoint = ApiVersion1EndpointGetRecipes(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(limit: limit, offset: offset)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let response = try endpoint.response(response: response, data: data)
                    switch response {
                    case .success(let recipes):
                        completionHandler(.success(recipes))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                let error = InternalError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func createRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let endpoint = ApiVersion1EndpointCreateNewRecipe(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try endpoint.response(response: response, data: data)
                    switch version1Response {
                    case .success(let recipe):
                        completionHandler(.success(recipe))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                let error = InternalError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func getRecipe(_ recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let endpoint = ApiVersion1EndpointGetRecipe(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(id: recipeId)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try endpoint.response(response: response, data: data)
                    switch version1Response {
                    case .success(let recipe):
                        completionHandler(.success(recipe))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                let error = InternalError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
   
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let endpoint = ApiVersion1EndpointUpdateRecipe(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(id: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try endpoint.response(response: response, data: data)
                    switch version1Response {
                    case .success(let recipe):
                        completionHandler(.success(recipe))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                let error = InternalError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (Error?) -> ()) {
        let endpoint = ApiVersion1EndpointDeleteRecipe(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(id: recipeId)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(error)
            } else if let data = data, let response  = response as? HTTPURLResponse {
                do {
                    let version1Response = try endpoint.response(response: response, data: data)
                    if let error = version1Response {
                        completionHandler(error)
                    } else {
                        completionHandler(nil)
                    }
                } catch {
                    completionHandler(error)
                }
            } else {
                let error = InternalError()
                completionHandler(error)
            }
        }
        dataTask.resume()
    }
    
    public func scoreRecipe(_ recipeId: String, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        let endpoint = ApiVersion1EndpointAddNewRating(scheme: version1Scheme, host: version1Host)
        let request = endpoint.request(id: recipeId, score: score)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                do {
                    let version1Response = try endpoint.response(response: response, data: data)
                    switch version1Response {
                    case .success(let rating):
                        completionHandler(.success(rating.score))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                let error = InternalError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }

}

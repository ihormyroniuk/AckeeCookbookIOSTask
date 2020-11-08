//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation
import AckeeCookbookIOSTaskBusiness

class ApiInteractorUrlSessionShared: ApiInteractor {
    
    private let scheme: String
    private let host: String
    private let session = URLSession.shared
    private let api: Api
    
    public init(version1Scheme: String, version1Host: String) {
        self.scheme = version1Scheme
        self.host = version1Host
        let api = Api(scheme: scheme, host: host)
        self.api = api
    }
    
    public func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        let httpExchange = api.version1.getRecipesHttpExchange(limit: limit, offset: offset)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    print("fsdf")
                }
                completionHandler(.failure(error))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let recipes = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(.success(recipes))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func createNewRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let httpExchange = api.version1.createNewRecipeHttpExchange(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func getRecipe(_ recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let httpExchange = api.version1.getRecipeHttpExchange(recipeId: recipeId)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
   
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        let httpExchange = api.version1.updateRecipeHttpExchange(recipeId: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (Error?) -> ()) {
        let httpExchange = api.version1.deleteRecipeHttpExchange(recipeId: recipeId)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(error)
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                _ = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(nil)
            } else {
                let error = UnexpectedError()
                completionHandler(error)
            }
        }
        dataTask.resume()
    }
    
    public func addNewRating(_ recipeId: String, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        let httpExchange = api.version1.addNewRatingHttpExchange(recipeId: recipeId, score: score)
        let httpRequest = try! httpExchange.constructHttpRequest()
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response = try! httpExchange.parseHttpResponse(httpResponse: httpResponse)
                completionHandler(.success(response.score))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }

}

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
    
    public func getRecipes(offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], ApiInteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipesHttpExchange(limit: limit, offset: offset)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(.failure(apiInteractionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: [RecipeInList]
                do {
                    response = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    public func createNewRecipe(_ recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ()) {
        let httpExchange = api.version1.createNewRecipeHttpExchange(name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(.failure(apiInteractionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: RecipeInDetails
                do {
                    response = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    public func getRecipe(_ recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipeHttpExchange(recipeId: recipeId)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(.failure(apiInteractionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: RecipeInDetails
                do {
                    response = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
   
    public func updateRecipe(_ recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, ApiInteractionError>) -> ()) {
        let httpExchange = api.version1.updateRecipeHttpExchange(recipeId: recipe.id, name: recipe.name, description: recipe.description, ingredients: recipe.ingredients, duration: recipe.duration, info: recipe.info)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(.failure(apiInteractionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: RecipeInDetails
                do {
                    response = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    public func deleteRecipe(_ recipeId: String, completionHandler: @escaping (ApiInteractionError?) -> ()) {
        let httpExchange = api.version1.deleteRecipeHttpExchange(recipeId: recipeId)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.unexpectedError(error: error))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(apiInteractionError)
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                do {
                    _ = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.unexpectedError(error: error))
                    return
                }
                completionHandler(nil)
            } else {
                let error = UnexpectedError()
                completionHandler(.unexpectedError(error: error))
            }
        }
        dataTask.resume()
    }
    
    public func addNewRating(_ recipeId: String, score: Float, completionHandler: @escaping (Result<AddedNewRating, ApiInteractionError>) -> ()) {
        let httpExchange = api.version1.addNewRatingHttpExchange(recipeId: recipeId, score: score)
        let httpRequest: HttpRequest
        do {
            httpRequest = try httpExchange.constructHttpRequest()
        } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let apiInteractionError = ApiInteractorUrlSessionShared.constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: error)
                completionHandler(.failure(apiInteractionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: AddedNewRating
                do {
                    response = try httpExchange.parseHttpResponse(httpResponse: httpResponse)
                } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(response))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    private static func constructApiInteractionErrorFromURLSessionDataTaskResumeError(error: Error) -> ApiInteractionError {
        let apiInteractionError: ApiInteractionError
        if (error as NSError).code == NSURLErrorNotConnectedToInternet {
            apiInteractionError = .notConnectedToInternet
        } else {
            apiInteractionError = .unexpectedError(error: error)
        }
        return apiInteractionError
    }

}

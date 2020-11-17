//
//  URLSessionSharedWebAPI.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 3/30/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AFoundation

class UrlSessionSharedInteractor: Interactor {
    
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
    
    public func getRecipes(portion: Portion, completionHandler: @escaping (Result<[RecipeInList], InteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipesHttpExchange(portion: portion)
        let httpRequest: HttpRequest
        do { httpRequest = try httpExchange.constructHttpRequest() } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let interactionError = InteractionError(error: error)
                completionHandler(.failure(interactionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: [RecipeInList]
                do { response = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
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
    
    public func createNewRecipe(creatingRecipe: CreatingRecipe, completionHandler: @escaping (Result<CreateNewRecipeResult, InteractionError>) -> ()) {
        let httpExchange = api.version1.createNewRecipeHttpExchange(creatingRecipe: creatingRecipe)
        let httpRequest: HttpRequest
        do { httpRequest = try httpExchange.constructHttpRequest() } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let interactionError = InteractionError(error: error)
                completionHandler(.failure(interactionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let result: CreateNewRecipeResult
                do { result = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(result))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    public func getRecipe(recipeId: String, completionHandler: @escaping (Result<RecipeInDetails, InteractionError>) -> ()) {
        let httpExchange = api.version1.getRecipeHttpExchange(recipeId: recipeId)
        let httpRequest: HttpRequest
        do { httpRequest = try httpExchange.constructHttpRequest() } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let interactionError = InteractionError(error: error)
                completionHandler(.failure(interactionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: RecipeInDetails
                do { response = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
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
   
    public func updateRecipe(updatingRecipe: UpdatingRecipe, completionHandler: @escaping (Result<UpdateRecipeResult, InteractionError>) -> ()) {
        let httpExchange = api.version1.updateRecipeHttpExchange(updatingRecipe: updatingRecipe)
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
                let interactionError = InteractionError(error: error)
                completionHandler(.failure(interactionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let result: UpdateRecipeResult
                do { result = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
                    let error = UnexpectedHttpResponseError(httpRequest: httpRequest, httpResponse: httpResponse, error: error)
                    completionHandler(.failure(.unexpectedError(error: error)))
                    return
                }
                completionHandler(.success(result))
            } else {
                let error = UnexpectedError()
                completionHandler(.failure(.unexpectedError(error: error)))
            }
        }
        dataTask.resume()
    }
    
    public func deleteRecipe(recipeId: String, completionHandler: @escaping (InteractionError?) -> ()) {
        let httpExchange = api.version1.deleteRecipeHttpExchange(recipeId: recipeId)
        let httpRequest: HttpRequest
        do { httpRequest = try httpExchange.constructHttpRequest() } catch {
            completionHandler(.unexpectedError(error: error))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let interactionError = InteractionError(error: error)
                completionHandler(interactionError)
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                do { _ = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
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
    
    public func addNewRating(addingRating: AddingRating, completionHandler: @escaping (Result<AddedRating, InteractionError>) -> ()) {
        let httpExchange = api.version1.addNewRatingHttpExchange(addingRating: addingRating)
        let httpRequest: HttpRequest
        do { httpRequest = try httpExchange.constructHttpRequest() } catch {
            completionHandler(.failure(.unexpectedError(error: error)))
            return
        }
        let urlRequest = URLRequest(httpRequest: httpRequest)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                let interactionError = InteractionError(error: error)
                completionHandler(.failure(interactionError))
            } else if let httpUrlResponse = response as? HTTPURLResponse {
                let httpResponse = HTTPURLResponseDataHttpResponse(httpUrlResponse: httpUrlResponse, data: data)
                let response: AddedRating
                do { response = try httpExchange.parseHttpResponse(httpResponse: httpResponse) } catch {
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

}

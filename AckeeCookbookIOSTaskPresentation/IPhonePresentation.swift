//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public protocol IPhonePresentationDelegate: class {
    func iPhonePresentationGetRecipes(_ iPhonePresentation: IPhonePresentation, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ())
    func iPhonePresentationCreateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: CreatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func iPhonePresentationGetRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
    func iPhonePresentationDeleteRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, completionHandler: @escaping (Error?) -> ())
    func iPhonePresentationScoreRecipe(_ iPhonePresentation: IPhonePresentation, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ())
    func iPhonePresentationUpdateRecipe(_ iPhonePresentation: IPhonePresentation, recipe: UpdatingRecipe, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ())
}

public class IPhonePresentation: AUIWindowPresentation, RecipesListScreenDelegate, AddRecipeScreenControllerDelegate, RecipesDetailsScreenControllerDelegate, UpdateRecipeScreenDelegate {

    // MARK: Setup
    
    public override func setup() {
        super.setup()
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
//        let height = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
//        print(height)
//        self.window.frame.size.height = height
//        self.window.setNeedsLayout()
//        self.window.layoutIfNeeded()
    }

    // MARK: Presentation
    
    public func showRecipesList() {
        let navigationController = AUIHiddenBarInteractiveNavigationController()
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        screenController.delegate = self
        navigationController.viewControllers = [screenController]
        self.mainNavigationController = navigationController
        self.recipesListScreen = screenController
        self.window.rootViewController = navigationController
    }

    public weak var delegate: IPhonePresentationDelegate?

    // MARK: Main Navigation Controller

    private weak var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private weak var recipesListScreen: RecipesListScreenController?

    func recipesListScreenAddRecipe(_ recipesListScreen: RecipesListScreenController) {
        let screenView = AddRecipeScreenView()
        let screenController = AddRecipeScreenController(view: screenView)
        screenController.delegate = self
        addRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    func recipesListScreenGetRecipes(_ recipesListScreen: RecipesListScreenController, offset: Int, limit: Int, completionHandler: @escaping (Result<[RecipeInList], Error>) -> ()) {
        delegate?.iPhonePresentationGetRecipes(self, offset: offset, limit: limit, completionHandler: { (result) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        })
    }

    func recipesListScreenShowRecipeDetails(_ recipesListScreen: RecipesListScreenController, recipeInList: RecipeInList) {
        let screenView = RecipeDetailsScreenView()
        let screenController = RecipeDetailsScreenController(view: screenView, recipeInList: recipeInList)
        screenController.delegate = self
        recipeInDetailsScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    // MARK: Add Recipe Screen

    private weak var addRecipeScreen: AddRecipeScreenController?

    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }

    func addRecipeScreenAddRecipe(_ addRecipeScreen: AddRecipeScreenController, _ recipe: CreatingRecipe) {
        delegate?.iPhonePresentationCreateRecipe(self, recipe: recipe, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let recipe):
                    self.mainNavigationController?.popViewController(animated: true)
                    self.recipesListScreen?.knowRecipeWasAdded(recipe.recipeInList)
                    break
                case .failure(let error):
                    let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .destructive)
                    alert.addAction(okAction)
                    self.mainNavigationController?.present(alert, animated: true, completion: nil)
                }
            }
        })
    }

    // MARK: Recipe In Details Screen

    private weak var recipeInDetailsScreen: RecipeDetailsScreenController?

    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeDetailsScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInList: RecipeInList, completionHandler: @escaping (Result<RecipeInDetails, Error>) -> ()) {
        delegate?.iPhonePresentationGetRecipe(self, recipe: recipeInList, completionHandler: { (result) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        })
    }

    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails) {
        let alertController = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .alert)
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            self.delegate?.iPhonePresentationDeleteRecipe(self, recipe: recipeInDetails, completionHandler: { (error) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.recipesListScreen?.knowRecipeWasDeleted(recipeInDetails.recipeInList)
                    guard let recipesListScreen = self.recipesListScreen else { return }
                    self.mainNavigationController?.popToViewController(recipesListScreen, animated: true)
                }
            })
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)
        mainNavigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func recipeInDetailsScreenUpdateRecipeInDetails(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipeInDetails: RecipeInDetails) {
        let screenView = UpdateRecipeScreenView()
        let screenController = UpdateRecipeScreenController(view: screenView, recipe: recipeInDetails)
        screenController.delegate = self
        updateRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }
    
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeDetailsScreenController, recipe: RecipeInDetails, score: Float, completionHandler: @escaping (Result<Float, Error>) -> ()) {
        delegate?.iPhonePresentationScoreRecipe(self, recipe: recipe, score: score, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let score):
                    completionHandler(result)
                    self.recipesListScreen?.knowRecipeScoreWasChanged(recipe.recipeInList, score: score)
                case .failure(let error):
                    completionHandler(result)
                    let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .destructive)
                    alert.addAction(okAction)
                    self.mainNavigationController?.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    // MARK: Update Recipe Screen

    private weak var updateRecipeScreen: UpdateRecipeScreenController?
    
    func updateRecipeScreenBack(_ updateRecipeScreen: UpdateRecipeScreenController) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func updateRecipeScreenUpdateRecipe(_ recipe: UpdatingRecipe) {
        delegate?.iPhonePresentationUpdateRecipe(self, recipe: recipe, completionHandler: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let recipe):
                    self.recipeInDetailsScreen?.updateRecipe(recipe)
                    self.recipesListScreen?.knowRecipeWasUpdated(recipe.recipeInList)
                    self.mainNavigationController?.popViewController(animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .destructive)
                    alert.addAction(okAction)
                    self.mainNavigationController?.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
}

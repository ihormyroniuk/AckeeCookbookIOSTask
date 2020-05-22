//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public class IPhonePresentation: Presentation, RecipesInListScreenDelegate, AddRecipeScreenDelegate, RecipesInDetailsScreenDelegate, UpdateRecipeScreenDelegate {
    
    // MARK: Elements
    
    public let window: UIWindow
    
    // MARK: Initializer
    
    public init(window: UIWindow? = nil) {
        self.window = window ?? UIWindow()
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object:nil)
    }
    
    @objc private func keyboardWillChangeFrame(notification: NSNotification) {
        print(notification)
        let height = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.origin.y
        //UIView.animate(withDuration: 0.25) {
            self.mainNavigationController?.view.frame.size.height = height
            //self.mainNavigationController?.view.layoutIfNeeded()
        //}
    }

    // MARK: Presentation
    
    public func showRecipesList() {
        let navigationController = AUIHiddenBarInteractiveNavigationController()
        let screenView = RecipesInListScreenView()
        let screenController = RecipesInListScreenController(view: screenView)
        screenController.delegate = self
        navigationController.viewControllers = [screenController]
        self.mainNavigationController = navigationController
        self.recipesListScreen = screenController
        self.window.rootViewController = navigationController
    }

    public weak var delegate: PresentationDelegate?

    public func takeCreatedRecipe(_ recipe: RecipeInDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainNavigationController?.popViewController(animated: true)
            self.recipesListScreen?.knowRecipeWasAdded(recipe)
        }
    }
    
    public func errorCreatedRecipe(_ error: Error, recipe: CreatingRecipe) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive)
            alert.addAction(okAction)
            self.mainNavigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func takeRecipeInDetails(_ recipe: RecipeInDetails, recipeInList: RecipeInList) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipeInDetailsScreen?.takeRecipeInDetails(recipe, recipeInList: recipeInList)
        }
    }
    
    public func errorGetRecipeInDetails(_ error: Error, recipeInList: RecipeInList) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//        }
    }
    
    public func deleteRecipeInDetails(_ recipe: RecipeInDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesListScreen?.knowRecipeWasDeleted(recipe)
            guard let recipesListScreen = self.recipesListScreen else { return }
            self.mainNavigationController?.popToViewController(recipesListScreen, animated: true)
        }
    }
    
    public func errorDeleteRecipe(_ error: Error, recipe: RecipeInDetails) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//        }
    }
    
    public func scoreRecipe(_ recipe: RecipeInDetails, score: Float) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesListScreen?.knowRecipeScoreWasChanged(recipe, score: score)
            self.recipeInDetailsScreen?.changeRecipeScore(recipe, score: score)
        }
    }
    
    public func errorScoreRecipe(_ error: Error, recipe: RecipeInDetails, score: Float) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//        }
    }
    
    public func updateRecipe(_ recipe: RecipeInDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipeInDetailsScreen?.updateRecipe(recipe)
            self.recipesListScreen?.knowRecipeWasUpdated(recipe)
            self.mainNavigationController?.popViewController(animated: true)
        }
    }
    
    public func errorUpdateRecipe(_ error: Error, recipe: UpdatingRecipe) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//
//        }
    }

    // MARK: Main Navigation Controller

    private weak var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private weak var recipesListScreen: RecipesInListScreen?

    func recipesInListScreenAddRecipe(_ recipesListScreen: RecipesInListScreen) {
        let screenView = AddRecipeScreenView()
        let screenController = AddRecipeScreenController(view: screenView)
        screenController.delegate = self
        addRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    func recipesInListScreenGetRecipes(_ recipesListScreen: RecipesInListScreen, offset: UInt, limit: UInt, completionHandler: @escaping (GetRecipesResult) -> ()) {
        delegate?.presentationGetRecipes(self, offset: offset, limit: limit, completionHandler: { (result) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        })
    }

    func recipesInListScreenShowRecipeInDetails(_ recipesListScreen: RecipesInListScreen, recipeInList: RecipeInList) {
        let screenView = RecipeInDetailsScreenView()
        let screenController = RecipeInDetailsScreenController(view: screenView, recipeInList: recipeInList)
        screenController.delegate = self
        recipeInDetailsScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    // MARK: Add Recipe Screen

    private weak var addRecipeScreen: AddRecipeScreen?

    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreen) {
        mainNavigationController?.popViewController(animated: true)
    }

    func addRecipeScreenAddRecipe(_ recipe: CreatingRecipe) {
        delegate?.presentationCreateRecipe(self, recipe: recipe)
    }

    // MARK: Recipe In Details Screen

    private weak var recipeInDetailsScreen: RecipeInDetailsScreen?

    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeInDetailsScreen) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInList: RecipeInList) {
        delegate?.presentationGetRecipe(self, recipe: recipeInList)
    }

    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInDetails: RecipeInDetails) {
        let alertController = UIAlertController(title: "Alert", message: "This is an alert.", preferredStyle: .alert)
        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            self.delegate?.presentationDeleteRecipe(self, recipe: recipeInDetails)
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)
        mainNavigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func recipeInDetailsScreenUpdateRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInDetails: RecipeInDetails) {
        let screenView = AddRecipeScreenView()
        let screenController = UpdateRecipeScreenController(view: screenView, recipe: recipeInDetails)
        screenController.delegate = self
        updateRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }
    
    func recipeInDetailsScreenSetScore(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipe: RecipeInDetails, score: Float) {
        delegate?.presentationScoreRecipe(self, recipe: recipe, score: score)
    }
    
    // MARK: Update Recipe Screen

    private weak var updateRecipeScreen: UpdateRecipeScreen?
    
    func updateRecipeScreenBack(_ updateRecipeScreen: UpdateRecipeScreen) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func updateRecipeScreenUpdateRecipe(_ recipe: UpdatingRecipe) {
        delegate?.presentationUpdateRecipe(self, recipe: recipe)
    }
    
}

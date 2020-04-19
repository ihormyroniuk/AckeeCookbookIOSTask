//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public class IPhonePresentation: AUIWindowPresentation, Presentation, RecipesListScreenDelegate, AddRecipeScreenDelegate, RecipesInDetailsScreenDelegate {

    // MARK: Presentation

    public weak var delegate: PresentationDelegate?

    public func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesListScreen?.takeRecipesList(list, offset: offset, limit: limit)
        }
    }

    public func takeCreatedRecipe(_ recipe: RecipeInDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainNavigationController?.popViewController(animated: true)
            self.recipesListScreen?.knowRecipeCreated(recipe)
        }
    }
    
    public func takeRecipeInDetails(_ recipeInDetails: RecipeInDetails, recipeInList: RecipeInList) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipeInDetailsScreen?.takeRecipeInDetails(recipeInDetails, recipeInList: recipeInList)
        }
    }

    public func showRecipesList() {
        let navigationController = AUIHiddenBarInteractiveNavigationController()
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        screenController.delegate = self
        navigationController.viewControllers = [screenController]
        mainNavigationController = navigationController
        recipesListScreen = screenController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    public func deleteRecipeInDetails(_ recipeInDetails: RecipeInDetails) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesListScreen?.deleteRecipe(recipeInDetails)
            guard let recipesListScreen = self.recipesListScreen else { return }
            self.mainNavigationController?.popToViewController(recipesListScreen, animated: true)
        }
    }

    // MARK: Main Navigation Controller

    private var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private weak var recipesListScreen: RecipesListScreen?

    func recipesListScreenAddRecipe(_ recipesListScreen: RecipesListScreen) {
        let screenView = AddRecipeScreenView()
        let screenController = AddRecipeScreenController(view: screenView)
        screenController.delegate = self
        addRecipeScreen = screenController
        mainNavigationController?.pushViewController(screenController, animated: true)
    }

    func recipesListScreenGetList(_ recipesListScreen: RecipesListScreen, offset: UInt, limit: UInt) {
        delegate?.presentationGetRecipesList(self, offset: offset, limit: limit)
    }

    func recipesListScreenShowRecipeInDetails(_ recipesListScreen: RecipesListScreen, recipeInList: RecipeInList) {
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
        delegate?.presentationCreateRecipe(self, creatingRecipe: recipe)
    }

    // MARK: Recipe In Details Screen

    private weak var recipeInDetailsScreen: RecipeInDetailsScreen?

    func recipeInDetailsScreenBack(_ recipeInDetailsScreen: RecipeInDetailsScreen) {
        mainNavigationController?.popViewController(animated: true)
    }
    
    func recipeInDetailsScreenGetRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInList: RecipeInList) {
        delegate?.presentationGetRecipeInDetails(self, recipeInList: recipeInList)
    }

    func recipeInDetailsScreenDeleteRecipeInDetails(_ recipeInDetailsScreen: RecipeInDetailsScreen, recipeInDetails: RecipeInDetails) {
        delegate?.presentationDeleteRecipeInDetails(self, recipeInDetails: recipeInDetails)
    }
    
}

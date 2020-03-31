//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public class IPhonePresentation: AUIWindowPresentation, Presentation, RecipesListScreenDelegate, AddRecipeScreenDelegate {

    // MARK: Presentation

    public weak var delegate: PresentationDelegate?

    public func takeRecipesList(_ list: [RecipeInList], offset: UInt, limit: UInt) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesListScreen?.takeRecipesList(list, offset: offset, limit: limit)
        }
    }

    public func takeCreatedRecipe(_ recipe: Recipe) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mainNavigationController?.popToRootViewController(animated: true)
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

    func recipesListScreenGetList(offset: UInt, limit: UInt) {
        delegate?.presentationGetRecipesList(self, offset: offset, limit: limit)
    }

    // MARK: Add Recipe Screen

    private weak var addRecipeScreen: AddRecipeScreen?

    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreen) {
        mainNavigationController?.popViewController(animated: true)
    }

    func addRecipeScreenAddRecipe(_ recipe: CreatingRecipe) {
        delegate?.presentationCreateRecipe(self, creatingRecipe: recipe)
    }
    
}

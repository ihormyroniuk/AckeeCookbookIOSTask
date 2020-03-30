//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

public class IPhonePresentation: AUIWindowPresentation, Presentation, RecipesListScreenDelegate {

    // MARK: Main Navigation Controller

    private var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private var recipesList: RecipesListScreen?

    func recipesListScreenAddRecepe(_ recipesListScreen: RecipesListScreen) {
        
    }

    func recipesListScreenGetList(offset: UInt, limit: UInt) {
        
    }

    // MARK: Presentation

    public func showRecipesList() {
        let navigationController = AUIHiddenBarInteractiveNavigationController()
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        screenController.delegate = self
        navigationController.viewControllers = [screenController]
        mainNavigationController = navigationController
        recipesList = screenController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

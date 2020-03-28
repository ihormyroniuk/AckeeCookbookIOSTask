//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

public class IPhonePresentation: AUIWindowPresentation, Presentation {

    // MARK: Main Navigation Controller

    private var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private var recipesList: RecipesListScreen?

    // MARK: Presentation

    public func showRecipesList() {
        let navigationController = AUIHiddenBarInteractiveNavigationController()
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        navigationController.viewControllers = [screenController]
        mainNavigationController = navigationController
        recipesList = screenController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}

//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public class IPhonePresentation: AUIWindowPresentation, Presentation, RecipesListScreenDelegate {

    // MARK: Presentation

    public weak var delegate: PresentationDelegate?

    public func takeRecipesList(_ list: [Recipe], offset: UInt, limit: UInt) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.recipesList?.takeRecipesList(list, offset: offset, limit: limit)
        }
    }

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

    // MARK: Main Navigation Controller

    private var mainNavigationController: UINavigationController?

    // MARK: Recipes List Screen

    private var recipesList: RecipesListScreen?

    func recipesListScreenAddRecepe(_ recipesListScreen: RecipesListScreen) {
        
    }

    func recipesListScreenGetList(offset: UInt, limit: UInt) {
        delegate?.presentationGetRecipesList(self, offset: offset, limit: limit)
    }
    
}

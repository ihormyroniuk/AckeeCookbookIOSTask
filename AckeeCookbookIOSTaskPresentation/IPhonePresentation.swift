//
//  IPhonePresentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

public class IPhonePresentation: AUIWindowPresentation, Presentation {

    public func showRecipesList() {
        let screenView = RecipesListScreenView()
        let screenController = RecipesListScreenController(view: screenView)
        window.rootViewController = screenController
        window.makeKeyAndVisible()
    }
    
}

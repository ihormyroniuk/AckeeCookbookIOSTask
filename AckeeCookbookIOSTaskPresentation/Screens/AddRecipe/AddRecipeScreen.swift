//
//  AddRecipeScreen.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

protocol AddRecipeScreenDelegate: class {
    func addRecipeScreenBack(_ addRecipeScreen: AddRecipeScreen)
    func addRecipeScreenAddRecipe(_ recipe: CreatingRecipe)
}

protocol AddRecipeScreen: AUIScreen {
    var delegate: AddRecipeScreenDelegate? { get set }
}

//
//  UpdateRecipeScreen.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 26.04.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

protocol UpdateRecipeScreenDelegate: class {
    func updateRecipeScreenBack(_ updateRecipeScreen: UpdateRecipeScreen)
    func updateRecipeScreenUpdateRecipe(_ recipe: UpdatingRecipe)
}

protocol UpdateRecipeScreen: AUIScreen {
    var delegate: UpdateRecipeScreenDelegate? { get set }
}

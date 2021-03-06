//
//  CreateNewRecipeResult.swift
//  AckeeCookbookIOSTaskWebAPI
//
//  Created by Ihor Myroniuk on 17.11.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public enum CreateNewRecipeResult {
    case createdNewRecipe(RecipeInDetails)
    case infoIsRequired
    case descriptionIsRequired
    case nameIsRequired
    case nameMustContainAckee
}

//
//  RecipeInDetails.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 3/31/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol RecipeInDetails: RecipeInList {
    var id: String { get }
    var name: String { get }
    var duration: Int { get }
    var description: String { get }
    var info: String { get }
    var ingredients: [String] { get }
    var score: Float { get set }
}

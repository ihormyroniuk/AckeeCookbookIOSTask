//
//  AddedNewRating.swift
//  AckeeCookbookIOSTaskBusiness
//
//  Created by Ihor Myroniuk on 06.05.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import Foundation

public protocol AddedNewRating {
    var id: String { get }
    var recipeId: String { get }
    var score: Float { get }
}

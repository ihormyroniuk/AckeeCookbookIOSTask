//
//  Presentation.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskBusiness

public protocol PresentationDelegate: class {
    func presentationGetRecipesList(_ presentation: Presentation, offset: UInt, limit: UInt)
}

public protocol Presentation: AUIPresentation {
    var delegate: PresentationDelegate? { get set }
    func takeRecipesList(_ list: [Recipe], offset: UInt, limit: UInt)
    func showRecipesList()
}

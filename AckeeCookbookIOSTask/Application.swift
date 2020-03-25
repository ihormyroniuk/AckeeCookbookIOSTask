//
//  Application.swift
//  AckeeCookbookIOSTask
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskPresentation

class Application: AUIEmptyApplication {

    // MARK: Presentation

    lazy var presentation: Presentation = {
        let presentation = IPhonePresentation(window: window)
        return presentation
    }()

    // MARK: Launching

    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentation.showRecipesList()
    }
}

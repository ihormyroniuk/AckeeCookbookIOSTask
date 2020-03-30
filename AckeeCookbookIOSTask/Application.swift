//
//  Application.swift
//  AckeeCookbookIOSTask
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit
import AckeeCookbookIOSTaskPresentation
import AckeeCookbookIOSTaskWebAPI

class Application: AUIEmptyApplication, PresentationDelegate {

    // MARK: Presentation

    lazy var presentation: Presentation = {
        let presentation = IPhonePresentation(window: window)
        presentation.delegate = self
        return presentation
    }()

    func presentationGetRecipesList(_ presentation: Presentation, offset: UInt, limit: UInt) {
        webAPI.getRecipesList(offset: offset, limit: limit) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .list(recipes):
                self.presentation.takeRecipesList(recipes, offset: offset, limit: limit)
            case let .error(error):
                print(error)
                break
            }
        }
    }

    // MARK: WebAPI

    lazy var webAPI: WebAPI = {
        let webAPI = URLSessionSharedWebAPI()
        return webAPI
    }()

    // MARK: Launching

    override func didFinishLaunching() {
        super.didFinishLaunching()
        presentation.showRecipesList()
    }
}

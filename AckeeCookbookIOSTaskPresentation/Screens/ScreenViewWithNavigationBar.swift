//
//  ScreenViewWithNavigationBar.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 3/27/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import AUIKit

class ScreenViewWithNavigationBar: AUIScreenViewWithStatusBar {

    // MARK: Elements

    let navigationBarView = UIView()

    // MARK: Setup

    override func setup() {
        super.setup()
        addSubview(navigationBarView)
        setupNavigationBarView()
    }

    func setupNavigationBarView() {

    }

    // MARK: Layout

    override func layout() {
        super.layout()
        layoutNavigationBarView()
    }

    func layoutNavigationBarView() {
        let x: CGFloat = 0
        let y: CGFloat = statusBarView.frame.origin.y + statusBarView.frame.size.height
        let width: CGFloat = statusBarView.frame.size.width
        let height: CGFloat = 44
        let frame = CGRect(x: x, y: y, width: width, height: height)
        navigationBarView.frame = frame
    }

}

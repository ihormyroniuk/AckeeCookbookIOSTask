//
//  main.swift
//  AckeeCookbookIOSTask
//
//  Created by Ihor Myroniuk on 3/25/20.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(Application.self),
    NSStringFromClass(Application.self)
)

var application: Application! {
    return UIApplication.shared as? Application
}

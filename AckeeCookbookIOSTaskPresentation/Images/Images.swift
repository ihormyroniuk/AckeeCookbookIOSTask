//
//  Images.swift
//  AckeeCookbookIOSTaskPresentation
//
//  Created by Ihor Myroniuk on 20.04.2020.
//  Copyright © 2020 Ihor Myroniuk. All rights reserved.
//

import UIKit
import os

private class Class {
    
}

enum Images {
    
    private static let bundle = Bundle(for: Class.self)
    private static let emptyImage = UIImage()
    private static func image(named name: String) -> UIImage {
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else {
            os_log("This is a log message.", type: .fault)
            return emptyImage
        }
        return image
    }
    
    static var clock: UIImage {
        return image(named: "Clock")
    }
    
    static var back: UIImage {
        return image(named: "Back")
    }
    
    static var plus: UIImage {
        return image(named: "Plus")
    }
    
    static var plusInCircle: UIImage {
        return image(named: "PlusInCircle")
    }
    
    static var star: UIImage {
        return image(named: "Star")
    }
    
    static var ackeeRecipe: UIImage {
        return image(named: "AckeeRecipe")
    }
    
}

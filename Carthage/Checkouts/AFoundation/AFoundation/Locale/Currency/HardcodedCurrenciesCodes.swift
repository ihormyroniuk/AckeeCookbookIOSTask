//
//  AOSHardcodedCurrenciesCodes.swift
//  AOperatingSystem
//
//  Created by Ihor Myroniuk on 2/26/19.
//  Copyright © 2019 Ihor Myroniuk. All rights reserved.
//

import Foundation

private let unitedStatesDollarCode = "USD"
private let ukrainianHryvniaCode = "UAH"
private let russianRubleCode = "RUB"

class HardcodedCurrenciesCodes: CurrenciesCodes {
  
    func codeOfCurrency(_ currency: ACurrency) -> String? {
        switch currency {
        case .unitedStatesDollar: return unitedStatesDollarCode
        case .ukrainianHryvnia: return ukrainianHryvniaCode
        case .russianRuble: return russianRubleCode
        }
    }
  
    func currencyByCode(_ code: String) -> ACurrency? {
        switch code {
        case unitedStatesDollarCode: return .unitedStatesDollar
        case ukrainianHryvniaCode: return .ukrainianHryvnia
        case russianRubleCode: return .russianRuble
        default: return nil
        }
    }
}

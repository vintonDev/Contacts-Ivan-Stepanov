//
//  StringExtension.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 04.03.2023.
//

import Foundation

extension String{
    func localized() -> String{
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}

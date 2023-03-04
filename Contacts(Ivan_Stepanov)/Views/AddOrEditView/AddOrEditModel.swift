//
//  AddOrEditModel.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 02.03.2023.
//

import Foundation
import UIKit

class AddOrEditModel: NSObject{
    
    var activeTextField: UITextField?
    
    
    // Set the active text field when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // Clear the active text field when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // Is number valid
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        let phoneRegex = #"^\+(\d{1,3})?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}

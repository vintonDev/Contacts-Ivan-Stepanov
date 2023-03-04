//
//  AddOrEditExtensions.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 02.03.2023.
//

import Foundation
import UIKit

protocol AddContactDelegate: AnyObject {
    func createContact(firstName: String?, lastName: String?, phoneNumber: String?, isFavorite: Bool)
    func updateContact(contact: ContactInfo, newFirstName: String?, newLastName: String?, newPhoneNumber: String?, isFavorite: Bool?)
}

extension AddOrEditContactViewController{
    // Save contact button was clicked
    @objc func saveContact() {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty
        else {
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            showStarIfTextFieldIsEmpty()
            return
        }
        
        if !(viewModel.isValidPhoneNumber(phoneNumber: phoneNumber)){
            let alertController = UIAlertController(title: "Error", message: "Phone number is unvalid", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        if currentContact == nil{
            if motherScreen == "Contacts"{
                delegate?.createContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, isFavorite: false)
            }else if motherScreen == "Favorite"{
                delegate?.createContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, isFavorite: true)
            }
        }else{
            delegate?.updateContact(contact: currentContact!, newFirstName: firstName, newLastName: lastName, newPhoneNumber: phoneNumber, isFavorite: nil)
        }
        
        tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popToRootViewController(animated: true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: If one of the Text Fields is Empty, show red star near the Label
    func showStarIfTextFieldIsEmpty(){
        if firstNameTextField.text == ""{
            firstStarNearLabel.isHidden = false
        }else{
            firstStarNearLabel.isHidden = true
        }
        
        if lastNameTextField.text == ""{
            secondStarNearLabel.isHidden = false
        }else{
            secondStarNearLabel.isHidden = true
        }
        
        if phoneNumberTextField.text == ""{
            thirdStarNearLabel.isHidden = false
        }else{
            thirdStarNearLabel.isHidden = true
        }
    }
    
    // Dismiss keyboard when tap outside the text field
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Scroll the text field above the keyboard
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if let activeTextField = viewModel.activeTextField {
            let textFieldRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(textFieldRect, animated: true)
        }
    }
    
    // Reset the content inset when keyboard is hidden
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

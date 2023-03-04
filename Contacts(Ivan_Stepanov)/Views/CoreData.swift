//
//  CoreData.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 04.03.2023.
//

import Foundation
import UIKit

class CoreData: NSObject{
    //MARK: Variables for Core Data
    var tappedContact: ContactInfo?
    var contacts = [ContactInfo]()
    var filteredContacts = [ContactInfo]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentScreen = "Contacts"
    // MARK: Core Data
    func getAllItems(tableView: UITableView){
        do{
            contacts = try context.fetch(ContactInfo.fetchRequest())
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteContact(contact: ContactInfo){
        context.delete(contact)
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func filterContacts(for searchText: String) -> [ContactInfo] {
        var filteredContacts = [ContactInfo]()
        for contact in contacts {
            let firstName = contact.firstName!.lowercased()
            let lastName = contact.lastName!.lowercased()
            let phoneNumber = contact.phoneNumber!.lowercased()
            let searchTerms = searchText.lowercased().components(separatedBy: " ")
            var match = true
            for term in searchTerms {
                if !firstName.contains(term) && !lastName.contains(term) && !phoneNumber.contains(term) {
                    match = false
                    break
                }
            }
            if match {
                if currentScreen == "Contacts" && contact.isFavorite == false{
                    filteredContacts.append(contact)
                }else if currentScreen == "Favorite" && contact.isFavorite == true{
                    filteredContacts.append(contact)
                }
            }
        }
        return filteredContacts
    }
}

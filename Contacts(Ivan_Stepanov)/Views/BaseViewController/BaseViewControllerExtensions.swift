//
//  BaseViewControllerExtensions.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 04.03.2023.
//

import Foundation
import UIKit

//MARK: Reloading Data On the Screen, When TabBar Item was changed
extension BaseViewController: Reloadable{
    func reloadData() {
        cD.currentScreen = cD.currentScreen == "Contacts" ? "Contacts" : "Favorite"
        cD.getAllItems(tableView: self.tableView)
        cD.filteredContacts.removeAll()
        for contact in cD.contacts{
            if cD.currentScreen == "Contacts"{
                if !contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }
            }else if cD.currentScreen == "Favorite"{
                if contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: Core Data Creating And Updating Contact With Delegating
extension BaseViewController: AddContactDelegate{
    func createContact(firstName: String?, lastName: String?, phoneNumber: String?, isFavorite: Bool) {
        let newContact = ContactInfo(context: cD.context)
        newContact.firstName = firstName
        newContact.lastName = lastName
        newContact.phoneNumber = phoneNumber
        newContact.isFavorite = isFavorite
        
        do{
            try cD.context.save()
            cD.getAllItems(tableView: tableView)
            cD.filteredContacts.removeAll()
            for contact in cD.contacts{
                if cD.currentScreen == "Contacts" && !contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }else if cD.currentScreen == "Favorite" && contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func updateContact(contact: ContactInfo, newFirstName: String?, newLastName: String?, newPhoneNumber: String?, isFavorite: Bool?) {
        contact.firstName = newFirstName ?? contact.firstName
        contact.lastName = newLastName ?? contact.lastName
        contact.phoneNumber = newPhoneNumber ?? contact.phoneNumber
        contact.isFavorite = isFavorite ?? contact.isFavorite
        
        do{
            try cD.context.save()
            cD.getAllItems(tableView: tableView)
            tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
}

//MARK: Search Bar Results Updating
extension BaseViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText == ""{
            cD.filteredContacts.removeAll()
            for contact in cD.contacts{
                if cD.currentScreen == "Contacts" && !contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }else if cD.currentScreen == "Favorite" && contact.isFavorite{
                    cD.filteredContacts.append(contact)
                }
            }
        }else{
            cD.filteredContacts = cD.filterContacts(for: searchText)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }
}

//MARK: Table View Delegate and DataSource
extension BaseViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cD.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = cD.filteredContacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(contact.firstName!) \(contact.lastName!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cD.tappedContact = cD.filteredContacts[indexPath.row]
        performSegue(withIdentifier: "Update", sender: nil)
        tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {  (deleteAction, view, boolValue) in
            self.cD.deleteContact(contact: self.cD.filteredContacts[indexPath.row])
            self.cD.getAllItems(tableView: self.tableView)
            self.cD.filteredContacts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "") {  (favoriteAction, view, boolValue) in
            self.updateContact(contact: self.cD.filteredContacts[indexPath.row], newFirstName: nil, newLastName: nil, newPhoneNumber: nil, isFavorite: !self.cD.filteredContacts[indexPath.row].isFavorite)
            self.cD.filteredContacts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        favorite.backgroundColor = .purple
        
        favorite.title = cD.currentScreen == "Contacts" ? "Favorite" : "Unfavorite"
        
        let swipeActions = UISwipeActionsConfiguration(actions: [favorite])
        
        return swipeActions
    }
}


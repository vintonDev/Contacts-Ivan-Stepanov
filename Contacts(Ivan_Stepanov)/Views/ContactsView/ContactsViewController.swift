//
//  ContactsViewController.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 03.03.2023.
//

import UIKit

class ContactsViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Getting all contacts from Core Data
        cD.currentScreen = "Contacts"
        cD.getAllItems(tableView: self.tableView)
        cD.filteredContacts.removeAll()
        for contact in cD.contacts{
            if !contact.isFavorite{
                cD.filteredContacts.append(contact)
            }
        }
        
        //MARK: TabBar Items Localization
        tabBarController?.tabBar.items![0].title = "Contacts".localized()
        tabBarController?.tabBar.items![1].title = "Favorite".localized()
        
        //MARK: Navigation Controller Settings
        title = "Contacts".localized()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        //MARK: Setting tableView delegate, dataSource and frame
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        setupSearchController()
        
        view.addSubview(tableView)
    }
    
    
}

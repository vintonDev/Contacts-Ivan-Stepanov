//
//  FavoriteViewController.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 03.03.2023.
//

import UIKit

class FavoriteViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Getting all contacts from Core Data
        cD.currentScreen = "Favorite"
        cD.getAllItems(tableView: self.tableView)
        cD.filteredContacts.removeAll()
        for contact in cD.contacts{
            if contact.isFavorite{
                cD.filteredContacts.append(contact)
            }
        }
        
        //MARK: Navigation Controller Settings
        title = "Favorite".localized()
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

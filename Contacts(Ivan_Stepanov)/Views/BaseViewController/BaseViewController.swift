//
//  BaseViewController.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 04.03.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: Variables
    let cD = CoreData()
    weak var delegate: AddContactDelegate?
    var currentContact: ContactInfo?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: UI elements
    let searchController = UISearchController(searchResultsController: nil)
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    //MARK: Transition Changing
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.tableView.reloadData()
    }
    
    //MARK: Preparing Screen For Presenting Another Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var vc = AddOrEditContactViewController()
        vc = segue.destination as! AddOrEditContactViewController
        
        if segue.identifier == "Update"{
            vc.currentContact = cD.tappedContact
        }
        
        vc.delegate = self
        vc.motherScreen = cD.currentScreen == "Contacts" ? "Contacts" : "Favorite"
    }
    
    //MARK: Search Bar Setup
    func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search".localized()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    //MARK: Add contact buttun added
    @objc func didTapAdd(){
        performSegue(withIdentifier: "Add", sender: nil)
        tabBarController?.tabBar.isHidden = true
    }
}

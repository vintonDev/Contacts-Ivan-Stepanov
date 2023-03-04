//
//  CustomTabBarViewController.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 03.03.2023.
//

import UIKit

protocol Reloadable {
    func reloadData()
}

class CustomTabBarViewController: UITabBarController , UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if let navController = viewController as? UINavigationController {
                // Get the current view controller in the navigation stack
                if let currentVC = navController.visibleViewController {
                    // Reload the view controller if it conforms to Reloadable protocol
                    if let reloadableVC = currentVC as? Reloadable {
                        reloadableVC.reloadData()
                    }
                }
            }
        }
}

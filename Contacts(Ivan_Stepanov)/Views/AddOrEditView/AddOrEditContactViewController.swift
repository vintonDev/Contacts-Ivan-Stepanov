//
//  AddOrEditContactViewController.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 01.03.2023.
//

import UIKit

class AddOrEditContactViewController: UIViewController {
    
    //MARK: Variables
    var motherScreen = "Contacts"
    let viewModel = AddOrEditModel()
    weak var delegate: AddContactDelegate?
    var currentContact: ContactInfo?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //MARK: UI elements
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstStarNearLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter First Name".localized()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondStarNearLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Last Name".localized()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let thirdStarNearLabel: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Phone Number".localized()
        textField.keyboardType = .phonePad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save".localized(), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
       scrollView.translatesAutoresizingMaskIntoConstraints = false
       scrollView.showsVerticalScrollIndicator = false
       scrollView.showsHorizontalScrollIndicator = false
       return scrollView
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Checking the reason of going to this screen
        if currentContact != nil{           // if the reason was to update the contact
            firstNameTextField.text = currentContact?.firstName
            lastNameTextField.text = currentContact?.lastName
            phoneNumberTextField.text = currentContact?.phoneNumber
            
        }
        
        
        saveButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(scrollView)
        scrollView.addSubview(firstNameLabel)
        scrollView.addSubview(firstStarNearLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameLabel)
        scrollView.addSubview(secondStarNearLabel)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(thirdStarNearLabel)
        scrollView.addSubview(phoneNumberTextField)
        scrollView.addSubview(saveButton)
        
        // Constraints adding
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            firstNameLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            firstNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            firstNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            firstStarNearLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            firstStarNearLabel.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor, constant: -30),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            lastNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            secondStarNearLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            secondStarNearLabel.leadingAnchor.constraint(equalTo: lastNameLabel.trailingAnchor, constant: -30),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
            lastNameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            phoneLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            phoneLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            thirdStarNearLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            thirdStarNearLabel.leadingAnchor.constraint(equalTo: phoneLabel.trailingAnchor, constant: 3),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    deinit {
        // Unregister from keyboard notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Transition changing
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
            self.scrollView.layoutIfNeeded()
            self.scrollView.layoutSubviews()
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}

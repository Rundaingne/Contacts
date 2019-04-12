//
//  AddContactViewController.swift
//  Contacts
//
//  Created by Brooke Kumpunen on 4/12/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK -Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        //When I tap this button, create a contact. Easy. Then pop the view controller.
        guard let name = nameTextField.text, name != "",
        let email = emailtextField.text,
        let phoneNumber = phoneNumberTextField.text else {return}
        ContactController.shared.createContact(with: name, email: email, phoneNumber: phoneNumber) { (contact) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    

}

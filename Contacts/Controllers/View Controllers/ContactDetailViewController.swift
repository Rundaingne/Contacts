//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Brooke Kumpunen on 4/12/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Properties and methods
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    func updateViews() {
        guard let contact = contact else {return}
        contactNameLabel.text = contact.name
        contactEmailLabel.text = contact.email
        contactPhoneNumberLabel.text = contact.phoneNumber
    }
    
    func presentContactEditor(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Phone Number"
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard let name = alertController.textFields?[0].text, !name.isEmpty,
            let email = alertController.textFields?[1].text,
                let phoneNumber = alertController.textFields?[2].text,
                let contact = self.contact else {return}
            //Right here, I will call the update contact function. let's go create that. Then when i'm done with that, reload the data and end.
            ContactController.shared.updateContact(contact: contact, name: name, email: email, phone: phoneNumber, completion: { (contact) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        alertController.addAction(dismissAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
    
    //MARK: -Actions
    @IBAction func editContactButtonTapped(_ sender: UIBarButtonItem) {
        presentContactEditor(title: "Edit your contact?", message: "")
    }
    

}

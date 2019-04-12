//
//  ContactListTableViewController.swift
//  Contacts
//
//  Created by Brooke Kumpunen on 4/12/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//
//I'm betting it is due to the save being asyncronous (i.e. you are popping back and reloading the tableview before the save finishes and appends the new contact) You can either append first, or wait until the save has completed to pop back and reload

import UIKit

class ContactListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gotta have my list of contacts pulled up right when I open the app. Call the fetch here, as well as App Delegate.
        ContactController.shared.fetchAllContacts { (contacts) in
            DispatchQueue.main.async {
                guard let contacts = contacts else {return}
                ContactController.shared.contacts = contacts
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        ContactController.shared.fetchAllContacts { (contacts) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let destinationVC = segue.destination as! ContactDetailViewController
            let contact = ContactController.shared.contacts[indexPath.row]
            destinationVC.contact = contact
        }
    }
}

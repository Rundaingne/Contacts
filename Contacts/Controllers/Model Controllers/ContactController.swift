//
//  ContactController.swift
//  Contacts
//
//  Created by Brooke Kumpunen on 4/12/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    //Singleton
    static let shared = ContactController()
    private init() {}
    
    //SoT and properties
    var contacts: [Contact] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //CRUD and other methods
    func createContact(with name: String, email: String, phoneNumber: String, completion: @escaping (Contact?) -> Void) {
        let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        publicDB.save(CKRecord(contact: contact)) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let record = record,
            let contact = Contact(ckRecord: record) else {completion(nil); return}
            self.contacts.append(contact)
            completion(contact)
        }
    }
    
    func updateContact(contact: Contact, name: String, email: String, phone: String, completion: @escaping (Contact?) -> Void) {
        
        //Okay, to update a contact, first I need to fetch that particular contact.
        let recordID = contact.recordID
        //Got a recordID, now fetch it from...somewhere.
        publicDB.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil); return}
            //Okay, got my record. Now let's update it!
            record.setValue(name, forKey: Contact.Keys.nameKey)
            record.setValue(email, forKey: Contact.Keys.emailKey)
            record.setValue(phone, forKey: Contact.Keys.phoneNumberKey)
            self.publicDB.save(record, completionHandler: { (record, error) in
                if let error = error {
                    print("\(error.localizedDescription) \(error) in function: \(#function)")
                    completion(nil)
                    return
                }
                guard let record = record,
                let updatedContact = Contact(ckRecord: record) else {completion(nil); return}
                completion(updatedContact)
            })
        }
    }
    
    func fetchAllContacts(completion: @escaping ([Contact]?) -> Void) {
        
        //I will need a predicate, a query, and then I need to perform a query.
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Contact.Keys.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            guard let records = records else {completion(nil); return}
            //Gotta do the fancy compact map. Well, I don't HAVE to. But I do need to loop through the array of records, create a contact for each one.
            let contacts = records.compactMap{Contact(ckRecord: $0)}
            self.contacts = contacts
            completion(contacts)
        }
    }
}

//Done. Onward! Off to view controllers. Let's start with the Contact List.

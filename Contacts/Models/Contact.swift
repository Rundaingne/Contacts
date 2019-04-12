//
//  Contact.swift
//  Contacts
//
//  Created by Brooke Kumpunen on 4/12/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//Initial screen shows a list of contact names.
//Tapping the plus button in the top right corner brings up a screen with text fields to enter a name, phone number, and email address for a new contact. The user should be required to enter a name. Phone number and email address fields may be left blank.
//Tapping the save button saves the new contact and returns to the list of contacts.
//Tapping on a contact in the list shows a detail view which allows editing the existing contact.
//If the app is killed and restarted, previously saved contacts must continue to be shown.
//If the app is launched on another device signed into the same iCloud account, it must also show the users' contacts.

import Foundation
import CloudKit

class Contact {
    
    let name: String
    let phoneNumber: Int?
    let email: String?
    
    let recordID: CKRecord.ID
    
    init(name: String, phoneNumber: Int, email: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = recordID
    }
    
    //Made the...initial...initializer. Lol. Now, I need cloudkit properties.
    //Done. Now, make another initializer to create a Contact from a CKRecord.
    convenience init?(ckRecord: CKRecord) {
        //In order to fill this out, I'll need some constants. Enum time.
        guard let name = ckRecord[Keys.nameKey] as? String,
        let phoneNumber = ckRecord[Keys.phoneNumberKey] as? Int,
            let email = ckRecord[Keys.emailKey] as? String else {return nil}
        self.init(name: name, phoneNumber: phoneNumber, email: email, recordID: ckRecord.recordID)
    }
    
}

extension Contact {
    enum Keys {
        static let recordTypeKey = "Contact"
        static let nameKey = "name"
        static let phoneNumberKey = "phoneNumber"
        static let emailKey = "emailKey"
        
    }
}

//One last initializer to be done. Need to make an extension on CKRecord, and create a record from a post.
extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: Contact.Keys.recordTypeKey, recordID: contact.recordID)
        self.setValue(contact.name, forKey: Contact.Keys.nameKey)
        self.setValue(contact.email, forKey: Contact.Keys.emailKey)
        self.setValue(contact.phoneNumber, forKey: Contact.Keys.phoneNumberKey)
    }
}

//All done. Nifty. Time to make a model controller.

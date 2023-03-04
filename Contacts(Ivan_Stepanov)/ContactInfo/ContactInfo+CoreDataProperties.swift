//
//  ContactInfo+CoreDataProperties.swift
//  Contacts(Ivan_Stepanov)
//
//  Created by Иван Степанов on 03.03.2023.
//
//

import Foundation
import CoreData


extension ContactInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactInfo> {
        return NSFetchRequest<ContactInfo>(entityName: "ContactInfo")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var isFavorite: Bool

}

extension ContactInfo : Identifiable {

}

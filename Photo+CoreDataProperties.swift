//
//  Photo+CoreDataProperties.swift
//  SaveImageInCoredata
//
//  Created by Techno on 10/30/15.
//  Copyright © 2015 Techno. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var name: String?
    @NSManaged var image: NSData?

}

//
//  Listing+Convenience.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

// V1 (add other properties later)
extension Listing {

    /// This turns a Core Data Managed Listing into a ListingRepresentation for marshaling to JSON and sending to server
    var listingRepresentation: ListingRepresentation? {

        guard let location = location else { return nil }

        return ListingRepresentation(location: location,
                                     notes: notes,
                                     price: price,
                                     photo: photo,
                                     identifier: identifier)
    }
    /// This is for creating a new managed object in Core Data
    @discardableResult convenience init(location: String,
                                        notes: String? = nil,
                                        price: Float,
                                        photo: String? = nil,
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.location = location
        self.notes = notes
        self.price = price
        self.photo = photo
        self.identifier = identifier
    }

    /// This is for converting ListingRepresentation (comes from JSON) into a managed object for Core Data
    @discardableResult convenience init?(listingRepresentation: ListingRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        guard let identifier = listingRepresentation.identifier else { return nil }

        self.init(location: listingRepresentation.location,
                  notes: listingRepresentation.notes,
                  price: listingRepresentation.price,
                  photo: listingRepresentation.photo,
                  identifier: identifier,
                  context: context)
    }
}

//
//  ListingRepresentation.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

// V1 (add other properties later)
struct ListingRepresentation: Codable {
    var location: String
    var notes: String?
    var price: Float
    var photo: String?
    var identifier: UUID?
//    var reserved: Bool
//    var date: Date
//    var userID: String?
}

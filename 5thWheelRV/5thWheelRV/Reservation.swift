//
//  Reservation.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import UIKit

struct Reservation: Codable {
    var userId: UUID
    var listingId: UUID
    var identifier: UUID
    var isReserved: Bool
    var reservedDate: Date
    var price: Float
    var location: String
    var notes: String
}

struct User: Codable {
    var identifier: UUID
    var username: String
    var password: String
    var isLandOwner: Bool
}

struct AlertMaker {
    func makeAlert(viewController: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

/// Holds 10 photos and can return a random one
struct StockPhotos {
    var photos = ["cliff", "forestSS", "hills", "park", "skyline",
                "underwater", "outskirts", "mountainlake", "country", "losangeles"]

    func randomPhoto() -> String {
        let index = Int.random(in: 0..<photos.count)
        print("i = \(index), string = \(photos[index])")
        return photos[index]
    }
}

let stockPhotos = StockPhotos()

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

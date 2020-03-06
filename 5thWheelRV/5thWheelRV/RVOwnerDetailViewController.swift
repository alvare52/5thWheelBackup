//
//  RVOwnerDetailViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class RVOwnerDetailViewController: UIViewController {

    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reserveButtonLabel: UIButton!
    @IBOutlet weak var textView: UITextView!

    /// Check to see to disable button and picker (or hide them)
    var viewModeOn = false
    var reservationController: ReservationController?
    var listingRep: ListingRepresentation? {
        didSet {
            updateViews()
        }
    }
    @IBAction func reserveButtonTapped(_ sender: UIButton) {
        guard let listingRep = listingRep else {return}

        let newReservation = Reservation(userId: globalUser.identifier,
                                         listingId: listingRep.identifier ?? UUID(),
                                         identifier: UUID(),
                                         isReserved: true,
                                         reservedDate: datePicker.date,
                                         price: listingRep.price,
                                         location: listingRep.location,
                                         notes: listingRep.notes ?? "")
        reservationController?.sendReservationToServer(reservation: newReservation)

        //navigationController?.popViewController(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }

    func updateViews() {
        print("updateViews")
        guard isViewLoaded else {return}

        title = listingRep?.location ?? "Listing"
        //if let price = listing?.price {  }
        let price = String(format: "$%.2f", listingRep?.price ?? 0)
        priceLabel.text = "Price per day: \(price) - (no refunds)"
        textView.text = listingRep?.notes ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        reserveButtonLabel.layer.cornerRadius = 6.9
        listingImageView.layer.cornerRadius = 6.9
        listingImageView.clipsToBounds = true
        listingImageView.image = UIImage(named: stockPhotos.randomPhoto())
        updateViews()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

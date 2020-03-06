//
//  ShowReservationViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/6/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class ShowReservationViewController: UIViewController {

    var reservation: Reservation? {
        didSet {
            updateViews()
        }
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        //formatter.dateStyle = .short
        formatter.dateFormat = "EEEE MMM d, yyyy"
        return formatter
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reservedDateLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var buttonLabel: UIButton!

    @IBAction func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func updateViews() {
        print("updateViews")
        guard isViewLoaded else {return}

        locationLabel.text = reservation?.location
        priceLabel.text = "Price per day: $\(reservation?.price ?? 0)"
        reservedDateLabel.text = "Reserved for: \(dateFormatter.string(from: reservation?.reservedDate ?? Date()))"
        notesTextView.text = reservation?.notes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        imageView.layer.cornerRadius = 6.9
        imageView.clipsToBounds = true
        buttonLabel.layer.cornerRadius = 6.9
    }
}

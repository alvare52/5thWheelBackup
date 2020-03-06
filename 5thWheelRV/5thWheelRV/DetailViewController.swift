//
//  DetailViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!

    var listingController: ListingController?
    var listing: Listing? {
        didSet {
            updateViews()
        }
    }

    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        print("saveTapped")

        if let location = locationTextField.text,
            let price = priceTextField.text,
            !location.isEmpty,
            !price.isEmpty,
            let notes = notesTextView.text {

            // If there is a listing, update (detail)
            if let existingListing = listing {
            listingController?.update(location: location,
                                          notes: notes,
                                          price: Float(price)!,
                                          photo: "photo",
                                          listing: existingListing)
                navigationController?.popViewController(animated: true)
            }
            // If there is NO listing (add)
            else {
                // NEW (puts to /listings/)
                let newListing = Listing(location: location,
                                         notes: notes,
                                         price: Float(price)!,
                                         userId: globalUser.identifier)
                // OLD
                //listingController?.sendListingToServer(listing: newListing)
                listingController?.sendListingToServer(listing: newListing)
                navigationController?.popViewController(animated: true)
                // Save
//                do {
//                    try CoreDataStack.shared.mainContext.save()
//                } catch {
//                    NSLog("Error saving managed object context: \(error)")
//                }
            }
            //navigationController?.popViewController(animated: true)
        }
    }

    func updateViews() {
        print("update views")
        guard isViewLoaded else {return}

        title = listing?.location ?? "Add New Listing"
        locationTextField.text = listing?.location ?? ""
        priceTextField.text = String(format: "$%.2f", listing?.price ?? 0)
        notesTextView.text = listing?.notes ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.autocorrectionType = .no
        notesTextView.autocorrectionType = .no
        photoImageView.layer.cornerRadius = 6.9
        photoImageView.clipsToBounds = true
        photoImageView.image = UIImage(named: stockPhotos.randomPhoto())
        priceTextField.clearsOnBeginEditing = true
        updateViews()
    }
}

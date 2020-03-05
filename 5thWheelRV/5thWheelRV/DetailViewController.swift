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
            }
            // If there is NO listing (add)
            else {
                // NEW (puts to /listings/)
                let newListing = Listing(location: location,
                                         notes: notes,
                                         price: Float(price)!,
                                         userId: globalUser.identifier)
                listingController?.sendListingToServer(listing: newListing)
                // Save
                do {
                    try CoreDataStack.shared.mainContext.save()
                } catch {
                    NSLog("Error saving managed object context: \(error)")
                }
            }
            navigationController?.popViewController(animated: true)
        }
        // One field is empty
        else {
            let alertController = UIAlertController(title: "Invalid Field",
                                                    message: "Please fill in all fields", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func updateViews() {
        print("update views")
        guard isViewLoaded else {return}

        title = listing?.location ?? "Add New Listing"
        locationTextField.text = listing?.location ?? ""
        //if let price = listing?.price {  }
        priceTextField.text = "\(listing?.price ?? 0)"
        notesTextView.text = listing?.notes ?? ""
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.autocorrectionType = .no
        notesTextView.autocorrectionType = .no
        updateViews()
    }
}

//
//  RVOwnerListingsTableViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

// SearchListingSegue
// EditReservationSegue
// SearchResultsCell (other tvc)
class RVOwnerListingsTableViewController: UITableViewController {

    let reservationController = ReservationController()

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        //formatter.dateFormat = "EEEE MMM d, h:mm a"
        return formatter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(globalUser.username) \'s Reservations"
        reservationController.fetchUsersReservations { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        //tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationController.reservationsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath)

        let result = reservationController.reservationsArray[indexPath.row]
        cell.textLabel?.text = result.location
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: result.reservedDate))"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // RVOwnerDetailViewController (to VIEW/ADD listing)
        if segue.identifier == "EditReservationSegue" {
            print("EditReservationSegue")
            if let detailVC = segue.destination as? RVOwnerDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.reservationController = self.reservationController
                detailVC.listingRep = reservationController.searchResultsArray[indexPath.row]
            }
        }
    }

}

//
//  SearchResultsTableViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

// ViewListingSegue
class SearchResultsTableViewController: UITableViewController {

    var reservationController = ReservationController()
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservationController.searchResultsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCell", for: indexPath)

        let result = reservationController.searchResultsArray[indexPath.row]
        cell.textLabel?.text = result.location
        cell.detailTextLabel?.text = "$\(result.price)"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DetailViewController (to ADD plant)
//        if segue.identifier == "AddListingSegue" {
//            print("AddListingSegue")
//            if let detailVC = segue.destination as? DetailViewController {
//                    detailVC.listingController = self.listingController
//                }
//            }
        // RVOwnerDetailViewController (to VIEW/ADD listing)
        if segue.identifier == "ViewListingSegue" {
            print("ViewListingSegue")
            if let detailVC = segue.destination as? RVOwnerDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.reservationController = self.reservationController
                detailVC.listingRep = reservationController.searchResultsArray[indexPath.row]
            }
        }
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    // Searches everytime the searchbar text changes
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        guard let searchTerm = searchBar.text else {return}
        reservationController.fetchAllListings(with: searchTerm) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        // Perform search when "Return" is pressed in searchBar
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
    //        reservationController.fetchAllListings(with: searchTerm) { (_) in
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
}

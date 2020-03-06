//
//  SearchResultsTableViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

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

        // Configure the cell...
        let result = reservationController.searchResultsArray[indexPath.row]
        cell.textLabel?.text = result.location
        cell.detailTextLabel?.text = "\(result.price)"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension SearchResultsTableViewController: UISearchBarDelegate {
    // Perform search when "Return" is pressed in searchBar
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else {return}
//        reservationController.fetchAllListings(with: searchTerm) { (_) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
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
//    func searchBar(_ searchBar: UISearchBar,
//                   shouldChangeTextIn range: NSRange,
//                   replacementText text: String) -> Bool {
//        let oldText = searchBar.text!
//        let stringRange = Range(range, in: oldText)!
//        let newText = oldText.replacingCharacters(in: stringRange, with: text)
//        //send new text to the determine strength method
//        //checkStrength(pw: newText)
//        return true
//    }
}

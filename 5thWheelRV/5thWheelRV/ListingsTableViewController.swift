//
//  ListingsTableViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/1/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import CoreData
// EditListingSegue
// AddListingSegue
class ListingsTableViewController: UITableViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Listing> = {
        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        // NEW (This fucking part right here though)
        let test = globalUser.identifier
        // Only fetch listings that belong to the signed in land owner
        fetchRequest.predicate = NSPredicate(format: "userId == %@", test as CVarArg)

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]

        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "location",
                                             cacheName: nil)
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            fatalError("fetch controller error")
        }
        //try! frc.performFetch() // do it and crash if you have to
        return frc
    }()

    let listingController = ListingController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(globalUser.username)\'s Listings"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let testCell = fetchedResultsController.object(at: indexPath)
        guard let location = testCell.location else { return cell }
        cell.textLabel?.text = location
        cell.detailTextLabel?.text = "\(testCell.price)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listing = fetchedResultsController.object(at: indexPath)
            // delete from server first before we do local delete
            listingController.deleteListingFromServer(listing: listing) { error in
                if let error = error {
                    print("Error deleting listing from server: \(error)")
                    return
                }

                CoreDataStack.shared.mainContext.delete(listing)
                do {
                    try CoreDataStack.shared.mainContext.save()
                } catch {
                    CoreDataStack.shared.mainContext.reset() // UN-deletes
                    NSLog("Error saving managed object context: \(error)")
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//        if segue.identifier == "LoginModalSegue" {
//            guard let destination = segue.destination as? LoginViewController else {return}
//            destination.listingController = self.listingController
//        }

        // DetailViewController (to ADD plant)
        if segue.identifier == "AddListingSegue" {
            print("AddListingSegue")
            if let detailVC = segue.destination as? DetailViewController {
                    detailVC.listingController = self.listingController
                }
            }
        // DetailViewController (to EDIT plant)
        if segue.identifier == "EditListingSegue" {
            print("EditListingSegue")
            if let detailVC = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                detailVC.listingController = self.listingController
                detailVC.listing = fetchedResultsController.object(at: indexPath)
            }
        }
    }
}

extension ListingsTableViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

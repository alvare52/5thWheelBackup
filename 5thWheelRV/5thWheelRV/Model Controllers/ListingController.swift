//
//  ListingController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/3/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

/// "https://mymovies-8d255.firebaseio.com/"
let baseUrl = URL(string: "https://mymovies-8d255.firebaseio.com/")!

class ListingController {

    typealias CompletionHandler = (Error?) -> Void

    init() {
        // OLD
        //fetchListingsFromServer()
        // NEW
        fetchUsersListings()
    }

    /// Gets all listings belonging to signed in user (Land Owner)
    func fetchUsersListings(completion: @escaping CompletionHandler = { _ in }) {
        var requestUrl = baseUrl.appendingPathComponent("listings")
        requestUrl = requestUrl.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in

            if let error = error {
                print("Error fetching user listings: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601

            do {
                let listingRepresentations = Array(try jsonDecoder.decode([String: ListingRepresentation].self,
                                                                          from: data).values)

                /// Go through all listings and returns an array made up of only the user's listings (userId)
                let usersListings = listingRepresentations.filter { $0.userId == globalUser.identifier }
                print("userListings = \(usersListings)")
                // used to be with usersListings
                try self.updateListings(with: listingRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing listing representations (fetchUsersListings): \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }

        }.resume()
    }

    /// Gets ALL Listings from the server ( /listings ) (RV Owner)
    func fetchListingsFromServer(completion: @escaping CompletionHandler = { _ in }) {
        // OLD
        //let requestUrl = baseUrl.appendingPathExtension("json")
        // NEW
        var requestUrl = baseUrl.appendingPathComponent("listings")
        requestUrl = requestUrl.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in

            if let error = error {
                print("Error fetching listings: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .iso8601

            do {
                let listingRepresentations = Array(try jsonDecoder.decode([String: ListingRepresentation].self,
                                                                          from: data).values)

                try self.updateListings(with: listingRepresentations)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding or storing listing representations (fetchListingsFromServer): \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }

        }.resume()
    }

    /// Turns FireBase objects into Core Data objects
    func updateListings(with representations: [ListingRepresentation]) throws {
        // filter out the no ID ones
        let listingsWithID = representations.filter { $0.identifier != nil }

        // creates a new UUID based on the identifier of the task we're looking at (and it exists)
        // compactMap returns an array after it transforms
        let identifiersToFetch = listingsWithID.compactMap { $0.identifier! }

        // zip interweaves elements
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, listingsWithID))

        var listingsToCreate = representationsByID

        let fetchRequest: NSFetchRequest<Listing> = Listing.fetchRequest()
        // in order to be a part of the results (will only pull tasks that have a duplicate from fire base)
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        // create private queue context
        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.perform {
            do {
                let existingListings = try context.fetch(fetchRequest)

                // updates local tasks with firebase tasks
                for listing in existingListings {
                    // continue skips next iteration of for loop
                    guard let iden = listing.identifier, let representation = representationsByID[iden] else {continue}
                    self.update(listing: listing, with: representation)
                    listingsToCreate.removeValue(forKey: iden)
                }

                for representation in listingsToCreate.values {
                    Listing(listingRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching plants for UUIDs: \(error)")
            }
        }
        try CoreDataStack.shared.save(context: context)
    }

    /// Updates local user with data from the remote version (representation)
    private func update(listing: Listing, with representation: ListingRepresentation) {
        listing.location = representation.location
        listing.notes = representation.notes
        listing.price = representation.price
        listing.photo = representation.photo
    }

    /// Send a created or updated listing to the server
    func sendListingToServer(listing: Listing, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = listing.identifier ?? UUID()

        // NEW
        var requestURL = baseUrl.appendingPathComponent("listings")
        requestURL = requestURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        // OLD
        //let requestURL = baseUrl.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")

        print("requestURL = \(requestURL)")
        // changes back to requestURL
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        // Encode data
        do {
            guard var representation = listing.listingRepresentation else {
                completion(NSError())
                return
            }
            // Both have same uuid
            representation.identifier = uuid
            listing.identifier = uuid
            try CoreDataStack.shared.save()
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601

            request.httpBody = try jsonEncoder.encode(representation)
        } catch {
            print("Error encoding listing \(listing): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }
        // Send to server
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("error putting listing to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            // success
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
        // NEW
        saveListing()
    }

    /// Saves to Core Data
    func saveListing() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }

    /// Update a listing that already exists
    func update(location: String, notes: String, price: Float, photo: String, listing: Listing) {
        listing.location = location
        listing.notes = notes
        listing.price = price
        listing.photo = photo
        sendListingToServer(listing: listing)
        saveListing()
    }

    /// Delete a Listing from the server
    func deleteListingFromServer(listing: Listing, completion: @escaping CompletionHandler = { _ in }) {
        // NEEDS to have ID
        guard let uuid = listing.identifier else {
            completion(NSError())
            return
        }
        // OLD
        //let requestURL = baseUrl.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        // NEW
        var requestURL = baseUrl.appendingPathComponent("listings")
        requestURL = requestURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)

            DispatchQueue.main.async {
                completion(error)
            }
        }.resume()
    }
}

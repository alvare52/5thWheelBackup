//
//  UserController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation

/// User currently signed in. All properties MUST be overwritten. "user", "password", LO = false
var globalUser = User(identifier: UUID.init(uuidString: "CF22C476-403E-4451-825D-3C84042B1B77")!,
                      username: "user",
                      password: "pass",
                      isLandOwner: false)

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
    case existingUser
}

class UserController {
    typealias CompletionHandler = (Error?) -> Void

    /// SignUp as a new user (or existing one) and send user info to server
    func signUp(user: User, completion: @escaping CompletionHandler = { _ in }) {
        print("Called SignUp")
        let uuid = user.identifier
        var requestUrl = baseUrl.appendingPathComponent("users")
        requestUrl = requestUrl.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        print("requestUrl = \(requestUrl)")
        // change to a request instead of just a URL
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"

        // Encode Data
        let jsonEncoder = JSONEncoder()
        do {
            request.httpBody = try jsonEncoder.encode(user)
        } catch {
            print("Error encoding user \(user): \(error)")
            DispatchQueue.main.async {
                completion(error)
            }
            return
        }

        // Send to server
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("error putting user to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            // Success
            print("Sign up Success")
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }

    /// Check if user already exists on server???
    func checkIfUserExists(user: User,
                           completion: @escaping (Result<String, NetworkError>) -> Void) {
        let requestUrl = baseUrl.appendingPathComponent("users").appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestUrl) { (data, _, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.otherError))
                }
                return
            }
            guard let data = data else {
                print("No data return by data task")
                DispatchQueue.main.async {
                    completion(.failure(.badData))
                }
                return
            }
            var userExists = false
            do {
                let allUsers = Array(try JSONDecoder().decode([String: User].self, from: data).values)
                print("All Users: \(allUsers)")
                print("user: \(user)")
                // Checks if user already exists and returns if they do exist
                var userToReturn = User(identifier: UUID(), username: "", password: "", isLandOwner: true)
                for potentialUser in allUsers {
                    if potentialUser.username == user.username && potentialUser.password == user.password {
                        userExists = true
                        userToReturn = potentialUser
                        print("Matching user found: \(userToReturn)")
                    }
                }
                if userExists {
                    print("User already exists ()")
                    DispatchQueue.main.async {
                        completion(.failure(.existingUser))
                        globalUser = userToReturn
                        print("GlobalUser now: \(globalUser)")
                        return
                    }
                    return
                } else {
                    self.signUp(user: user)
                }
                // Success
                DispatchQueue.main.async {
                    completion(.success("Worked"))
                }
            } catch {
                print("Error decoding or storing users: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noDecode))
                }
            }
        }.resume()
    }
}

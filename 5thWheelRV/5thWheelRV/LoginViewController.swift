//
//  LoginViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case logIn
}

class LoginViewController: UIViewController {

    var loginType = LoginType.signUp
    var userController = UserController()
    var alerter = AlertMaker()

    @IBOutlet weak var ownerTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var signInSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonLabel: UIButton!

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        print("signInButtonTapped")
        signInButtonLabel.performFlare()
        if loginType == .signUp {
            performSegue(withIdentifier: "PresentLandOwnerSegue", sender: self)
        } else {
            performSegue(withIdentifier: "PresentRVOwnerSegue", sender: self)
        }
    }

    @IBAction func signInSegmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            changeToSignUp()
        } else {
            changeToLogIn()
        }
    }

    @IBAction func ownerTypeSegmentChanged(_ sender: UISegmentedControl) {
    }

    @IBAction func skipButtonTapped(_ sender: UIButton) {
        signInButtonLabel.performFlare()
        //dismiss(animated: true, completion: nil)

        guard let username = usernameTextField.text, let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty else { return }
        // LAND OWNER FIRST
        let user = User(identifier: UUID(), username: username, password: password, isLandOwner: true)
        userController.checkIfUserExists(user: user) { (result) in
            do {
                let message = try result.get()
                DispatchQueue.main.async {
                    print("SUCCESS signing up: \(user)")
                    self.alerter.makeAlert(viewController: self,
                                           title: "Sign Up Success",
                                           message: "You have successfully signed up")
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .existingUser:
                        print("User already exist: ")
                        DispatchQueue.main.async {
                            print("user exists")
                            self.alerter.makeAlert(viewController: self,
                                                   title: "Error Signing Up",
                                                   message: "This username and password already exists")
                        }
                    default:
                        print("Generic Error in LIVC")
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func changeToSignUp() {
        signInSegmentControl.selectedSegmentIndex = 0
        loginType = .signUp
        print("Sign Up")
        signInButtonLabel.setTitle("Sign Up", for: .normal)
        signInButtonLabel.performFlare()
    }

    func changeToLogIn() {
        signInSegmentControl.selectedSegmentIndex = 1
        loginType = .logIn
        print("Log In")
        signInButtonLabel.setTitle("Log In", for: .normal)
        signInButtonLabel.performFlare()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue")
    }
}

// Animation
extension UIView {
  func performFlare() {
    func flare() { transform = CGAffineTransform( scaleX: 1.1, y: 1.1) }
    func unflare() { transform = .identity }

    UIView.animate(withDuration: 0.3,
                   animations: { flare() },
                   completion: { _ in UIView.animate(withDuration: 0.2) { unflare() }})
  }
}

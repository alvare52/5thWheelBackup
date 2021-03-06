//
//  LoginViewController.swift
//  5thWheelRV
//
//  Created by Jorge Alvarez on 3/4/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import CoreGraphics

enum LoginType {
    case signUp
    case logIn
}

// Sign up / sign in don't do anything (don't need to)
// Delete "Skip" button later
class LoginViewController: UIViewController {

    var loginType = LoginType.signUp
    var logInAsLandOwner = true
    var userController = UserController()
    var alerter = AlertMaker()

    @IBOutlet weak var wheel: UIImageView!
    @IBOutlet weak var ownerTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var signInSegmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonLabel: UIButton!

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        print("signInButtonTapped")
        signInButtonLabel.performFlare()

        guard let username = usernameTextField.text, let password = passwordTextField.text,
            !username.isEmpty, !password.isEmpty else { return }
        // LAND OWNER FIRST
        let user = User(identifier: UUID(),
                        username: username,
                        password: password,
                        isLandOwner: logInAsLandOwner)
        userController.checkIfUserExists(user: user) { (result) in
            do {
                let message = try result.get()
                print(message)
                DispatchQueue.main.async {
                    print("SUCCESS signing up: \(user)")
                    // Assign global user to the user that has successfully signed in/up
//                    self.alerter.makeAlert(viewController: self,
//                    title: "Sign Up Success",
//                    message: "You have successfully signed up")
                    globalUser = user
                    globalUser.isLandOwner ? self.goToLandOwnerScreen() : self.goToRVOwnerScreen()
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .existingUser:
                        print("LOG IN / EXISTING USER")
//                        self.alerter.makeAlert(viewController: self,
//                        title: "Error Signing Up",
//                        message: "This username and password already exists")
                        DispatchQueue.main.async {
                            print("user exists, logging in anyways")
                            globalUser.isLandOwner ? self.goToLandOwnerScreen() : self.goToRVOwnerScreen()
                        }
                    default:
                        print("Generic Error in LIVC")
                    }
                }
            }
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
        // Land Owner
        if sender.selectedSegmentIndex == 0 {
            logInAsLandOwner = true
            print("Land Owner")
        } else {
            // RV Owner
            logInAsLandOwner = false
            print("RV Owner")
        }
    }

    /// Performs segue to Land Owner Listings
    func goToLandOwnerScreen() {
        performSegue(withIdentifier: "PresentLandOwnerSegue", sender: self)
    }

    /// Performs segue to RV Owner Reservations
    func goToRVOwnerScreen() {
        performSegue(withIdentifier: "PresentRVOwnerSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        print("GLOBAL USER: \(globalUser)")
        signInButtonLabel.layer.cornerRadius = 6.9
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rotateWheel()
    }

    @objc func rotateWheel() {
        print("spinning")
        //rvView.center = view.center

        UIView.animate(withDuration: 0.12, delay: 0, options: [.repeat], animations: {
            self.wheel.transform = CGAffineTransform(rotationAngle: (360.0 * CGFloat(Double.pi)) / 360.0)
            })
    }

    override func viewDidDisappear(_ animated: Bool) {
        wheel.stopAnimating()
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

extension LoginViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        _ = oldText.replacingCharacters(in: stringRange, with: string)
        //send new text to the determine strength method
        //checkStrength(pw: newText)
        print("typed")
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.wheel.center = CGPoint(x: self.wheel.center.x, y: self.wheel.center.y - 30)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.2) {
                self.wheel.center = CGPoint(x: self.wheel.center.x, y: self.wheel.center.y + 30)
            }
        }, completion: nil)

        return true
    }
}

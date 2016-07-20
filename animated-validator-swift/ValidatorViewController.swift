//
//  ValidatorViewController.swift
//  animated-validator-swift
//
//  Created by Flatiron School on 6/27/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ValidatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!

    var viewsArray : [UIView] = []
    
    var hasValidEmail = false
    var hasValidConfirmedEmail = false
    var hasValidPhoneNumber = false
    var hasValidPassword = false
    var hasValidConfirmedPassword = false
    
    var emailCenterXConstraint : NSLayoutConstraint?
    var emailConfirmCenterXConstraint : NSLayoutConstraint?
    var phoneCenterXConstraint : NSLayoutConstraint?
    var passwordCenterXConstraint : NSLayoutConstraint?
    var confirmPasswordCenterXConstraint : NSLayoutConstraint?
    var submitButtonTopConstraint : NSLayoutConstraint?
    
    let incorrectShift : CGFloat = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.submitButton.removeFromSuperview()
        self.view.addSubview(self.submitButton)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.submitButton.accessibilityLabel = Constants.SUBMITBUTTON
        self.emailTextField.accessibilityLabel = Constants.EMAILTEXTFIELD
        self.emailConfirmationTextField.accessibilityLabel = Constants.EMAILCONFIRMTEXTFIELD
        self.phoneTextField.accessibilityLabel = Constants.PHONETEXTFIELD
        self.passwordTextField.accessibilityLabel = Constants.PASSWORDTEXTFIELD
        self.passwordConfirmTextField.accessibilityLabel = Constants.PASSWORDCONFIRMTEXTFIELD
        
        self.emailTextField.delegate = self
        self.emailConfirmationTextField.delegate = self
        self.phoneTextField.delegate = self
        self.phoneTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmTextField.delegate = self
        
        self.submitButton.enabled = false
        
        self.viewsArray = [self.emailTextField, self.emailConfirmationTextField, self.phoneTextField, self.passwordTextField, self.passwordConfirmTextField, self.submitButton]
        removeAutoLayoutConstraints(self.viewsArray)
        
        layoutViews()
    }
    
    private func layoutViews() {
        
        self.emailCenterXConstraint = self.emailTextField.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        self.emailCenterXConstraint?.active = true
        
        self.emailConfirmCenterXConstraint = self.emailConfirmationTextField.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        self.emailConfirmCenterXConstraint?.active = true
        
        self.phoneCenterXConstraint = self.phoneTextField.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        self.phoneCenterXConstraint?.active = true
        
        self.passwordCenterXConstraint = self.passwordTextField.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        self.passwordCenterXConstraint?.active = true
        
        self.confirmPasswordCenterXConstraint = self.passwordConfirmTextField.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor)
        self.confirmPasswordCenterXConstraint?.active = true
        
        self.submitButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.submitButtonTopConstraint = self.submitButton.topAnchor.constraintEqualToAnchor(self.passwordConfirmTextField.bottomAnchor, constant: 318)
        self.submitButtonTopConstraint?.active = true
    }
    
    func removeAutoLayoutConstraints(viewsArray : [UIView]) {
        for view in viewsArray {
            view.translatesAutoresizingMaskIntoConstraints = false
            view.removeConstraints(view.constraints)
        }
    }
    
    @IBAction func didEnterValidInput(textField : UITextField) {
        print("Checking for valid entries")
        
        if let label = textField.accessibilityLabel {
            
            if label == Constants.PASSWORDCONFIRMTEXTFIELD {
                
                print("textField contains: \(textField.text)")
                
                if textField.text! == self.passwordTextField.text! {
                    print("getting called for every letter of the pw confirm text field")
                    
                    self.hasValidConfirmedPassword = true
                    
                    print("Valid email: \(self.hasValidEmail)\n"
                        + "Valid email confirmation: \(self.hasValidConfirmedEmail)\n"
                        + "Valid phone number: \(self.hasValidPhoneNumber)\n"
                        + "Valid password: \(self.hasValidPassword)\n"
                        + "Valid password confirmation: \(self.hasValidConfirmedPassword)")
                    
                    if self.hasValidEmail && self.hasValidConfirmedEmail && self.hasValidPhoneNumber && self.hasValidPassword && self.hasValidConfirmedPassword {
                        
                        print("all true!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        
                        UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations: {
                            
                            self.submitButtonTopConstraint?.constant = 20
                            self.submitButton.enabled = true
                            self.view.layoutIfNeeded()
                            
                            }, completion: { completed in
                        })
                        
                        
                    }
                    
                }
            }
            
        }
    }
    
    func checkValidEmailAddress (emailAddress : String) -> Bool {
        
        return emailAddress.containsString("@") && emailAddress.containsString(".")
    }
    
    func checkPhoneNumber(phoneNumber : String) -> Bool {
        
        if phoneNumber.characters.count >= 7 {
            for character in phoneNumber.characters {
                if Int(String(character)) == nil {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func checkPassword(password : String) -> Bool {
        return password.characters.count >= 6
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //print("Accesibility label of text field: \(textField.accessibilityLabel)")
        
        if let label = textField.accessibilityLabel {
            
            if label == Constants.EMAILTEXTFIELD {
                
                if let emailAddress = textField.text {
                    self.hasValidEmail = checkValidEmailAddress(emailAddress)
                    if !self.hasValidEmail {
                        animateTextField(textField, withConstraint: self.emailCenterXConstraint)
                    }
                }
            }
            else if label == Constants.EMAILCONFIRMTEXTFIELD {
                
                if let confirmedEmailAddress = textField.text {
                    self.hasValidEmail = checkValidEmailAddress(self.emailTextField.text!)
                    self.hasValidConfirmedEmail = self.hasValidEmail && confirmedEmailAddress == self.emailTextField.text!
                    if !self.hasValidConfirmedEmail {
                        animateTextField(textField, withConstraint: self.emailConfirmCenterXConstraint)
                    }
                }
                
            }
            else if label == Constants.PHONETEXTFIELD {
                
                if let phoneNumber = textField.text {
                    self.hasValidPhoneNumber = checkPhoneNumber(phoneNumber)
                    if !self.hasValidPhoneNumber {
                        animateTextField(textField, withConstraint: self.phoneCenterXConstraint)
                    }
                }
            }
            else if label == Constants.PASSWORDTEXTFIELD {
                
                if let password = textField.text {
                    self.hasValidPassword = checkPassword(password)
                    if !self.hasValidPassword {
                        animateTextField(textField, withConstraint: self.passwordCenterXConstraint)
                    }
                }
            }
            else if label == Constants.PASSWORDCONFIRMTEXTFIELD {
                
                if let confirmedPassword = textField.text {
                    self.hasValidConfirmedPassword = self.hasValidPassword && confirmedPassword == self.passwordTextField.text
                    if !self.hasValidConfirmedPassword {
                        animateTextField(textField, withConstraint: self.confirmPasswordCenterXConstraint)
                    }
                }
            }
        }
    }
    
    private func animateTextField(texField : UITextField, withConstraint constraint : NSLayoutConstraint?) {
        
        if let constraint = constraint {
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: [.CurveLinear, .Autoreverse], animations: {
                
                texField.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
                constraint.constant += self.incorrectShift
                self.view.layoutIfNeeded()
                
                UIView.animateWithDuration(0.1, delay: 0.1, options: [.CurveLinear, .Autoreverse], animations: {
                    constraint.constant -= self.incorrectShift
                    self.view.layoutIfNeeded()
                    }, completion: { completed in
                        constraint.constant = 0
                        self.view.layoutIfNeeded()
                })
                
                }, completion: { completed in
                    texField.backgroundColor = UIColor.clearColor()
                    constraint.constant = 0
                    self.view.layoutIfNeeded()
            })
        }
        
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        print("Checking for valid entries")
//        
//        if let label = textField.accessibilityLabel {
//            
//            if label == Constants.PASSWORDCONFIRMTEXTFIELD {
//                
//                print("textField contains: \(textField.text)")
//                
//                if textField.text! == self.passwordTextField.text! {
//                    print("getting called for every letter of the pw confirm text field")
//                    
//                    print("Valid email: \(self.hasValidEmail)\n"
//                        + "Valid email confirmation: \(self.hasValidConfirmedEmail)\n"
//                        + "Valid phone number: \(self.hasValidPhoneNumber)\n"
//                        + "Valid password: \(self.hasValidPassword)\n"
//                        + "Valid password confirmation: \(self.hasValidConfirmedPassword)")
//                    
//                    if self.hasValidEmail && self.hasValidConfirmedEmail && self.hasValidPhoneNumber && self.hasValidPassword && self.hasValidConfirmedPassword {
//                        
//                        self.submitButton.enabled = true
//                        
//                        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
//                            
//                            self.submitButtonTopConstraint?.constant = 20
//                            
//                            }, completion: { completed in
//                        })
//                        
//                    
//                    }
//                    
//                }
//            }
//        
//        }
//        return true
//    }
}
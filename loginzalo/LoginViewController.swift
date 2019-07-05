//
//  ViewController.swift
//  LoginZalo
//
//  Created by Anh vũ on 7/3/19.
//  Copyright © 2019 anh vu. All rights reserved.
//


import UIKit
import ZaloSDK

class LoginViewController: UIViewController {
    var loadingIndicator =  UIActivityIndicatorView()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        showProfile()
    }
    
    @IBAction func LogOutbutton(_ sender: Any) {
      logout()
    }
    
    @IBAction func loginButtonDidTouch(_ sender: Any) {
     login()
        
    }
    
    func showMainController() {
        self.performSegue(withIdentifier: "showMainController", sender: self)
    }
}

extension LoginViewController {
    func login() {
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView, parentController: self) { (response) in
            self.onAuthenticateComplete(with: response)
        }
    }
    
    func onAuthenticateComplete(with response: ZOOauthResponseObject?) {
        loadingIndicator.stopAnimating()
        if response?.isSucess == true {
//            chuyen qua man ok
            self.showProfile()
            showMainController()
        } else if let response = response,
            response.errorCode != -1001 { // not cancel
            showAlert(with: "Error \(response.errorCode)", message: response.errorMessage)
        }
    }
}

extension UIViewController {
    func showAlert(with title: String = "ZaloSDK", message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func logout() {
        ZaloSDK.sharedInstance().unauthenticate()
    }
    
    func showProfile() {
        ZaloSDK.sharedInstance().getZaloUserProfile { (response) in
            self.onLoad(profile: response)
        }
    }
    
    func onLoad(profile: ZOGraphResponseObject?) {
        guard let profile = profile,
            profile.isSucess,
            let name = profile.data["name"] as? String,
            let id = profile.data["id"] as? String,
            let gender = profile.data["gender"] as? String,
            let picture = profile.data["picture"] as? [String: Any?],
            let pictureData = picture["data"] as? [String: Any?],
            let sUrl = pictureData["url"] as? String,
            let url = URL(string: sUrl)
            else {
                return
        }
       print(id)
    }
}


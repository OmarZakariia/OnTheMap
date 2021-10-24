//
//  ExtensionForUiViewController.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 06/10/2021.
//

import UIKit

extension UIViewController{
    
    @IBAction func addLocation(sender: UIBarButtonItem){
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    func enableButton(_ enabled : Bool, button : UIButton){
        if enabled{
            button.isEnabled = true
            button.alpha = 1.0
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    func showAlert(message: String, title: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    func openSafariLink(_ url: String){
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cant open link", title: "Link is invalid")
            return
        }
        UIApplication.shared.open(url, options: [:])
        
    }
}

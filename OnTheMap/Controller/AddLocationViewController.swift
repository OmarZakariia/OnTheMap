//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Zakaria on 13/10/2021.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var objectId : String?
    var isLocationTextFieldEmpty = true
    var isWebsiteTextFieldEmpty = true
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        enableButton(false, button: findLocationButton)
    }
    

    
    // MARK: - IBAction Functions
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        self.isLoading(true)
        let newLocation = locationTextField.text
        
        guard let url = URL(string: self.websiteTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Include http://", title: "URL is invalid")
            isLoading(false)
            return
        }
        geocodeLocation(newLocation: newLocation ?? "")
//        print("Location entered is \(newLocation)")
        
        
    }
    
    
    // MARK: - Private Functions
    
    private func createStudentInformation(_ coordinate: CLLocationCoordinate2D)-> StudentInfo{
        var studentInformation = [
            "uniqueKey" : ClientUdacity.Auth.key,
            "firstName" : ClientUdacity.Auth.firstName,
            "lastName" : ClientUdacity.Auth.lastName,
            "mapString" : locationTextField.text!,
            "mediaURL" : websiteTextField.text!,
            "latitude" : coordinate.latitude,
            "longitude" : coordinate.longitude
        ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInformation["objectId"] = objectId as AnyObject
//            print(objectId + "This is the objectId")
        }
        return StudentInfo(studentInformation)
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D){
        let viewController = storyboard?.instantiateViewController(withIdentifier: "FinalAddLocationViewController") as! FinalAddLocationViewController
        viewController.studentInfo = createStudentInformation(coordinate)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func geocodeLocation(newLocation: String){
        CLGeocoder().geocodeAddressString(newLocation) { newMarker, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Cant find location provided")
                self.isLoading(false)
//                print("Cant find the location")
            } else {
                var location : CLLocation?
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Try again later.", title: "Error")
                    self.isLoading(false)
//                    print("Error occurred")
                }
            }
        }
    }
    
    
    
    
    // MARK: - isLoading
    func isLoading(_ loading: Bool){
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.enableButton(false, button: self.findLocationButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.enableButton(true, button: self.findLocationButton)
            }
        }
        DispatchQueue.main.async {
            self.locationTextField.isEnabled = !loading
            self.websiteTextField.isEnabled = !loading
            self.findLocationButton.isEnabled = !loading
        }
    }
    
}


// MARK: - UITextFieldDelegate Extension
extension AddLocationViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == locationTextField{
            let currentText = locationTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {return false}
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                isLocationTextFieldEmpty = true
            } else {
                isLocationTextFieldEmpty = false
            }
        }
        
        if textField == websiteTextField{
            let currentText = websiteTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {return false}
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                isWebsiteTextFieldEmpty = true
            } else {
                isWebsiteTextFieldEmpty = false
            }
        }
        
        if isLocationTextFieldEmpty == false && isWebsiteTextFieldEmpty == false{
            enableButton(true, button: findLocationButton)
        } else {
            enableButton(false, button: findLocationButton)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        enableButton(false, button: findLocationButton)
        if textField == locationTextField {
            isLocationTextFieldEmpty = true
        }
        if textField == websiteTextField {
            isWebsiteTextFieldEmpty = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            findLocationButtonPressed(findLocationButton)
        }
        return true
        
    }
}

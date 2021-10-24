//
//  FinalAddLocationViewController.swift
//  OnTheMap
//
//  Created by Zakaria on 13/10/2021.
//

import UIKit
import MapKit

class FinalAddLocationViewController: UIViewController {

    
    
    // MARK: - IBOutlets and Properites
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    var studentInfo : StudentInfo?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let studentLocation = studentInfo {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "''",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            displayLocations(location: studentLocation)
        }
    }
    

   
    // MARK: - Functions
    func isLoading(_ loading: Bool){
        if loading{
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.enableButton(false, button: self.finishButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.enableButton(true, button: self.finishButton)
            }
        }
        DispatchQueue.main.async {
            self.finishButton.isEnabled = !loading
        }
    }

    
    // MARK: - Private Functions
    private func getCoordinates(location: Location)-> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
    
    private func displayLocations(location : Location){
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = getCoordinates(location: location) {
            let annotation =  MKPointAnnotation()
            annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    
    // MARK: - IBAction Function
    
    @IBAction func finishLocationButtonPressed(_ sender: UIButton) {
        self.isLoading(true)
        if let studentLocation = studentInfo {
            
            if ClientUdacity.Auth.objectId == "" {
                ClientUdacity.addStudentLocation(info: studentLocation) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            self.isLoading(true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            self.isLoading(false)
                        }
                    }
                }
            } else {
                let alertVC = UIAlertController(title: "", message: "Location is already posted, overwrite?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    ClientUdacity.updateStudentLocation(info: studentLocation) { success , error in
                        if success {
                            DispatchQueue.main.async {
                                self.isLoading(true)
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            self.isLoading(false)
                            
                        }
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction) in
                    DispatchQueue.main.async {
                        self.isLoading(false)
                        self.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
            }
        }
        
    }
}
//    @IBAction func finishLocationButtonPressed(_ sender: UIButton) {
//        self.isLoading(true)
//        if let studentLocation = studentInfo {
//            if ClientUdacity.Auth.objectId == "" {
//                ClientUdacity.addStudentLocation(info: studentLocation) { success , error in
//                    if success {
//                        DispatchQueue.main.async {
//                            self.isLoading(true)
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
//                            self.isLoading(false)
//                        }
//                    }
//
//                }
//            }
//            else {
//                let alertVC = UIAlertController(title: "", message: "Location already posted, overwrite it?", preferredStyle: .alert)
//                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
//                    ClientUdacity.updateStudentLocation(info: studentLocation) { success , error  in
//                        if success {
//                            DispatchQueue.main.async {
//                                self.isLoading(true)
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                        }
//                        else {
//                            DispatchQueue.main.async {
//                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
//                                self.isLoading(false)
//                            }
//                        }
//                    }
//                }))
//
//                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
//                    DispatchQueue.main.async {
//                        self.isLoading(false)
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }))
//                self.present(alertVC, animated: true)
//            }
//        }
//    }
//
//
//
//
//}

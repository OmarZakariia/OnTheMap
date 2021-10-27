//
//  MapVC.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 07/10/2021.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {

    // MARK: -IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentLocations = [StudentInfo]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchStudentPins()

    }
    
    
    // MARK: - IBAction Function
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        
        
        fetchStudentPins()
        print("refreshButtonPressed")
        
        

    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.activityIndicator.startAnimating()
        ClientUdacity.logout {
            DispatchQueue.main.async
            {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                
            }
        }
    }
    
    
    // MARK: -Functions
    func fetchStudentPins(){
        self.activityIndicator.startAnimating()
        ClientUdacity.getStudentLocation() { locations , error in
            self.mapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.studentLocations = locations ?? []
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                self.annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                self.activityIndicator.stopAnimating()
                print("map refreshed")
            }
        }
    }
    
    // MARK: -MapKit functions
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reusableId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusableId) as? MKPinAnnotationView
//        if pinView == nil{
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusableId)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = .red
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        } else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openSafariLink(toOpen ?? "")
            }
        }
    }
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            if let toOpen = view.annotation?.subtitle{
//                openSafariLink(toOpen ?? "")
//            }
//        }
//    }
    
}

//
//  MapViewC.swift
//  OnTheMap
//
//  Created by Zakaria on 28/10/2021.
//

import UIKit
import MapKit


class MapViewC: UIViewController, MKMapViewDelegate {

    
    
    // MARK: - IBOutlets and properties
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentInfo]()
    var anonationsCreated = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        mapView.reloadInputViews()
        mapView.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchStudentPins()
        
    }

    
    // MARK: - IBActions Functions
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        self.activityIndicator.startAnimating()
        ClientUdacity.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                    
            }
        }
        
    }
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        fetchStudentPins()
    }
    

    
    // MARK: - Functions
    func fetchStudentPins(){
        self.activityIndicator.startAnimating()
        ClientUdacity.getStudentLocation() { locations, error in
            self.mapView.removeAnnotations(self.anonationsCreated)
            self.anonationsCreated.removeAll()
            self.locations = locations ?? []
            for dictionary in locations ?? [] {
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let lon = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaURL = dictionary.mediaURL
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                DispatchQueue.main.async {
                    self.anonationsCreated.append(annotation)
                }
                print("\(annotation) annotationnnnnnn")
            }
            DispatchQueue.main.async {
                
                self.mapView.addAnnotations(self.anonationsCreated)
                self.activityIndicator.stopAnimating()
                
            }
        }
    }
    
    
    // MARK: - MapView Data source
    func mapView(_ mapView: MKMapView, viewFor annotation : MKAnnotation) -> MKAnnotationView?{
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle{
                openSafariLink(toOpen ?? "")
            }
        }
    }
    
}

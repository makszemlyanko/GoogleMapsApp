//
//  MainViewController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 16.08.2022.
//

import UIKit
import MapKit
import LBTATools
import SwiftUI

class MainViewController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupRegionForMap()
        setupAnnotationForMap()
    }
    
    fileprivate func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    fileprivate func setupAnnotationForMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 59.931505, longitude: 30.364036)
        annotation.title = "Saint-Petersburg"
        annotation.subtitle = "Russia"
        mapView.addAnnotation(annotation)
        
        let petergofAnnotation = MKPointAnnotation()
        petergofAnnotation.coordinate = CLLocationCoordinate2D(latitude: 59.886560, longitude: 29.908711)
        petergofAnnotation.title = "Petergof"
        petergofAnnotation.subtitle = "SPB"
        mapView.addAnnotation(petergofAnnotation)
    
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    fileprivate func setupRegionForMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.931505, longitude: 30.364036)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region  = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        return annotationView
    }
}


// MARK: - SwiftUI Preview

struct MainPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainViewController {
            return MainViewController()
        }
        
        func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
            
        }
        
        typealias UIViewControllerType = MainViewController
    }
}




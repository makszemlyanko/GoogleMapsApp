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
    let searchTextField = UITextField(placeholder: "Search")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
        
        setupRegionForMap()
        
//        setupAnnotationsForMap()
        performLocalSearch()
        setupSearchUI()
    }
    
    fileprivate func setupSearchUI() {
        let whiteContainer = UIView(backgroundColor: .white)
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        // listen for text changes and then perform new search
        // old school :)
//        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
        
        // new school :) Search Throttling
        // search on the last keystroke of text changes and basically wait 500 milliseconds
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { (_) in
                self.performLocalSearch()
            }
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search:", err)
                return
            }
            
            // Success
            self.mapView.removeAnnotations(self.mapView.annotations) // remove old annotations
            
            resp?.mapItems.forEach({ (mapItem) in
                
                print(mapItem.adress())
            
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
//                mapItem.placemark.coordinate
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    fileprivate func setupAnnotationsForMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        mapView.addAnnotation(annotation)
        
        let appleCampusAnnotation = MKPointAnnotation()
        appleCampusAnnotation.coordinate = .init(latitude: 37.3326, longitude: -122.030024)
        appleCampusAnnotation.title = "Apple Campus"
        appleCampusAnnotation.subtitle = "Cupertino, CA"
        mapView.addAnnotation(appleCampusAnnotation)
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
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

extension MKMapItem {
    func adress() -> String {
        var addressString = ""
        if placemark.subThoroughfare != nil {
            addressString = placemark.subThoroughfare! + " "
        }
        if placemark.thoroughfare != nil {
            addressString += placemark.thoroughfare! + ", "
        }
        if placemark.postalCode != nil {
            addressString += placemark.postalCode! + " "
        }
        if placemark.locality != nil {
            addressString += placemark.locality! + ", "
        }
        if placemark.administrativeArea != nil {
            addressString += placemark.administrativeArea! + " "
        }
        if placemark.country != nil {
            addressString += placemark.country!
        }
        return addressString
    }
}

// MARK: - SwiftUI Preview

//struct MainPreview: PreviewProvider {
//    
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//    
//    struct ContainerView: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> MainViewController {
//            return MainViewController()
//        }
//        
//        func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
//            
//        }
//        
//        typealias UIViewControllerType = MainViewController
//    }
//}
//



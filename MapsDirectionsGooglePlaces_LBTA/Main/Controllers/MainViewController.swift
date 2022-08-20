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
    
    let locationsController = LocationsCarouselController(scrollDirection: .horizontal)
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupRegionForMap()
        setupMapView()
        setupSearchUI()
        setupLocationsCarousel()
        performLocalSearch()
        requestUserlocation()
        mapView.showsUserLocation = true
    }
    
    fileprivate func requestUserlocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    fileprivate func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    fileprivate func setupSearchUI() {
        let whiteContainer = UIView(backgroundColor: .white)
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        // listen for text changes and then perform new search
        // OLD SCHOOL
        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
        
        
        // NEW SCHOOL Search Throttling
        // search on the last keystroke of text changes and basically wait 500 milliseconds
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
//            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//            .sink { (_) in
//                self.performLocalSearch()
//        }
    }
    
    fileprivate func setupLocationsCarousel() {
        let locationsView = locationsController.view!
        locationsController.mainController = self
        view.addSubview(locationsView)
        locationsView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        request.region = mapView.region
        
        mapView.annotations.forEach { (annotation) in
            if annotation.title == "TEST" {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search:", err)
                return
            }
            
            // Success
            // remove old annotations
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.locationsController.items.removeAll()
            
            resp?.mapItems.forEach({ (mapItem) in
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
                // tell our locationsController
                self.locationsController.items.append(mapItem)
            })
            self.locationsController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
//    fileprivate func setupRegionForMap() {
//        let centerCoordinate = CLLocationCoordinate2D(latitude: 39.803729242358195, longitude: -104.97505054145867)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
//        mapView.setRegion(region, animated: true)
//    }
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




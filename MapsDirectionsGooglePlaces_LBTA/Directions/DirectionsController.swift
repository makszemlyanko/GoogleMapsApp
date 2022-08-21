//
//  DirectionsController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 21.08.2022.
//

import UIKit
import LBTATools
import MapKit
import SwiftUI

class DirectionsController: UIViewController {
    
    let mapView = MKMapView()
    let navBar = UIView(backgroundColor: #colorLiteral(red: 0.1231942251, green: 0.5648767352, blue: 0.9659515023, alpha: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarUI()
        setupMavView()
        setupRegionForMap() // San Francisco
        setupStartAndDummyAnnotations()
        
    }
    
    fileprivate func setupStartAndDummyAnnotations() {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = .init(latitude: 37.773972, longitude: -122.431297)
        startAnnotation.title = "Start"
        
        let endAnnotation = MKPointAnnotation()
        endAnnotation.coordinate = .init(latitude: 37.331352, longitude: -122.030331)
        endAnnotation.title = "End"
        
        mapView.addAnnotation(startAnnotation)
        mapView.addAnnotation(endAnnotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    fileprivate func setupMavView() {
        view.addSubview(mapView)
        mapView.anchor(top: navBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        mapView.showsUserLocation = true
    }
    
    fileprivate func setupNavBarUI() {
        view.addSubview(navBar)
        navBar.setupShadow(opacity: 0.5, radius: 5); #warning("no shadow")
        navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -100, right: 0))
        
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

// MARK: - SwiftUI Preview

struct DirectionsPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark) // dark mode for map
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> DirectionsController {
            return DirectionsController()
        }
        
        func updateUIViewController(_ uiViewController: DirectionsController, context: Context) {
            
        }
        
        typealias UIViewControllerType = DirectionsController
    }
}

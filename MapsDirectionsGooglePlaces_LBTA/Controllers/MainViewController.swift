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
        view.addSubview(mapView)
        mapView.fillSuperview()
        setupRegionForMap()
    }
    
    fileprivate func setupRegionForMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.931505, longitude: 30.364036)
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region  = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
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

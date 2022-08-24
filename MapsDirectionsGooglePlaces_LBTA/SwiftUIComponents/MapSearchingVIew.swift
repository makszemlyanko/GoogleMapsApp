//
//  MapSearchingVIew.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 24.08.2022.
//

import SwiftUI
import MapKit

struct MapViewContainer: UIViewRepresentable {
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        setupRegionForMap()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    typealias UIViewType = MKMapView
}

struct MapSearchingVIew: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            MapViewContainer()
                .ignoresSafeArea(.all)
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("Search for airports")
                        .padding()
                        .background(Color.white)
                })
                Button(action: {
                    
                }, label: {
                    Text("Search for airports")
                        .padding()
                        .background(Color.white)
                })
            }.shadow(radius: 3)
        }
    }
}

struct MapSearchingVIew_Previews: PreviewProvider {
    
    static var previews: some View {
        MapSearchingVIew()
    }
}

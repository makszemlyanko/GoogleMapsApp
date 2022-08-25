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
    
    var annotations = [MKPointAnnotation]()
    
    func makeUIView(context: Context) -> MKMapView {
        setupRegionForMap()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(uiView.annotations, animated: false)
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    typealias UIViewType = MKMapView
}


class MapSearchingViewModel: ObservableObject {
    
    @Published var annotations = [MKPointAnnotation]()
    @Published var isSearching = false
    
    fileprivate func performSearch(query: String) {
        // perform an airport search
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
            if let error = error {
                print("Failed to search: ", error)
                return
            }
            
            var airportAnnotations = [MKPointAnnotation]()
            
            response?.mapItems.forEach({ (item) in
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                airportAnnotations.append(annotation)
            })
            Thread.sleep(forTimeInterval: 1)
            self.isSearching = false
            self.annotations = airportAnnotations
        }
    }
}

struct MapSearchingVIew: View {
    
    @ObservedObject var vm = MapSearchingViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapViewContainer(annotations: vm.annotations)
                .ignoresSafeArea(.all)
            VStack(spacing: 12) {
                HStack {
                    Button(action: {
                        self.vm.performSearch(query: "airport")
                    }, label: {
                        Text("Search for airports")
                            .padding()
                            .background(Color.white)
                    })
                    Button(action: {
                        self.vm.annotations = []
                    }, label: {
                        Text("Clear Annotations")
                            .padding()
                            .background(Color.white)
                    })
                }.shadow(radius: 3)
                if vm.isSearching {
                    Text("Searching...")
                }
            }
        }
    }
}

struct MapSearchingVIew_Previews: PreviewProvider {
    
    static var previews: some View {
        MapSearchingVIew()
    }
}

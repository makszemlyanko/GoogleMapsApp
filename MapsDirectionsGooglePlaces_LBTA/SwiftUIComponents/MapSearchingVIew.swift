//
//  MapSearchingVIew.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 24.08.2022.
//

import SwiftUI
import MapKit

struct MapViewContainer: UIViewRepresentable {
    
    var annotations = [MKPointAnnotation]()
    
    var selectedMapItem: MKMapItem?
    
    let mapView = MKMapView()
    
    // treat this as your setup area
    func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
        setupRegionForMap()
        return mapView
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(uiView.annotations, animated: false)
        
        uiView.annotations.forEach { (annotation) in
            if annotation.title == selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    typealias UIViewType = MKMapView
    
    
}

import Combine

// keep track of properties that your view needs to render
class MapSearchingViewModel: ObservableObject {
    
    @Published var annotations = [MKPointAnnotation]()
    @Published var isSearching = false
    @Published var searchQuery = ""
    @Published var mapItems = [MKMapItem]()
    @Published var selectedMapItem: MKMapItem?
    
    var cancellable: AnyCancellable?
    
    init() {
        print("Initializing view model")
        // combine code
        cancellable = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (searchTerm) in
                self?.performSearch(query: searchTerm)
        }
    }
    
    fileprivate func performSearch(query: String) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            // handle your error
            
            self.mapItems = resp?.mapItems ?? []
            
            var airportAnnotations = [MKPointAnnotation]()
            
            resp?.mapItems.forEach({ (mapItem) in
                print(mapItem.name ?? "")
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                airportAnnotations.append(annotation)
            })
            
//            Thread.sleep(forTimeInterval: 1)
            self.isSearching = false
            
            self.annotations = airportAnnotations
        }
    }
}


struct MapSearchingView: View {
    
    @ObservedObject var vm = MapSearchingViewModel()
    
//    @State var searchQuery = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            
            MapViewContainer(annotations: vm.annotations, selectedMapItem: vm.selectedMapItem)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Search terms", text: $vm.searchQuery)
//                    .padding()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                    
                    
                }.shadow(radius: 3)
                    .padding()
                
                if vm.isSearching {
                    Text("Searching...")
                }
                
                Spacer()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(vm.mapItems, id: \.self) { item in
          
                            Button(action: {
                                self.vm.selectedMapItem = item
                            }, label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name ?? "")
                                        .font(.headline)
                                    Text(item.placemark.title!)
                                }
                            }).foregroundColor(.black)
                            
                            
                            .padding()
                            .frame(width: 250)
                            .background(Color.white)
                            .cornerRadius(5)
                        }
                    }.padding(.horizontal, 16)
                }.shadow(radius: 5)
                
                
            }
        }
        
    }
    
}


struct MapSearchingView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapSearchingView()
    }
}

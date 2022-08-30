//
//  MapSearchingVIew.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 24.08.2022.
//

import SwiftUI
import MapKit
import Combine

struct MapViewContainer: UIViewRepresentable {
    
    var annotations = [MKPointAnnotation]()
    var selectedMapItem: MKMapItem?
    let mapView = MKMapView()
    var currentLocation = CLLocationCoordinate2D()
    
    // treat this as your setup area
    func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
//        setupRegionForMap()
        mapView.showsUserLocation = true
        return mapView
    }
    
    func makeCoordinator() -> MapViewContainer.Coordinator {
        return Coordinator(mapView: mapView)
    }
    
    // Custom pin annotation
    class Coordinator: NSObject, MKMapViewDelegate {
        
        static let regionChangedNotification = Notification.Name("regionChangedNotification")
        
        init(mapView: MKMapView) {
            super.init()
            mapView.delegate = self
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if !(annotation is MKPointAnnotation) { return nil } // blue dot current location appear
            
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
            pinAnnotationView.canShowCallout = true
            return pinAnnotationView
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            NotificationCenter.default.post(name: MapViewContainer.Coordinator.regionChangedNotification, object: mapView.region)
        }
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.773972, longitude: -122.431297)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
        
        if annotations.count == 0 {
            // setting up the map to current location
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: currentLocation, span: span)
            uiView.setRegion(region, animated: true)
            
            
            uiView.removeAnnotations(uiView.annotations)
            return
        }
        
        if shouldRefreshAnnotations(mapView: uiView) {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
            uiView.showAnnotations(uiView.annotations.filter{$0 is MKPointAnnotation}, animated: false)
        }
        
        uiView.annotations.forEach { (annotation) in
            if annotation.title == selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    // This checks to see whether or not annotations have changed.  The algorithm generates a hashmap/dictionary for all the annotations and then goes through the map to check if they exist. If it doesn't currently exist, we treat this as a need to refresh the map
    fileprivate func shouldRefreshAnnotations(mapView: MKMapView) -> Bool {
        let grouped = Dictionary(grouping: mapView.annotations, by: { $0.title ?? ""})
        for (_, annotation) in annotations.enumerated() {
            if grouped[annotation.title ?? ""] == nil {
                return true
            }
        }
        return false
    }
    
    typealias UIViewType = MKMapView
}

// keep track of properties that your view needs to render
class MapSearchingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var annotations = [MKPointAnnotation]()
    @Published var isSearching = false
    @Published var searchQuery = ""
    @Published var mapItems = [MKMapItem]()
    @Published var selectedMapItem: MKMapItem?
    @Published var keyboardHeight: CGFloat = 0
    @Published var currentLocation = CLLocationCoordinate2D()
    
    var cancellable: AnyCancellable?
    
    let locationManager = CLLocationManager()
    
    fileprivate var region: MKCoordinateRegion?
    
    override init() {
        super.init()
        print("Initializing view model")
        // combine code
        cancellable = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (searchTerm) in
                self?.performSearch(query: searchTerm)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        listenForKeyboardNotifications()
        
        NotificationCenter.default.addObserver(forName: MapViewContainer.Coordinator.regionChangedNotification, object: nil, queue: .main) { [weak self] (notification) in
            self?.region = notification.object as? MKCoordinateRegion
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else { return }
        self.currentLocation = firstLocation.coordinate
    }
    
    fileprivate func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (notification) in
            guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrame = value.cgRectValue
            let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
            
            withAnimation(.easeOut(duration: 0.25)) {
                self?.keyboardHeight = keyboardFrame.height - window!.safeAreaInsets.bottom
            }
            print(keyboardFrame.height)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
            withAnimation(.easeOut(duration: 0.25)) {
                self?.keyboardHeight = 0
            }
            
        }
    }
    
    fileprivate func performSearch(query: String) {
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let region = self.region {
            request.region = region
        }
        
        
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
            
            MapViewContainer(annotations: vm.annotations,
                             selectedMapItem: vm.selectedMapItem,
                             currentLocation: vm.currentLocation)
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

//
//  DirectionsSearchView.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 30.08.2022.
//

import SwiftUI
import MapKit

struct DirectionsMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

struct SelectLocationView: View {
    
    @Binding var isShowing: Bool
    
    @State var mapItems = [MKMapItem]()
    
    @State var searchQuery = ""
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button(action: {
                    self.isShowing = false
                }, label: {
                    Image(uiImage: #imageLiteral(resourceName: "back_arrow"))
                })
                
                TextField("Enter search term", text: self.$searchQuery)
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).debounce(for: .milliseconds(500), scheduler: RunLoop.main), perform: { _ in
                        let request = MKLocalSearch.Request()
                        request.naturalLanguageQuery = self.searchQuery
                        let search = MKLocalSearch(request: request)
                        search.start { (response, error) in
                            if let error = error {
                                print("Failed to local search: ", error)
                                return
                            }
                            self.mapItems = response?.mapItems ?? []
                        }
                    })
            }
            .padding()
     
            if mapItems.count > 0 {
                ScrollView {
                    ForEach(mapItems, id: \.self) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(item.name ?? "")")
                                    .font(.headline)
                                Text("\(item.adress())")
                            }
                            .padding()
                            Spacer()
                        }
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
//        .onAppear(perform: {
//            // search
//            let request = MKLocalSearch.Request()
//            request.naturalLanguageQuery = "Sushi"
//            let search = MKLocalSearch(request: request)
//            search.start { (response, error) in
//                if let error = error {
//                    print("Failed to local search: ", error)
//                    return
//                }
//                self.mapItems = response?.mapItems ?? []
//            }
//
//        })
        .navigationBarHidden(true)
    }
}

struct DirectionsSearchView: View {
    
    @State var isSelectingSource = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: -4) {
                    VStack {
                        
                        HStack(spacing: 16) {
                            Image(uiImage: #imageLiteral(resourceName: "start_location_circles")).frame(width: 24, height: 24)
                            NavigationLink(
                                destination: SelectLocationView(isShowing: $isSelectingSource),
                                isActive: $isSelectingSource,
                                label: {
                                    HStack {
                                        Text("Source")
                                        Spacer()
                                    }.padding()
                                    .background(Color.white)
                                    .cornerRadius(3)
                                })
                        }
                        
                        HStack(spacing: 16) {
                            Image(uiImage: #imageLiteral(resourceName: "annotation_icon")
                                    .withRenderingMode(.alwaysTemplate))
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                            HStack {
                                Text("Destination")
                                Spacer()
                            }.padding()
                            .background(Color.white)
                            .cornerRadius(3)
                            
                        }
                        
                    }.padding()
                    .background(Color.blue)
                    
                    Spacer()
                    DirectionsMapView().edgesIgnoringSafeArea(.bottom)
                }
                
                // status bar cover
                Spacer().frame(width: UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.window?.frame.width,
                               height: UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.top)
                    .background(Color.blue)
                    .edgesIgnoringSafeArea(.top)
            }
            .navigationBarTitle("Search")
            .navigationBarHidden(true)
        }
    }
}

struct DirectionsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsSearchView()
    }
}

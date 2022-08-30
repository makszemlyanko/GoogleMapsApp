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

struct DirectionsSearchView: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: -4) {
                VStack {
                    
                    HStack(spacing: 16) {
                        Image(uiImage: #imageLiteral(resourceName: "start_location_circles")).frame(width: 24, height: 24)
                        HStack {
                            Text("Source")
                            Spacer()
                        }.padding()
                        .background(Color.white)
                        .cornerRadius(3)
                        
                        
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
    }
}

struct DirectionsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsSearchView()
    }
}

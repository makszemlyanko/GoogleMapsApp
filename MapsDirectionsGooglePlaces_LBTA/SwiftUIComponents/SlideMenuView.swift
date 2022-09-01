//
//  SlideMenuView.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 01.09.2022.
//

import SwiftUI
import MapKit

struct MenuItem: Identifiable, Hashable {
    let id = UUID().uuidString
    let title: String
    let mapType: MKMapType
    let mapTypeIcon: String
}

struct SlideMenuView: View {
    
    @State var isShowingMenu = false
    @State var mapType: MKMapType = .standard
    
    let menuItems: [MenuItem] = [
        .init(title: "Standard", mapType: .standard, mapTypeIcon: "car"),
        .init(title: "Hybrid", mapType: .hybrid, mapTypeIcon: "antenna.radiowaves.left.and.right"),
        .init(title: "Globe", mapType: .satelliteFlyover, mapTypeIcon: "safari")
    ]
    
    var body: some View {
        ZStack {
            SlideMenuMapView(mapType: mapType)
                .edgesIgnoringSafeArea(.all)
            
            // Menu button
            HStack {
                VStack {
                    Button(action: {
                        self.isShowingMenu.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .font(.system(size: 42))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    })
                    Spacer()
                }
                Spacer()
            }.padding()
            
            // Dark map background
            Color(.init(white: 0, alpha: self.isShowingMenu ? 0.5 : 0))
                .edgesIgnoringSafeArea(.all)
                .animation(.spring())
            
            // Menu
            HStack {
                ZStack {
                    Color(.systemBackground)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: {
                            self.isShowingMenu.toggle()
                        })
                    HStack {
                        VStack {
                            HStack {
                                Button(action: {
                                    self.isShowingMenu.toggle()
                                }, label: {
                                    Text("Menu")
                                        .foregroundColor(Color(.label))
                                        .font(.system(size: 26, weight: .bold))
                                    Spacer()
                                })
                            }.padding()
                         
                            VStack {
                                ForEach(menuItems, id: \.self) { item in
                                    Button(action: {
                                        self.mapType = item.mapType
                                        self.isShowingMenu.toggle()
                                    }, label: {
                                        HStack(spacing: 16) {
                                            Image(systemName: item.mapTypeIcon)
                                            Text(item.title)
                                            Spacer()
                                        }.padding()
                                    }).foregroundColor(self.mapType != item.mapType ? Color(.label) : Color(.systemBackground))
                                    .background(self.mapType == item.mapType ? Color(.label) : Color(.systemBackground))
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(width: 200)
                Spacer()
            }.offset(x: self.isShowingMenu ? 0 : -200)
            .animation(.spring())
            
            
        }
    }
}

struct SlideMenuMapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    var mapType: MKMapType
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
    }
        
}

struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.dark, .light], id: \.self) { scheme in
            SlideMenuView().colorScheme(scheme)
        }
    }
}

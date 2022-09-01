//
//  SlideMenuView.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 01.09.2022.
//

import SwiftUI
import MapKit

struct SlideMenuView: View {
    
    @State var isShowingMenu = false
    
    var body: some View {
        ZStack {
            SlideMenuMapView()
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
            
            // dark map background
            Color(.init(white: 0, alpha: self.isShowingMenu ? 0.5 : 0))
                .edgesIgnoringSafeArea(.all)
                .animation(.spring())
            
            // Menu
            HStack {
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: {
                            self.isShowingMenu.toggle()
                        })
                    VStack {
                        Text("menu")
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
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
            
    }
        
}

struct SlideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenuView()
    }
}

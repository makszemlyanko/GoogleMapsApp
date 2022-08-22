//
//  LocationSearchController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 22.08.2022.
//

import SwiftUI
import UIKit
import LBTATools
import MapKit

class LocationSearchCell: LBTAListCell<MKMapItem> {
    
    override var item: MKMapItem! {
        didSet {
            nameLabel.text = item.name
            addressLabel.text = item.adress() // address() from extensions
        }
    }
    
    let nameLabel = UILabel(font: .boldSystemFont(ofSize: 16))
    let addressLabel = UILabel(font: .systemFont(ofSize: 14), numberOfLines: 2)
    
    
    override func setupViews() {
        stack(nameLabel, addressLabel).withMargins(.allSides(16))
        addSeparatorView(leftPadding: 16)
    }
}

class LocationSearchController: LBTAListController<LocationSearchCell, MKMapItem> {
    
    var selectionHandler: ((MKMapItem) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performLocalSearch()
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Apple"
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("Failed to search: ", error)
                return
            }
            self.items = response?.mapItems ?? []
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mapItem = self.items[indexPath.item]
        selectionHandler?(mapItem)
        navigationController?.popViewController(animated: true)
    }
    
}

extension LocationSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 90)
    }
}

// MARK: - SwiftUI Preview

struct LocationSearchController_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            LocationSearchController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

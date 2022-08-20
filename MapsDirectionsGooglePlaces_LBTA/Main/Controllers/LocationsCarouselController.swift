//
//  LocationsCarouselController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 20.08.2022.
//

import UIKit
import LBTATools
import MapKit

class LocationCell: LBTAListCell<MKMapItem> {
    
    override var item: MKMapItem! {
        didSet {
            locationLabel.text = item.name
            addressLabel.text = item.adress()
        }
    }
    
    let locationLabel = UILabel(text: "Location", font: .boldSystemFont(ofSize: 16))
    
    let addressLabel = UILabel(text: "Address", numberOfLines: 0)
    
    override func setupViews() {
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
        layer.cornerRadius = 10
        stack(locationLabel, addressLabel).withMargins(.allSides(16))
    }
}

class LocationsCarouselController: LBTAListController<LocationCell, MKMapItem> {
    
    weak var mainController: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        
//        let placemark = MKPlacemark(coordinate: .init(latitude: 10, longitude: 55))
//        let dummyMapItem = MKMapItem(placemark: placemark)
//        dummyMapItem.name = "Dummy location for example"
//        self.items = [dummyMapItem]
        
//        self.items = ["1", "2", "3"]
        
        
    }
}

extension LocationsCarouselController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let annotations = mainController?.mapView.annotations
        annotations?.forEach({ (annotation) in
            if annotation.title == self.items[indexPath.item].name {
                mainController?.mapView.selectAnnotation(annotation, animated: true)
            }
        })
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

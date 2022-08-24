//
//  RouteViewController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Maks Kokos on 23.08.2022.
//

import UIKit
import LBTATools
import MapKit
import SwiftUI

class RouteHeader: UICollectionReusableView {
    
    let nameLabel = UILabel()
    let distanceLabel = UILabel()
    let estimatedTimeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = hstack(stack(nameLabel,
                                     distanceLabel,
                                     estimatedTimeLabel,
                                     spacing: 8),
                               alignment: .center).withMargins(.init(top: 16, left: 24, bottom: 16, right: 16))
        addSubview(stackView)
        
    }
    
    func setupHeaderInformation(route: MKRoute) {
        nameLabel.attributedText = generateAttributedString(title: "Route", description: route.name)
        
        let milesDistance = route.distance / 1000
        
        let milesString = String(format: "%.2f km", milesDistance)
        
        distanceLabel.attributedText = generateAttributedString(title: "Distance", description: milesString)
        
        var timeString = ""
        
        if route.expectedTravelTime > 3600 {
            let h = Int(route.expectedTravelTime / 60 / 60)
            let m = Int((route.expectedTravelTime.truncatingRemainder(dividingBy: 60 * 60)) / 60)
            timeString = String(format: "%d hr %d min", h, m)
        } else {
            let time = Int(route.expectedTravelTime / 60)
            timeString = String(format: "%d min", time)
        }

        estimatedTimeLabel.attributedText = generateAttributedString(title: "Estimated Time", description: timeString)
    }
    
    fileprivate func generateAttributedString(title: String, description: String) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: title + ": ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attributeString.append(.init(string: description, attributes: [.font: UIFont.systemFont(ofSize: 16)]))
        return attributeString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RouteCell: LBTAListCell<MKRoute.Step> {
    
    override var item: MKRoute.Step! {
        didSet {
            nameLabel.text = item.instructions
            let kilometersConversion = item.distance / 1000
            distanceLabel.text = String(format: "%.2f km", kilometersConversion)
        }
    }
    
    let nameLabel = UILabel(numberOfLines: 2)
    let distanceLabel = UILabel(font: .systemFont(ofSize: 14), textColor: .lightGray, textAlignment: .right)
    
    override func setupViews() {
        hstack(nameLabel, distanceLabel.withWidth(80)).withMargins(.allSides(16))
        addSeparatorView(leftPadding: 16)
    }
    
}

class RouteViewController: LBTAListHeaderController<RouteCell, MKRoute.Step, RouteHeader>, UICollectionViewDelegateFlowLayout {
    
    let mapView = MKMapView()
    
    var route: MKRoute!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupHeader(_ header: RouteHeader) {
        header.setupHeaderInformation(route: route)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: 0, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width - 16, height: 70)
    }
}



// MARK: - SwiftUI Preview

struct RouteViewController_Preview: PreviewProvider {
    static var previews: some View {
        ContainerView().ignoresSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            RouteViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

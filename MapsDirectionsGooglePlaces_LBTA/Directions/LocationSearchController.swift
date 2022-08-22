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
    let searchTextField = IndentedTextField(placeholder: "Enter search term", padding: 12, backgroundColor: .white)
    let backIcon = UIButton(image: #imageLiteral(resourceName: "back_arrow"), tintColor: .white, target: self, action: #selector(handleBack)).withWidth(32)
    let navBarHeight: CGFloat = 66
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performLocalSearch()
        setupSearchBar()
        searchTextField.becomeFirstResponder()
    }
    
    fileprivate func setupSearchBar() {
        let navBar = UIView(backgroundColor: #colorLiteral(red: 0.2594739795, green: 0.5265274644, blue: 0.9591371417, alpha: 1))
        view.addSubview(navBar)
        navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -navBarHeight, right: 0))
        
        // fix scrollBar insets
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        
        let container = UIView(backgroundColor: .clear)
        navBar.addSubview(container)
        container.fillSuperviewSafeAreaLayoutGuide()
        container.hstack(backIcon, searchTextField, spacing: 12).withMargins(.init(top: 0, left: 16, bottom: 16, right: 16))
        searchTextField.layer.borderWidth = 2
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.cornerRadius = 5
        
        setupSearchListener()
    }
    
    fileprivate func setupSearchListener() {
        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTextField.text
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: navBarHeight, left: 0, bottom: 0, right: 0)
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

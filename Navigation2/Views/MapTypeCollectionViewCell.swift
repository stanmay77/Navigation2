//
//  MapTypeCollectionViewCell.swift
//  Navigation2
//
//  Created by STANISLAV MAYBORODA on 9/4/23.
//

//import UIKit
import MapKit

class MapTypeCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "mapTypeCell"

    let mapTypeImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let mapTypeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .accent
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func configureCell(for mapType: MKMapType) {
        
        self.contentView.addSubview(mapTypeImageView)
        self.contentView.addSubview(mapTypeLabel)
        
        self.layer.borderColor = UIColor.accent.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            mapTypeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mapTypeImageView.heightAnchor.constraint(equalToConstant: 150),
            mapTypeImageView.widthAnchor.constraint(equalToConstant: 150),
            mapTypeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            mapTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapTypeLabel.topAnchor.constraint(equalTo: mapTypeImageView.bottomAnchor, constant: 5),
            mapTypeLabel.heightAnchor.constraint(equalToConstant: 50),
            mapTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        switch mapType {
        case .standard:
            mapTypeImageView.image = UIImage(named: "standard")
            mapTypeLabel.text = "Standard"
        case .satellite:
            mapTypeImageView.image = UIImage(named: "satellite")
            mapTypeLabel.text = "Satellite"
        default:
            mapTypeImageView.image = UIImage(named: "standard")
            mapTypeLabel.text = ""
            
        }
        
    }
}

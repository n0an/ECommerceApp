//
//  MapViewCell.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import MapKit

class MapViewCell: UITableViewCell {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    func configureCell(property: Property) {
        
        var region = MKCoordinateRegion()
        
        guard property.latitude != 0.0 && property.longitude != 0.0 else {
            return
        }
        
        region.center.latitude = property.latitude
        region.center.longitude = property.longitude
        
        region.span.latitudeDelta = 10
        region.span.longitudeDelta = 10
        
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = property.title
        annotation.subtitle = "\(property.numberOfRooms) bedroom \(property.properyType!)"
        annotation.coordinate = CLLocationCoordinate2D(latitude: property.latitude, longitude: property.longitude)
        
        mapView.addAnnotation(annotation)
        
    }

}

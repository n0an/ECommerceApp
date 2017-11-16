//
//  MapViewController.swift
//  ECommerceApp
//
//  Created by Anton Novoselov on 16/11/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate:class {
    func didFinishWith(coordinate: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var pinCoordinates: CLLocationCoordinate2D?
    
    weak var delegate: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTap))
        
        longTapGesture.delegate = self
        mapView.addGestureRecognizer(longTapGesture)
        
        var region = MKCoordinateRegion()
        region.center.latitude = 45.55
        region.center.longitude = 14.54
        
        region.span.latitudeDelta = 100
        region.span.longitudeDelta = 100
        
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK - HELPER METHODS
    @objc func handleLongTap(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            
            // drop pin
            dropPin(coordinate: coordinates)
            
            
        }
    }
    
    func dropPin(coordinate: CLLocationCoordinate2D) {
        // remove all existing pins from the map
        mapView.removeAnnotations(mapView.annotations)
        
        pinCoordinates = coordinate
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        
    }
    
    // MARK - ACTIONS
    @IBAction func actionDoneButtonTapped(_ sender: Any) {
        
        if mapView.annotations.count == 1 && pinCoordinates != nil {
            
            delegate?.didFinishWith(coordinate: pinCoordinates!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

// MARK - UIGestureRecognizerDelegate
extension MapViewController: UIGestureRecognizerDelegate {
    
}













//
//  ViewController.swift
//  SwiftMap
//
//  Created by Al Pascual on 1/10/17.
//  Copyright © 2017 Al Pascual. All rights reserved.
//

import UIKit
import ArcGIS
import MapKit

class ViewController: UIViewController, AGSMKMapViewDelegate {

    @IBOutlet weak var mapView: AGSMKMapView!
    var geocoder: CLGeocoder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mapView = mapView else {
            return
        }
        
        mapView.mapType = .standard
        var region = MKCoordinateRegion()
        
        region.center.latitude = 40.105085
        region.center.longitude = -99.005237
        region.span.latitudeDelta = 36
        region.span.longitudeDelta = 36
        
        mapView.region = region
        mapView.showsUserLocation = true
        
        geocoder = CLGeocoder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func mapView(_ mapView: AGSMKMapView, didUpdate userLocation: MKUserLocation) {
        geocoder?.reverseGeocodeLocation(mapView.userLocation!.location!, completionHandler: { placemark, error in
            // TODO placemark
            print(placemark?.count ?? 0)
        })
    }
}


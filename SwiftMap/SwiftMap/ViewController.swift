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

class ViewController: UIViewController {

    @IBOutlet weak var mapView: AGSMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(mapView?)
        
        mapView!.mapType = .standard
        var region = MKCoordinateRegion()
        
        region.center.latitude = 40.105085
        region.center.longitude = -99.005237
        region.span.latitudeDelta = 36
        region.span.longitudeDelta = 36
        
        mapView!.region = region
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  MKMapView.swift
//  SwiftMap
//
//  Created by Al Pascual on 1/10/17.
//  Copyright © 2017 Al Pascual. All rights reserved.
//

import UIKit
import MapKit
import ArcGIS

class AGSMKMapView: AGSMapView, MKMapViewDelegate {

    public var mapType: MKMapType = .standard
    private var savedRegion: MKCoordinateRegion?
    private var wgs84Point: AGSPoint?
    
    var region: MKCoordinateRegion? {
        set {
            savedRegion = newValue
            
            wgs84Point = AGSPoint(x: newValue!.center.longitude, y: newValue!.center.latitude, spatialReference: AGSSpatialReference.wgs84())
            var basemap: AGSBasemap?
            switch mapType {
            case .standard:
                basemap = AGSBasemap.streets()
            case .satellite:
                basemap = AGSBasemap.imagery()
            case .hybrid:
                basemap = AGSBasemap.imageryWithLabels()
            default:
                basemap = AGSBasemap.nationalGeographic()
            }
            
            let map = AGSMap(basemap: basemap!)
            self.map = map

        } get {
            return savedRegion
        }
    }
    
    private var showUserLoationSaved = false
    var showsUserLocation: Bool? {
        set {
            if let newValue = newValue {
                showUserLoationSaved = newValue
                locationDisplay.showLocation = newValue
                locationDisplay.showAccuracy = newValue
                locationDisplay.showPingAnimationSymbol = newValue
                if newValue && locationDisplay.started == false {
                    locationDisplay.start(completion: { error in
                        if error != nil {
                            print("ERROR: \(error.debugDescription)")
                        }
                    })
                } else {
                    locationDisplay.stop()
                }
            }
        } get {
            return showUserLoationSaved
        }
    }
    
    var userLocation: MKUserLocation?
}

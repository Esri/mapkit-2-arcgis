//
//  AGSMKMapViewDelegate.swift
//  SwiftMap
//
//  Created by Al Pascual on 1/11/17.
//  Copyright © 2017 Al Pascual. All rights reserved.
//

import UIKit
import MapKit

@objc protocol AGSMKMapViewDelegate {

    @objc @available(iOS 3.0, *)
    optional func mapView(_ mapView: AGSMKMapView, regionWillChangeAnimated animated: Bool)
    
    @objc @available(iOS 3.0, *)
    optional func mapView(_ mapView: AGSMKMapView, regionDidChangeAnimated animated: Bool)
    
    
    @objc @available(iOS 3.0, *)
    optional func mapViewWillStartLoadingMap(_ mapView: AGSMKMapView)
    
    @objc @available(iOS 3.0, *)
    optional func mapViewDidFinishLoadingMap(_ mapView: AGSMKMapView)
    
    @objc @available(iOS 3.0, *)
    optional func mapViewDidFailLoadingMap(_ mapView: AGSMKMapView, withError error: Error)
    
    
    @objc @available(iOS 7.0, *)
    optional func mapViewWillStartRenderingMap(_ mapView: AGSMKMapView)
    
    @objc @available(iOS 7.0, *)
    optional func mapViewDidFinishRenderingMap(_ mapView: AGSMKMapView, fullyRendered: Bool)
    
    
    // mapView:viewForAnnotation: provides the view for each annotation.
    // This method may be called for all or some of the added annotations.
    // For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
    @objc @available(iOS 3.0, *)
    optional func mapView(_ mapView: AGSMKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    
    
    // mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
    // The delegate can implement this method to animate the adding of the annotations views.
    // Use the current positions of the annotation views as the destinations of the animation.
    @objc @available(iOS 3.0, *)
    optional func mapView(_ mapView: AGSMKMapView, didAdd views: [MKAnnotationView])
    
    
    // mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
    @objc @available(iOS 3.0, *)
    optional func mapView(_ mapView: AGSMKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    
    
    @objc @available(iOS 4.0, *)
    optional func mapView(_ mapView: AGSMKMapView, didSelect view: MKAnnotationView)
    
    @objc @available(iOS 4.0, *)
    optional func mapView(_ mapView: AGSMKMapView, didDeselect view: MKAnnotationView)
    
    
    @objc @available(iOS 4.0, *)
    optional func mapViewWillStartLocatingUser(_ mapView: AGSMKMapView)
    
    @objc @available(iOS 4.0, *)
    optional func mapViewDidStopLocatingUser(_ mapView: AGSMKMapView)
    
    @objc @available(iOS 4.0, *)
    optional func mapView(_ mapView: AGSMKMapView, didUpdate userLocation: MKUserLocation)
    
    @objc @available(iOS 4.0, *)
    optional func mapView(_ mapView: AGSMKMapView, didFailToLocateUserWithError error: Error)
    
    
    @objc @available(iOS 4.0, *)
    optional func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState)
    
    
    @objc @available(iOS 5.0, *)
    optional func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool)
    
    
    @objc @available(iOS 7.0, *)
    optional func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    
    @objc @available(iOS 7.0, *)
    optional func mapView(_ mapView: MKMapView, didAdd renderers: [MKOverlayRenderer])
}

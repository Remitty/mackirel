//
//  MapCell.swift
//  Mackirel
//
//  Created by brian on 5/31/21.
//

import Foundation
import UIKit
import MapKit
//import GoogleMaps
import CoreLocation

class MapCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
//    let map = GMSMapView()
    let locationManager = CLLocationManager()
    var lati = 0.0
    var long = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: lati, longitudinalMeters: long)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
        break
        case .denied:
        // Show alert
        break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
        // Show alert
        break
        case .authorizedAlways:
        break
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
        // the user didn't turn it on
        }
    }
    
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: lati, longitudinalMeters: long)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

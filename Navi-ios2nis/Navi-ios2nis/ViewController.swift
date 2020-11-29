//
//  ViewController.swift
//  Navi-ios2nis
//  Created by HSE  FKN on 13.11.2020.
//
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var finishLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var coordinatesArray = [CLLocationCoordinate2D]()
    var annotationsArray = [MKAnnotation]()
    var overlaysArray = [MKOverlay]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func getYourRoute(_ sender: UIButton) {
        let completion1 = doAfterOne
        
        if self.mapView.annotations.count > 0 {
            self.mapView.removeAnnotations(self.annotationsArray)
            self.annotationsArray = []
        }
        
        if self.overlaysArray.count  > 0 {
            self.mapView.removeOverlays(self.overlaysArray)
            self.overlaysArray = []
        }
        self.coordinatesArray = []
        
        if (self.startLocation.text!.count == 0 || self.finishLocation.text!.count == 0 || self.startLocation.text! == self.finishLocation.text!) {
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.findLocation(location: self.startLocation.text!, showRegion: false, completion: completion1)
        }
    }
    
    
    func findLocation(location: String, showRegion: Bool = false, completion: @escaping () -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                let coordinates = placemark.location!.coordinate
                self.coordinatesArray.append(coordinates)
                let point = MKPointAnnotation()
                point.coordinate = coordinates
                point.title = location
                
                if let country = placemark.country {
                    point.subtitle = country
                }
                self.mapView.addAnnotation(point)
                self.annotationsArray.append(point)
                
                if showRegion {
                    self.mapView.centerCoordinate = coordinates
                    let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
                    let region = MKCoordinateRegion(center: coordinates, span: span)
                    self.mapView.setRegion(region, animated: false)
                }
            } else {
                print(String(describing: error))
            }
            completion()
        }
    }

    
    func findLocations() {
        if self.coordinatesArray.count < 2 {
            return
        }
        let markLocationOne = MKPlacemark(coordinate: self.coordinatesArray.first!)
        let markLocationTwo = MKPlacemark(coordinate: self.coordinatesArray.last!)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: markLocationOne)
        directionRequest.destination = MKMapItem(placemark: markLocationTwo)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                let myRoute: MKRoute? = response?.routes.last
                if let a = myRoute?.polyline {
                    if self.overlaysArray.count > 0 {
                        self.mapView.removeOverlays(self.overlaysArray)
                        self.overlaysArray = []
                    }
                    self.overlaysArray.append(a)
                    self.mapView.addOverlay(a)
                    self.mapView.centerCoordinate = self.coordinatesArray.last!
                    
                    let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
                    let region = MKCoordinateRegion(center: self.coordinatesArray.last!, span: span)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    
    func doAfterOne() {
        let completion2 = findLocations
        DispatchQueue.global(qos: .background).async {
            self.findLocation(location: self.finishLocation.text!, showRegion: true, completion: completion2)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 3
        }
        return polylineRenderer
    }
    
}


//
//  MapViewController.swift
//  MassagesApp
//
//  Created by raz cohen on 02/07/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addAnnotation()
    }

    //MARK: outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: funcrions
    
    func addAnnotation(){

        let buissnesAnnotation = MKPointAnnotation()
        buissnesAnnotation.title = "Spa4U"
        buissnesAnnotation.coordinate = CLLocationCoordinate2D(latitude: 32.078918, longitude: 34.767878)

        mapView.addAnnotation(buissnesAnnotation)
        zoomAnnotation(with: buissnesAnnotation.coordinate)

    }
    
    func zoomAnnotation(with coordinates:CLLocationCoordinate2D){
        
        let coordinateRegion = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

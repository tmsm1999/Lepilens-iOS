//
//  MapView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MapKit

///Map view containing the observation location.
struct MapView: UIViewRepresentable {
    
    private let CLLOcationDegrees = 0.10
    
    var observationCoordinates: CLLocation?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView.init(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let location = observationCoordinates {
            let span = MKCoordinateSpan(latitudeDelta: CLLOcationDegrees, longitudeDelta: CLLOcationDegrees)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            let annotation =  MKPointAnnotation()
            annotation.coordinate = location.coordinate
            
            uiView.setRegion(region, animated: true)
            uiView.addAnnotation(annotation)
        }
    }
}

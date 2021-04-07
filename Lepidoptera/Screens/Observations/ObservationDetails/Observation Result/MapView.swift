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
    
    private let CLLocationDegrees = 0.10
    
    let latitude: Double
    let longitude: Double
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView.init(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if latitude != -999, longitude != -999 {
            let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees, longitudeDelta: CLLocationDegrees)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            
            let annotation =  MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            uiView.setRegion(region, animated: true)
            uiView.addAnnotation(annotation)
        }
    }
}

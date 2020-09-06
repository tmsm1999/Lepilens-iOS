//
//  MapView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    private let CLLOcationDegrees = 0.10
    
    var observationCoordinates: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView.init(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: CLLOcationDegrees, longitudeDelta: CLLOcationDegrees)
        let region = MKCoordinateRegion(center: observationCoordinates, span: span)
        
        let annotation =  MKPointAnnotation()
        annotation.coordinate = observationCoordinates
        
        uiView.setRegion(region, animated: true)
        uiView.addAnnotation(annotation)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        
//        let observationRecords = ObservationRecords()
//        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
//
//        observationRecords.addObservation(observation)
        
        MapView(observationCoordinates: CLLocationCoordinate2D(latitude: -116.16686800, longitude: +34.01128600)
        )
    }
}

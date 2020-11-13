//
//  MyObservationsMap.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 11/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
class ObservationAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, species: String, image: UIImage, confidence: String) {
        self.coordinate = coordinate
        title = species
        subtitle = "Confidence: " + confidence
        self.image = image
    }
}
class ObservationAnnotationView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard
            let observationAnnotation = self.annotation as? ObservationAnnotation else {
            return
        }
        
        image = observationAnnotation.image
    }
}
struct MyObservationsMap: UIViewRepresentable {
    
    @Binding var observationList: [Observation]
    @Binding var observationsWithLocation: Int
    @Binding var query: String
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView.init(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let allAnnotations = uiView.annotations
        uiView.removeAnnotations(allAnnotations)

        var withLocation = 0
        
        for observation in observationList {
            
            guard let _ = observation.speciesName else {
                continue
            }
            
            if observation.latitude != -999 && observation.longitude != -999 {
                withLocation += 1
            }


            if query == "" || observation.speciesName!.lowercased().contains(query.lowercased()) {
            
                let annotation = ObservationAnnotation(
                    coordinate: CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude),
                    species: observation.speciesName!,
                    image: UIImage(data: observation.image!)!,
                    confidence: String(format: "%.1f", observation.confidence * 100).appending("%")
                )
                
                uiView.addAnnotation(annotation)
            }
        }
        
        observationsWithLocation = withLocation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "observation"
        let annotationView = ObservationAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        annotationView.canShowCallout = true
        
        print("Here")
        
        return annotationView
    }
}

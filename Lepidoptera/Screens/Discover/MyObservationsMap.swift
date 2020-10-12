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
    
    init(coordinate: CLLocationCoordinate2D, species: String, image: UIImage, confidence: Double) {
        self.coordinate = coordinate
        self.title = species
        self.subtitle = "Confidence: \(confidence)"
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
        
        let annotationImage = observationAnnotation.image?.resized(toWidth: 36)
        image = annotationImage
    }
}

///Map view containing the observation location.
struct MyObservationsMap: UIViewRepresentable {
    
    @Binding var observationList: [Observation]
    @Binding var observationsWithLocation: Int
    @Binding var query: String
    
    func makeUIView(context: UIViewRepresentableContext<MyObservationsMap>) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        uiView.delegate = context.coordinator
        
        let allAnnotations = uiView.annotations
        uiView.removeAnnotations(allAnnotations)
        
        var withLocation = 0
        
        for observation in observationList {
            
            if observation.latitude != -1 && observation.longitude != 1 {
                withLocation += 1
            }
            
            if query == "" || observation.speciesName!.lowercased().contains(query.lowercased()) {
                
                if let speciesName = observation.speciesName, let imageData = observation.image {
                    
                    let annotation = ObservationAnnotation(
                        coordinate: CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude),
                        species: speciesName,
                        image: UIImage(data: imageData)!,
                        confidence: observation.confidence
                    )
                    
                    uiView.addAnnotation(annotation)
                }
            }
        }
        
        observationsWithLocation = withLocation
    }
    
    func makeCoordinator() -> MyObservationsMap.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MyObservationsMap
        
        init(parent: MyObservationsMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let annotationView = ObservationAnnotationView(annotation: annotation, reuseIdentifier: "Observation")
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
}


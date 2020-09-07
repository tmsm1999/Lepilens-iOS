//
//  ClassificationDetails.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MapKit

struct ObservationDetails: View {
    
    @EnvironmentObject var records: ObservationRecords
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var dismissModalView: Bool //Mal acabo de classificar alguma view.
    
    var observation: Observation
    
    var body: some View {
        VStack(alignment: .center) {
            
            ZStack {
                MapView(observationCoordinates: CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude))
                .frame(height: 280)
                .edgesIgnoringSafeArea(.top)
                
                ObservationImage(image: observation.image)
                .offset(x: 0, y: 50)
            }
            
            GeometryReader { geometry in
                
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack {
                        
                        HStack() {
                            
                            VStack(alignment: .leading) {
                                Text(self.observation.speciesName)
                                    .font(.system(size: 40, weight: .semibold))
                                    
                                Text(self.observation.date)
                            }
                            
                            Spacer()

                            ConfidenceCircleResults(confidence: self.observation.classificationConfidence)
                                .padding(.trailing, 10)
                            
                        }
                            .frame(width: geometry.size.width)
                        
                        ObservationActionButtons(observation: self.observation, dismissModalView: self.$dismissModalView)
                            .offset(x: 0, y: 30)
                            .environmentObject(self.records)
                        
                    }
                }
                .padding(.top, 10)
            }
            .padding(.leading, 20)
            .padding(.bottom, 2)
            
            Spacer()
            
        }
    }
}

struct ClassificationDetails_Previews: PreviewProvider {
    static var previews: some View {
        
        let observationRecords = ObservationRecords()
        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
        
        observationRecords.addObservation(observation)
        
        return ObservationDetails(dismissModalView: .constant(true), observation: observationRecords.record[0]).environmentObject(observationRecords)
    }
}


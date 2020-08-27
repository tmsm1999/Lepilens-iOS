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
    var observation: Observation
    
    var body: some View {
        VStack(alignment: .center) {
            
            ZStack {
                MapView(observationCoordinates: CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude))
                .frame(height: 280)
                .edgesIgnoringSafeArea(.top)
                
                ObservationImage(imageName: observation.imageName)
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
                        
                        ObservationActionButtons(observation: self.observation)
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
        ObservationDetails(observation: mockRecord[0]).environmentObject(ObservationRecords())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}


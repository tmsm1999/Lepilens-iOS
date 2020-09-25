//
//  ClassificationDetails.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MapKit

///Model view that is used to present an observation.
///This show a circular image, map view with the location of the image.
///Also it includes buttons to show details, add to favorites and delete a view.
struct ObservationDetails: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    ///Informs the parent view if the model view is being shown or not.
    @Binding var dismissModalView: Bool
    ///Current observation being shown.
    var observation: Observation
    
    var body: some View {
        VStack(alignment: .center) {
            
            ZStack {
                MapView(observationCoordinates: observation.location)
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
                                
                                Text(self.observation.date.description)
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

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
    
    @EnvironmentObject var observationRecords: ObservationRecords
    @State var observation: Observation
    
    var classificationIndex: Int {
        observationRecords.record.firstIndex(where: {$0.id == observation.id})!
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            MapView(observationCoordinates: CLLocationCoordinate2D(latitude: observation.latitude, longitude: observation.longitude))
            .frame(height: 300)
            .edgesIgnoringSafeArea(.top)
            
            ObservationImage(imageName: "aglais_io")
            
            HStack() {
                VStack(alignment: .leading) {
                    Text("Aglais io")
                        .font(.system(size: 50, weight: .semibold))
                    Text("02/02/2020")
                }
                
                ConfidenceCircleResults(confidence: observation.classificationConfidence)
                    .padding(.leading, 45)
            }
                .padding(.trailing, 55)
                .offset(x: 0, y: -120)
            
            ObservationActionButtons(observation: self.$observation)
                .padding(.top, 30)
            
            Spacer()
        }
    }
}

struct ClassificationDetails_Previews: PreviewProvider {
    static var previews: some View {
        ObservationDetails(observation: mockRecord[0])
        //ObservationDetails()
    }
}


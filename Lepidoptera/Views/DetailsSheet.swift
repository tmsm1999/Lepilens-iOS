//
//  DetailsSheet.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct DetailsSheet: View {
    
    @Binding var isPresented: Bool
    var observation: Observation
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                DetailField(field: "Species Name: ", value: observation.speciesName)
                DetailField(field: "Confidence: ", value: String(observation.classificationConfidence * 100) + "%")
                DetailField(field: "Date: ", value: observation.date.description)
                DetailField(field: "Time: ", value: observation.time)
                DetailField(field: "Latitude: ", value: String(observation.location?.coordinate.latitude.description ?? "Location is unavailable"))
                DetailField(field: "Longitude: ", value: String(observation.location?.coordinate.longitude.description ?? "Location is unavailable"))
                //DetailField(field: "Place: ", value: "Porto")
                
                Image(uiImage: observation.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.top, 20)
                
                
                Spacer()
            }
            .padding(20)
            .padding(.top, 30)
                
            .navigationBarTitle(Text("Observation Details"))
            .navigationBarItems(trailing:
                
                Button(action: { self.isPresented.toggle() }) {
                    Text("Done")
                }
            )
        }
    }
}

//struct DetailsSheet_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        
//        let observationRecords = ObservationRecords()
//        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
//        
//        observationRecords.addObservation(observation)
//        
//        return DetailsSheet(isPresented: .constant(true), observation: observationRecords.record[0])
//    }
//}

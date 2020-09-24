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

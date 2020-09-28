//
//  DetailsSheet.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Modal View that shows all the information and details about an observation performed by the user.
struct DetailsSheet: View {
    
    ///Informs the parent view whether the sheet is open or not.
    @Binding var isPresented: Bool
    
    ///Current observation whose details are being shown.
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
                
                Image(uiImage: observation.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.top, 20)
                
                
                Spacer()
            }
            .padding(20)
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
            .navigationBarTitle(Text("Observation Details"))
            .navigationBarItems(trailing:
                                    
                Button(action: { self.isPresented.toggle() }) {
                    Text("Dismiss")
                }
            )
        }
    }
}

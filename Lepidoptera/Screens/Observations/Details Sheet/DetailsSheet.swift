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
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(alignment: .leading) {
                    //Add family
                    Group {
                        DetailField(field: "Genus: ", value: String(observation.speciesName!.split(separator: " ")[0]))
                        DetailField(field: "Species: ", value: observation.speciesName!)
                        DetailField(field: "Confidence: ", value: String(observation.confidence * 100) + "%")
                        DetailField(field: "Date: ", value: formatDate(date: observation.observationDate!))
                        DetailField(field: "Time: ", value: formatTime(date: observation.observationDate!))
                        DetailField(field: "Latitude: ", value: observation.latitude != -999 ? String(observation.latitude) : "Location is unavailable")
                        DetailField(field: "Longitude: ", value: observation.longitude != -999 ? String(observation.longitude) : "Location is unavailable")
                    }
                    
                    Group {
                        DetailField(field: "Image Creation Date: ", value: formatDate(date: observation.imageCreationDate!))
                        DetailField(field: "Image Height: ", value: String(observation.imageHeight) + " pixels")
                        DetailField(field: "Image Width: ", value: String(observation.imageWidth) + " pixels")
                        DetailField(field: "Image Source: ", value: observation.imageSource!)
                    }
                }
                .padding(.top, 25)
                
                VStack(alignment: .center) {
                    
                    Image(uiImage: UIImage(data: observation.image!)!)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding(20)
                }
                Spacer()
            }
            
            .navigationBarTitle(Text("Observation Details"))
            .navigationBarItems(trailing:
                                    
                Button(action: { self.isPresented.toggle() }) {
                    Text("Dismiss")
                }
            )
        }
    }
}

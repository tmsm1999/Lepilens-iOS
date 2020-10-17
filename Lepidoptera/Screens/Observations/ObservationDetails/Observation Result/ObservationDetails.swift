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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    ///Current observation being shown.
    var observation: Observation
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack {
                    
                    ZStack {
                        
                        MapView(latitude: observation.latitude, longitude: observation.longitude)
                            .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .edgesIgnoringSafeArea(.top)
                        
                        
                        ObservationImage(image: UIImage(data: observation.image!)!)
                            .frame(width: geometry.size.height / 4.3, height: geometry.size.height / 4.3, alignment: .center)
                            .offset(x: 0, y: geometry.size.height / 4.9)
                    }
                    
                    HStack() {
                        
                        VStack(alignment: .leading) {
                            Text(formatSpaciesName(name: observation.speciesName!))
                                .font(.system(size: geometry.size.height / 22, weight: .semibold))
                                .lineLimit(2)
                            
                            Text(formatDate(date: observation.observationDate!))
                                .font(.system(size: geometry.size.height / 51, weight: .medium))
                        }
                        .padding(.leading, 13)
                        
                        Spacer()
                        
                        ConfidenceCircleResults(confidence: observation.confidence)
                            .frame(width: geometry.size.width / 4.4, height: geometry.size.width / 4.4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.trailing, 13)
                        
                    }
                    .frame(width: geometry.size.width)
                    .padding(.top, geometry.size.height / 6)
                    
                    Spacer()
                    
                    ObservationActionButtons(observation: self.observation)
                        .offset(x: 0, y: 30)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                }
                .navigationBarTitle(Text(""))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func formatSpaciesName(name: String) -> String {
        
        let nameArray = name.split(separator: " ")
        if nameArray[0].count >= 10 {
            return nameArray[0] + "\n" + nameArray[1]
        }
        
        return name
    }
}

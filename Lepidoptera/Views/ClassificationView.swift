//
//  ClassificationView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassificationView: View {

    @EnvironmentObject var records: ObservationRecords
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 50) {
                    RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                        .environmentObject(self.records)
                    
                    
                    RectangleButton(buttonString: "Take a photo", imageTitle: "TakePhotoRect", action: "Camera")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                    
                    Spacer()
                }
                .padding(.top, 40)
                    
                .navigationBarTitle(Text("Classify"))
            }
        }
    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView()//.environmentObject(ObservationRecords())
    }
}


//        Button(action: {
//
//            //self.id += 1
//            print("Clicou!")
//            self.records.addObservation(
//                Observation(
//                    speciesName: "Aglais io",
//                    classificationConfidence: 0.70,
//                    latitude: -116.166868,
//                    longitude: 34.011286,
//                    id: 0,
//                    date: "02/02/199",
//                    isFavorite: false,
//                    imageName: "aglais_io",
//                    time: "17:00"))
//        }) {
//            Text("Classify")
//        }

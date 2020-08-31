//
//  ClassificationView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassificationView: View {
    
    //@ObservedObject var records = ObservationRecords()
    //@EnvironmentObject var records: ObservationRecords
    //@State var id: Int = 0
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        print("Classify - Image from Photos")
                    }) {
                        RectangleButton(buttonString: "Import from Photos", imageTitle: "photo")
                            //.background(Color.red)
                    }
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                    
                    Button(action: {
                        print("Classify - Take photo from camera")
                    }) {
                        RectangleButton(buttonString: "Take Photograph", imageTitle: "camera")
                            //.background(Color.red)
                    }
                    .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                    .padding(.top, 40)
                    Spacer()
                }
                .padding(.top, 40)
            }
                
            .navigationBarTitle(Text("Classify"))
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

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
        
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 50) {
                    RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                    
                    
                    RectangleButton(buttonString: "Take a photo", imageTitle: "TakePhotoRect", action: "Camera")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                    
                    Spacer()
                }
                .padding(.top, 40)
                    
                .navigationBarTitle(Text("Classify"))
            }
        }
        
        //        NavigationView {
        //
        //            VStack {
        //
        //                RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
        //
        //                RectangleButton(buttonString: "Take Photograph", imageTitle: "TakePhotoRect", action: "Camera")
        //                Spacer()
        //            }
        //            //.padding(.top, 40)
        //
        //            .navigationBarTitle(Text("Classify"))
        //        }
        //        .accentColor(Color.clear)
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

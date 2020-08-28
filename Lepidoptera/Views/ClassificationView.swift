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
    @EnvironmentObject var records: ObservationRecords
    //@State var id: Int = 0
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
            
                VStack() {
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.30)
                    
                    ZStack(alignment: .center) {
                        
//                        Image(systemName: "photo.on.rectangle")
                    
                        Rectangle()
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.30)
                            .cornerRadius(8)
                            //.padding(.top, 50)
                            .foregroundColor(Color.init(red: 0 / 255, green: 153 / 255, blue: 51 / 255))
                        //.offset(x: 0, y: 400)
                        
                        VStack {
                        
                            Image(systemName: "photo.on.rectangle")
                                .font(.system(size: 60))
                            
                            HStack {
                                Text("Import from Photos")
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                }
                    .padding(.top, 70)
            }
            
            .navigationBarTitle(Text("Classify"))
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
        
    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView().environmentObject(ObservationRecords())
    }
}

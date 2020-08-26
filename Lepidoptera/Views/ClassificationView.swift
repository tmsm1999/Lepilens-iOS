//
//  ClassificationView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassificationView: View {
    
    @ObservedObject var records = ObservationRecords()
    //@State var id: Int = 0
    
    var body: some View {
        Button(action: {
            
            //self.id += 1
            print("Clicou!")
            self.records.addObservation(
                Observation(
                    speciesName: "Aglais io",
                    classificationConfidence: 0.70,
                    latitude: -116.166868,
                    longitude: 34.011286,
                    id: 0,
                    imageName: "aglais_io"))
        }) {
            Text("Classify")
        }
        
    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView()
    }
}

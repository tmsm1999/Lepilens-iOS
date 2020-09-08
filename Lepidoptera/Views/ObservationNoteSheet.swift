//
//  ObservationNoteSheet.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ObservationNoteSheet: View {
    
    @Binding var isPresented: Bool
    @EnvironmentObject var records: ObservationRecords
    @State var userNote: String
    
    var observation: Observation
    var observationIndex: Int {
        records.record.firstIndex(where: { $0.id == observation.id})!
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                MultilineTextField(userNote: $userNote, observation: records.record[observationIndex])
                
                .navigationBarTitle(Text("Observation Note"))
                .navigationBarItems(trailing:
                    
                    Button(action: {
                        self.isPresented.toggle();
                        self.self.records.record[self.observationIndex].userNote = self.userNote
                        print(self.records.record[self.observationIndex].userNote)
                        
                    }) {
                        Text("Save")
                    }
                )
            }
            .padding(20)
        }
    }
}

//struct ObservationNoteSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let observationRecords = ObservationRecords()
//        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
//        
//        observationRecords.addObservation(observation)
//        
//        return ObservationNoteSheet(isPresented: .constant(true), userNote: "", observation: observationRecords.record[0])
//    }
//}

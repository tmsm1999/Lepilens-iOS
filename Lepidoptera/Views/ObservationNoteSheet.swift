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
                        self.records.record[self.observationIndex].userNote = self.userNote
                        print(self.records.record[self.observationIndex].userNote)
                        
                    }) {
                        Text("Save")
                        //print($observation.userNote)
                    }
                )
            }
            .padding(20)
        }
    }
}

struct ObservationNoteSheet_Previews: PreviewProvider {
    static var previews: some View {
        ObservationNoteSheet(isPresented: .constant(true), userNote: "", observation: mockRecord[0])
    }
}

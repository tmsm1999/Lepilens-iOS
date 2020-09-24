//
//  ObservationNoteSheet.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///View that allows the user to write a note about a specific observation.
///It gets the previous note and allows the user to edit that or create a new one.
struct ObservationNoteSheet: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    ///Informs the parent view if the sheet that allows to add a new observation is to be shown or not.
    @Binding var isPresented: Bool
    
    ///Local var that saves the current user note to be changed inside the action button.
    @State var userNote: String
    
    ///Current observation being shown.
    var observation: Observation
    
    ///Gets the current index of the observation in the list of observations.
    var observationIndex: Int {
        records.record.firstIndex(where: { $0.id == observation.id})!
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ///Text Editor when the user is going to right notes about the observation.
                ///- Parameters:
                /// - userNote: placeholder to save the note.
                /// - observation: observation the note is about.
                MultilineTextField(userNote: $userNote, observation: records.record[observationIndex])
                
                .navigationBarTitle(Text("Observation Note"))
                .navigationBarItems(trailing:
                    
                    Button(action: {
                        self.self.records.record[self.observationIndex].userNote = self.userNote
                        self.isPresented.toggle();
                        
                    }) {
                        Text("Save")
                    }
                )
            }
            .padding(20)
        }
    }
}

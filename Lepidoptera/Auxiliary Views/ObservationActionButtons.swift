//
//  ObservationActionButtons.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ObservationActionButtons: View {
    
    @State private var presentObservationDetailsSheet: Bool = false
    @State private var presentAddNoteSheet: Bool = false

    var observation: Observation
    @EnvironmentObject var records: ObservationRecords
    @Environment(\.presentationMode) var presentationMode
    
    var observationIndex: Int {
        records.record.firstIndex(where: { $0.id == observation.id}) ?? -1
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            VStack(alignment: .leading) {
                
                Divider()
                Button(action: { self.presentObservationDetailsSheet.toggle() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Observation Details")
                    }
                }
                .sheet(isPresented: $presentObservationDetailsSheet) {
                    DetailsSheet(isPresented: self.$presentObservationDetailsSheet, observation: self.observation)
                }
                
                Divider()
                Button(action: { self.presentAddNoteSheet.toggle() }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                        Text("Add Note")
                    }
                }
                .sheet(isPresented: $presentAddNoteSheet) {
                    ObservationNoteSheet(isPresented: self.$presentAddNoteSheet, userNote: "", observation: self.observation)
                        .environmentObject(self.records)
                }
                
                Divider()
            }
                //.offset(x: 0, y: -110)
                .padding(.bottom, 30)
            
            VStack(alignment: .leading) {
                
                Divider()
                Button(action: {
                    self.records.record[self.observationIndex].isFavorite = !self.records.record[self.observationIndex].isFavorite
                }) {
                    
                    if observationIndex >= 0 {
                        if records.record[observationIndex].isFavorite {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Remove from favorites")
                            }
                        }
                        else {
                            HStack {
                                Image(systemName: "star.circle")
                                    .foregroundColor(.yellow)
                                Text("Add to Favorites")
                            }
                        }
                    }
                }
                
                Divider()
                Button(action: {
                    if self.observationIndex != -1 {
                        self.presentationMode.wrappedValue.dismiss()
                        self.records.record.remove(at: self.observationIndex)
                    }
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                        Text("Remove Observation")
                    }
                }
                
                Divider()
            }
                .padding(.bottom, 30)
        }
    }
}

struct ObservationActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        ObservationActionButtons(observation: mockRecord[0]).environmentObject(ObservationRecords())
    }
}

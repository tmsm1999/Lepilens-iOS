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
    @Binding var observation: Observation
    
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
                    DetailsSheet(isPresented: self.$presentObservationDetailsSheet, observation: self.$observation)
                }
                
                Divider()
                Button(action: { self.presentAddNoteSheet.toggle() }) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                        Text("Add Note")
                    }
                }
                .sheet(isPresented: $presentAddNoteSheet) {
                    ObservationNoteSheet(isPresented: self.$presentAddNoteSheet, observation: self.$observation)
                }
                
                Divider()
            }
                .offset(x: 0, y: -110)
                .padding(.leading, 20)
            
            VStack(alignment: .leading) {
                
                Divider()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.yellow)
                        Text("Add to Favorites")
                    }
                }
                
                Divider()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                        Text("Remove Observation")
                    }
                }
                
                Divider()
            }
                .offset(x: 0, y: -110)
                .padding(.leading, 20)
                .padding(.top, 30)
        }
    }
}

struct ObservationActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        ObservationActionButtons(observation: .constant(mockRecord[0]))
    }
}

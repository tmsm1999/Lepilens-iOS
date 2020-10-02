//
//  ObservationActionButtons.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import UIKit

struct ObservationActionButtons: View {
    
    @EnvironmentObject var records: ObservationRecords
    @Environment(\.presentationMode) var presentationMode
    
    ///Works with child modal view to present the sheet with the details for that observation.
    @State private var presentObservationDetailsSheet: Bool = false
    ///Works with child modal view to present the sheet with the note for that observation.
    @State private var presentAddNoteSheet: Bool = false
    ///Controls the toggle of the alert for deleting observation.
    @State var showDeleteObservationAlert: Bool = false
    ///Controls when the share sheet is presented.
    @State var isPresentedShareSheet: Bool = false
    
    ///Works with parent to dismiss current view.
    @Binding var dismissModalView: Bool
    
    var observation: Observation
    
    var observationIndex: Int {
        records.record.firstIndex(where: { $0.id == observation.id}) ?? -1
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                
                Divider()
                
                Button(action: { self.presentObservationDetailsSheet.toggle() }) {
                    HStack {
                        Image(systemName: "plus.square.fill")
                        Text("Observation Details").bold()
                    }
                    .padding(.leading, 15)
                }
                .sheet(isPresented: $presentObservationDetailsSheet) {
                    DetailsSheet(isPresented: self.$presentObservationDetailsSheet, observation: self.observation)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .padding(.top, 4.3)
                
                Divider()
                
                Button(action: { self.presentAddNoteSheet.toggle() }) {
                    HStack() {
                        Image(systemName: "square.and.pencil")
                        Text("Add Note").bold()
                    }
                    .padding(.leading, 15)
                }
                .sheet(isPresented: $presentAddNoteSheet) {
                    ObservationNoteSheet(isPresented: self.$presentAddNoteSheet, userNote: "", observation: self.observation)
                        .environmentObject(self.records)
                }
                .padding(.top, 4.3)
                
                Divider()
                
                Button(action: { self.isPresentedShareSheet.toggle() }) {
                    HStack() {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Observation").bold()
                    }
                    .padding(.leading, 15)
                }
                .sheet(isPresented: $isPresentedShareSheet) {
                    ShareSheet(items: getItemShareSheet())
                }
                .padding(.top, 4.3)
                
                Divider()
            }
            .padding(.bottom, 30)
            
            VStack(alignment: .leading) {
                
                Divider()
                
                Button(action: {
                    self.records.record[self.observationIndex].isFavorite = !self.records.record[self.observationIndex].isFavorite
                }) {
                    
                    if observationIndex >= 0 {
                        if records.record[observationIndex].isFavorite {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("Remove from favorites").bold()
                            }
                            .padding(.leading, 15)
                        }
                        else {
                            HStack {
                                Image(systemName: "star")
                                    .foregroundColor(.yellow)
                                Text("Add to Favorites").bold()
                            }
                            .padding(.leading, 15)
                        }
                    }
                }
                .padding(.top, 4.3)
                
                Divider()
                
                Button(action: {
                    self.showDeleteObservationAlert.toggle()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                        Text("Remove Observation").bold()
                    }
                    .padding(.leading, 15)
                }
                .padding(.top, 4.3)
                
                Divider()
            }
            .padding(.bottom, 30)
        }
        .padding(.bottom, 90)
        .alert(isPresented: $showDeleteObservationAlert) {
            Alert(title: Text("Delete observation"), message: Text("Are you sure you want to delete this observation and associated data?"), primaryButton: .destructive(Text("Yes")) {
                
                if self.observationIndex != -1 {
                    self.presentationMode.wrappedValue.dismiss()
                    self.records.record.remove(at: self.observationIndex)
                    
                    if self.dismissModalView == true {
                        self.dismissModalView = false
                    }
                }
            }, secondaryButton: .cancel(Text("No")))
        }
        
    }
    
    func getItemShareSheet() -> [Any] {
        
        let species = observation.speciesName
        let image = observation.image.pngData()
        let date = observation.date
        
        var finalText: String = ""
        
        if let location = observation.location {
            
            let latitude = String(format: "%.1f", Double(location.coordinate.latitude))
            let longitude = String(format: "%.1f", Double(location.coordinate.longitude))
            
            finalText = "New observation - \(date)\nSpecies: \(species)\nLatitude: \(latitude)\nLongitude: \(longitude)"
        }
        else {
            finalText = "New observation - \(date)\nSpecies: \(species)\n"
        }
        
        let items: [Any] = [image!, finalText]
        return items
    }

}

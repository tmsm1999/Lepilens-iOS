//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos

struct NewClassificationController: View {
    
    @EnvironmentObject var records: ObservationRecords
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool //Sheet atual
    
    @State var observation: Observation?
    @State var pickerIsVisible = true
    @State var dismissModalView: Bool = false
    
    var importImageFromPhotos: Bool
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                if self.observation == nil {
                    SheetImagePicker(sheetIsPresented: self.$isPresented, observation: self.$observation, imageWillBeImportedFromPhotos: self.importImageFromPhotos)
                }
                else {
                    ObservationDetails(dismissModalView: self.$isPresented, observation: observation!).environmentObject(self.records)
                        .transition(.slide)
                        .animation(.linear(duration: 1))
                }
            }
            
            .navigationBarItems(trailing:
                                    Button(action: { self.isPresented.toggle() }) {
                                        Text("Dismiss")
                                    }
            )
        }
    }
}

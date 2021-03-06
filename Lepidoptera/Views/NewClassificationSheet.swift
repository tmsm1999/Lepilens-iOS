//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos

///Background view responsible for controlling what should appear based on the user input.
///If the user chooses to classify and the classification was sucessful the observation variable will be
///initialized. When this happens the picker disappears and the ObservationDetails View appears.
struct NewClassificationController: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    ///Variable that saves the observation to be shown in the ObservationDetailsView.
    ///The fact of it being null or not also controls the View that appears.
    @State var observation: Observation?

    ///Controlls if the current sheet is up or down.
    @Binding var isPresented: Bool
    
    ///Variable that controlls what appears in the sheet that opens the picker.
    ///If "Import from Photos" is selected then the Picker will open the Photos app.
    ///Otherwise the picker will open the Camera app.
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

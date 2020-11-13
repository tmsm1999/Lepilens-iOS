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
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    ///Controls what view should appear - Sheet or result.
    @State var classificationWasSuccessful = false
    ///Current observation.
    @State var observation = Observation()
    ///Controls if current sheet is visible or not.
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .center) {
                
                if classificationWasSuccessful == false {
                    SheetImagePicker(
                        classificationWasSuccessful: self.$classificationWasSuccessful,
                        observation: self.$observation,
                        sheetIsPresented: self.$isPresented
                    )
                    .environment(\.managedObjectContext, self.managedObjectContext)
                }
                else {
                    ObservationDetails(
                        observation: self.observation
                    )
                    .transition(.slide)
                    .animation(.linear(duration: 1.5))
                    .environment(\.managedObjectContext, self.managedObjectContext)
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

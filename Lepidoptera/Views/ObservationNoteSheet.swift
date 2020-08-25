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
    @Binding var observation: Observation
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Text("Hello, World!")
                
                .navigationBarTitle(Text("Observation Note"))
                .navigationBarItems(trailing:
                    
                    Button(action: {self.isPresented.toggle() }) {
                        Text("Save")
                    }
                )
            }
        }
    }
}

struct ObservationNoteSheet_Previews: PreviewProvider {
    static var previews: some View {
        ObservationNoteSheet(isPresented: .constant(true), observation: .constant(mockRecord[0]))
    }
}

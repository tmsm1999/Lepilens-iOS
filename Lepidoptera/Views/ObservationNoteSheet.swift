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
            
        }
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ObservationNoteSheet_Previews: PreviewProvider {
    static var previews: some View {
        ObservationNoteSheet(isPresented: .constant(true), observation: .constant(mockRecord[0]))
    }
}

//
//  DetailsSheet.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct DetailsSheet: View {
    
    @Binding var isPresented: Bool
    var observation: Observation
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                DetailField(field: "Species Name: ", value: observation.speciesName)
                DetailField(field: "Confidence: ", value: "70%")
                DetailField(field: "Date: ", value: "02/02/2020")
                DetailField(field: "Time: ", value: "17:30")
                DetailField(field: "Latitude: ", value: "-12.38482925")
                DetailField(field: "Longitude: ", value: "9.29251192")
                DetailField(field: "Place: ", value: "Porto")
                
                Image("aglais_io")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.top, 20)

                
                Spacer()
            }
                .padding(20)
                .padding(.top, 30)
            
                .navigationBarTitle(Text("Observation Details"))
                .navigationBarItems(trailing:
                
                Button(action: { self.isPresented.toggle() }) {
                    Text("Done")
                }
            )
        }
    }
}

struct DetailsSheet_Previews: PreviewProvider {
    
    static var previews: some View {
        
        DetailsSheet(isPresented: .constant(true), observation: mockRecord[0])
    }
}

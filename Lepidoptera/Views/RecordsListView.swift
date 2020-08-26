//
//  RecordsListView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct RecordsListView: View {
    
    @ObservedObject var records = ObservationRecords()
    
    var body: some View {
        
        NavigationView {
            List(records.record) { record in
                NavigationLink(destination: ObservationDetails(observation: record)) {
                    
                    Image(record.imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text("Aqui")
                    }
                }
            }
            
            .navigationBarTitle(Text("Observations"))
        }
    }
}

struct RecordsListView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsListView()
    }
}

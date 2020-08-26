//
//  RecordsListView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct RecordsListView: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    var body: some View {
        
        NavigationView {
            List(records.record) { record in
                NavigationLink(destination: ObservationDetails(observation: record)) {
                    
                    Image(record.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipped()
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text(record.speciesName)
                            .font(.system(size: 20))
                            .bold()
                        Text("02/02/2020")
                            .font(.system(size: 15))
                    }
                    .padding(.leading, 10)
                }
                .environmentObject(self.records)
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

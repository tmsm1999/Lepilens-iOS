//
//  ClassificationDetails.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ObservationDetails: View {
    
    @EnvironmentObject var classificationRecords: ObservationRecords
    var classification: Observation
    
    var classificationIndex: Int {
        classificationRecords.record.firstIndex(where: <#T##(Observation) throws -> Bool#>)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ClassificationDetails_Previews: PreviewProvider {
    static var previews: some View {
        ObservationDetails()
    }
}

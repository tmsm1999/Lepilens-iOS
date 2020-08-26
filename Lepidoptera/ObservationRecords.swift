//
//  ObservationRecords.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation

class ObservationRecords: ObservableObject {
    
    @Published var record = mockRecord
    
    init() {
        print(record)
    }
    
    func addObservation(_ newObservation: Observation) {
        print("Added observation")
        //record.append(newObservation)
    }
}

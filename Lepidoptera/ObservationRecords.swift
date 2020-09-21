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

///Manages and stores de application data.
class ObservationRecords: ObservableObject, Identifiable {
    
    ///Array that saves all observations performed by the user.
    ///The @Published object property allow the record arrray to announce when a change occurs.
    @Published var record = [Observation]()
    
    //TODO: Check if init method needs to be here.
    init() {
    }
    
    ///Function that adds a new observation to the record array. Modifies the record array.
    /// - Parameters:
    ///     - newObservation: Observation performed by the user
    func addObservation(_ newObservation: Observation) {
        //TODO: Check if underscore can be removed.
        record.append(newObservation)
    }
}

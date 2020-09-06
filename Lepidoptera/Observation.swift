//
//  Observation.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Observation: Identifiable, Hashable, Codable {
    
    var speciesName: String
    var classificationConfidence: Double
    var latitude: Double
    var longitude: Double
    var id: Int
    var date: String
    var isFavorite: Bool
    var userNote: String = ""
    //var imageName: String?
    var image: UIImage
    var time: String
}

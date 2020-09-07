//
//  Observation.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Observation: Identifiable, Equatable {

    let speciesName: String
    let classificationConfidence: Double
    let latitude: Double
    let longitude: Double
    let id = UUID()
    let date: String
    var isFavorite: Bool
    var userNote: String = ""
    //var imageName: String?
    let image: UIImage
    let time: String
}



//  Observation.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.


//import SwiftUI
//import CoreLocation
//
//struct Observation: Identifiable, Hashable, Codable {
//
//    let speciesName: String
//    let classificationConfidence: Double
//    let latitude: Double
//    let longitude: Double
//    let id: Int
//    let date: String
//    let isFavorite: Bool
//    let userNote: String = ""
//    var imageName: String
//    let image: UIImage
//    let time: String
//}

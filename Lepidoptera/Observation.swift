//
//  Observation.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import CoreLocation

///Struct that represents an observation peformed by the user.
///- Parameters:
///     - speciesName: String representing the species detected in the observation.
///     - classificationConfidence: Double that stores the confidence of the observation. Rounded to a decimal place.
///     - image: UIImage object that stores the images associated with a given observation.
///     - location: Optional CLLocation object that stors the user location for the observation.
///     - date: Date object that stores the date of the observation.
///     - isFavorite: Boolean that indicates whether the user marked an observation as favorite or not.
///     - userNote: String representing a note made by the user regarding the observation.
///     - id: UUID makes observation each observation unique so that it can be identified.
///     - time: String that represents the time of the observation.
struct Observation: Identifiable, Equatable {

    let speciesName: String
    let classificationConfidence: Double
    
    let image: UIImage
    let imageHeight: Int
    let imageWidth: Int
    let imageSource: String
    
    let location: CLLocation?
    let date: String //TODO: Check what is wrong with the date because it represents one less hour.
    var isFavorite: Bool
    var userNote: String = ""
    let id = UUID()
    let time: String //TODO: Check if this is necessary.
}

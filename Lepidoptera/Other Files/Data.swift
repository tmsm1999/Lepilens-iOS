//
//  Data.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import UIKit

var familyDictionary: [String: String] = [:]
var iNatLinkDictionary: [String: String] = [:]
var wikipediaLinkDictionary: [String: String] = [:]
var secundaryNameDictionary: [String: String] = [:]


struct Species: Codable {
    
    let name: String
    let family: String
    let iNatLink: String
    let WikipediaLink: String
    let otherName: String
}

func loadSpeciesInfoJSON() {
    
    if let filePath = Bundle.main.url(forResource: "speciesInfo", withExtension: "json") {
        
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            let speciesList = try decoder.decode([Species].self, from: data)
            
            for species in speciesList {
                familyDictionary[species.name] = species.family
                iNatLinkDictionary[species.name] = species.iNatLink
                wikipediaLinkDictionary[species.name] = species.WikipediaLink
                secundaryNameDictionary[species.name] = species.otherName
            }
            
            print(familyDictionary.count)
            //familyDictionary.sorted(by: {$0.key > $1.key})
            
        } catch {
            print("Can not load JSON file.")
        }
    }
}

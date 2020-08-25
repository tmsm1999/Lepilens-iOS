//
//  Data.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import UIKit

let mockRecord: [Observation] = loadData("mockData")

func loadData(_ filename: String) -> [Observation] {
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: "json") else {
        fatalError("Can not load file")
    }
    
    let decoder = JSONDecoder()
    var decodedData = [Observation]()
    
    do {
        decodedData = try decoder.decode([Observation].self, from: Data(contentsOf: file))
    }
    catch {
        fatalError("Can not decode json")
    }
    
    print(decodedData)
    
    return decodedData
}

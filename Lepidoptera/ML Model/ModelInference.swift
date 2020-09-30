//
//  ModelInference.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 20/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import UIKit
import MLKit
import Vision

/**
A struct that represents a label in an observaation.
 - Parameters:
     - label: Stores the label String. For example: "Vanessa Atalanta".
     - confidence: Stores a Double with the confidence for the label in the context of an observation.
*/
struct PairLabelConfidence {
    var label: String
    var confidence: Double
}

class ModelInference {
    
    ///Variable that stores the top five labels in terms of confidence for an observation.
    var topFive = [PairLabelConfidence]()
    
    func runInference(image: UIImage) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        guard let modelPath = Bundle.main.path(forResource: "model", ofType: "tflite") else {
            return
        }
        
        var labels: [String] = []
        
        guard let labelsPath = Bundle.main.url(forResource: "dict", withExtension: "txt") else {
            return
        }
        
        do {
            let fileContent = try String(contentsOf: labelsPath, encoding: .utf8)
            labels = fileContent.components(separatedBy: .newlines)
        }
        catch {
            return
        }
        
        let localModel = LocalModel(path: modelPath)
        
        let options = CustomImageLabelerOptions(localModel: localModel)
        options.maxResultCount = 5
        let imageLabeler = ImageLabeler.imageLabeler(options: options)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        imageLabeler.process(visionImage) { result, error in
            
            guard error == nil, let inferenceResult = result, !inferenceResult.isEmpty else {
                print(error?.localizedDescription ?? "Error!")
                return
            }
            
            for res in inferenceResult {
                let index = res.index
                let confidence = Double(res.confidence)
                
                let newPair = PairLabelConfidence(label: labels[index], confidence: confidence)
                self.topFive.append(newPair)
            }
            print("Aqui 3")
            semaphore.signal()
        }
        print("Aqui 4")
        semaphore.wait()
        print("Aqui 5")
    }
    
    func getResults() -> [PairLabelConfidence]? {
        if !topFive.isEmpty {
            return topFive
        }
        
        return nil
    }
    
    func detectButterfly(receivedImage: UIImage) -> Bool {
        
        guard let cgImage = receivedImage.cgImage else {
            return false
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNClassifyImageRequest()
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return false
        }
        
        var categoriesDictionary: [String : Float] = [:]
        for category in results {
            categoriesDictionary[category.identifier] = category.confidence
        }
        
        if let butterflyConfidence = categoriesDictionary["butterfly"] {
            print(butterflyConfidence)
            if butterflyConfidence > 0.8 {
                return true
            }
        }
        
        return false
    }
}

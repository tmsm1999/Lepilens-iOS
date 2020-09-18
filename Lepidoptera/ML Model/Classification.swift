//
//  Classification.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 15/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import SwiftUI
import Vision
import CoreML
import ImageIO

class Classification {
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            
            let classificationModel = try VNCoreMLModel(for: NewGenusModel().model)
            
            let request = VNCoreMLRequest(model: classificationModel, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            
            request.imageCropAndScaleOption = .scaleFit
            return request
        }
        catch {
            fatalError("Error! Can't use Model.")
        }
    }()
    
    func classifyImage(receivedImage: UIImage) {
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(receivedImage.imageOrientation.rawValue))
        
        if let image = CIImage(image: receivedImage) {
            DispatchQueue.global(qos: .userInitiated).async {
                
                let handler = VNImageRequestHandler(ciImage: image, orientation: orientation!)
                do {
                    try handler.perform([self.classificationRequest])
                }
                catch {
                    fatalError("Error classifying image!")
                }
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard var results = request.results else {
                print("Unable to classify image!")
                return
            }
            
            print(results.sort())
            return
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                print("Unable to classify image!")
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                print(descriptions.joined(separator: "\n"))
            }
        }
    }
}

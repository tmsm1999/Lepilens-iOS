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
    
//    var results: [PairLabelConfidence]?
//
//    init() {}
//
//    private lazy var classificationRequest: VNCoreMLRequest = {
//        do {
//
//            let classificationModel = try VNCoreMLModel(for: new_especies_model().model)
//
//            let request = VNCoreMLRequest(model: classificationModel, completionHandler: { [weak self] request, error in
//                self?.processClassifications(for: request, error: error)
//            })
//
//            request.imageCropAndScaleOption = .scaleFit
//            return request
//        }
//        catch {
//            fatalError("Error! Can't use Model.")
//        }
//    }()

    func detectButterfly(receivedImage: UIImage) {
        
        guard let cgImage = receivedImage.cgImage else {
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNClassifyImageRequest()
        
        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        var categoriesDictionary: [String : Float] = [:]
        for category in results {
            categoriesDictionary[category.identifier] = category.confidence
        }
        
        
        
        print(results)
    }

//        let orientation = CGImagePropertyOrientation(rawValue: UInt32(receivedImage.imageOrientation.rawValue))
//
//        if let image = CIImage(image: receivedImage) {
//            //DispatchQueue.global(qos: .userInitiated).async {
//
//                let handler = VNImageRequestHandler(ciImage: image, orientation: orientation!)
//                do {
//                    try handler.perform([self.classificationRequest])
//                }
//                catch {
//                    fatalError("Error classifying image!")
//                }
//            //}
//        }
//
//        if let results = self.results {
//            return results
//        }
//
//        return nil
//    }

//    func processClassifications(for request: VNRequest, error: Error?) {
//        //DispatchQueue.main.async {
//            guard let results = request.results as? [VNClassificationObservation] else {
//                print("Unable to classify image!")
//                return
//            }
//
//            //print(results)
//
//             //The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
//            let classifications = results
//            //let topClassifications = classifications.prefix(5)
//            var classificationResultsPerLabel = [PairLabelConfidence]()
//
//            if classifications.isEmpty {
//                print("Unable to classify image!")
//            } else {
//
//                for classification in classifications {
//                    let label = String(format: "%@", classification.identifier)
//                    let confidence = classification.confidence
//                    let newPair = PairLabelConfidence(label: label, confidence: Double(confidence))
//                    classificationResultsPerLabel.append(newPair)
//                }
//
//                classificationResultsPerLabel.sort(by: {$0.confidence > $1.confidence})
//                self.results = classificationResultsPerLabel
//            }
//        }
//    //}
}





































//// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
////
//// Licensed under the Apache License, Version 2.0 (the "License");
//// you may not use this file except in compliance with the License.
//// You may obtain a copy of the License at
////
////    http://www.apache.org/licenses/LICENSE-2.0
////
//// Unless required by applicable law or agreed to in writing, software
//// distributed under the License is distributed on an "AS IS" BASIS,
//// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//// See the License for the specific language governing permissions and
//// limitations under the License.
//
//import CoreImage
//import TensorFlowLite
//import UIKit
//import Accelerate
//
///// A result from invoking the `Interpreter`.
//struct Result {
//    let inferenceTime: Double
//    let inferences: [Inference]
//}
//
///// An inference from invoking the `Interpreter`.
//struct Inference {
//    let confidence: Float
//    let label: String
//}
//
///// Information about a model file or labels file.
//typealias FileInfo = (name: String, extension: String)
//
///// Information about the MobileNet model.
//enum MobileNet {
//    static let modelInfo: FileInfo = (name: "mobilenet_quant_v1_224", extension: "tflite")
//    static let labelsInfo: FileInfo = (name: "labels", extension: "txt")
//}
//
///// This class handles all data preprocessing and makes calls to run inference on a given frame
///// by invoking the `Interpreter`. It then formats the inferences obtained and returns the top N
///// results for a successful inference.
//class ModelDataHandler {
//
//    // MARK: - Internal Properties
//    /// The current thread count used by the TensorFlow Lite Interpreter.
//    let threadCount: Int
//
//    let resultCount = 5
//    let threadCountLimit = 10
//
//    // MARK: - Model Parameters
//    let batchSize = 1
//    let inputChannels = 3
//    var inputWidth = 224
//    var inputHeight = 224
//
//    // MARK: - Private Properties
//    /// List of labels from the given labels file.
//    private var labels: [String] = []
//
//    /// TensorFlow Lite `Interpreter` object for performing inference on a given model.
//    private var interpreter: Interpreter
//
//    /// Information about the alpha component in RGBA data.
//    private let alphaComponent = (baseOffset: 4, moduloRemainder: 3)
//
//    // MARK: - Initialization
//    /// A failable initializer for `ModelDataHandler`. A new instance is created if the model and
//    /// labels files are successfully loaded from the app's main bundle. Default `threadCount` is 1.
//    init?(modelFileInfo: FileInfo, labelsFileInfo: FileInfo, threadCount: Int = 1) {
//        let modelFilename = modelFileInfo.name
//
//        // Construct the path to the model file.
//        guard let modelPath = Bundle.main.path(
//            forResource: modelFilename,
//            ofType: modelFileInfo.extension
//            ) else {
//                print("Failed to load the model file with name: \(modelFilename).")
//                return nil
//        }
//
//        // Specify the options for the `Interpreter`.
//        self.threadCount = threadCount
//        var options = Interpreter.Options()
//        options.threadCount = threadCount
//        do {
//            // Create the `Interpreter`.
//            interpreter = try Interpreter(modelPath: modelPath, options: options)
//            // Allocate memory for the model's input `Tensor`s.
//            try interpreter.allocateTensors()
//
//        } catch let error {
//            print("Failed to create the interpreter with error: \(error.localizedDescription)")
//            return nil
//        }
//        // Load the classes listed in the labels file.
//        loadLabels(fileInfo: labelsFileInfo)
//    }
//
//    // MARK: - Internal Methods
//    /// Performs image preprocessing, invokes the `Interpreter`, and processes the inference results.
//    func runModel(onFrame image: UIImage) -> Result? {
//
////        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
////        assert(sourcePixelFormat == kCVPixelFormatType_32ARGB ||
////            sourcePixelFormat == kCVPixelFormatType_32BGRA ||
////            sourcePixelFormat == kCVPixelFormatType_32RGBA)
//
//
//        let imageChannels = 4
//        assert(imageChannels >= inputChannels)
//
//        // Crops the image to the biggest square in the center and scales it down to model dimensions.
//        let scaledSize = CGSize(width: inputWidth, height: inputHeight)
////        guard let thumbnailPixelBuffer = pixelBuffer.centerThumbnail(ofSize: scaledSize) else {
////            return nil
////        }
//        
//        let newImage = image.scaledImage(with: scaledSize)
//        let imageData = newImage!.pngData() ?? newImage!.jpegData(compressionQuality: 0.8)
//
//        let interval: TimeInterval
//        let outputTensor: Tensor
//        do {
//            //let inputTensor = try interpreter.input(at: 0)
//
//             //Remove the alpha component from the image buffer to get the RGB data.
////            guard let rgbData = rgbDataFromBuffer(
////                thumbnailPixelBuffer,
////                byteCount: batchSize * inputWidth * inputHeight * inputChannels,
////                isModelQuantized: inputTensor.dataType == .uInt8
////                ) else {
////                    print("Failed to convert the image buffer to RGB data.")
////                    return nil
////            }
//
//            // Copy the RGB data to the input `Tensor`.
//            try interpreter.allocateTensors()
//            try interpreter.copy(imageData!, toInputAt: 0)
//
//            // Run inference by invoking the `Interpreter`.
//            let startDate = Date()
//            try interpreter.invoke()
//            interval = Date().timeIntervalSince(startDate) * 1000
//
//            // Get the output `Tensor` to process the inference results.
//            outputTensor = try interpreter.output(at: 0)
//        } catch let error {
//            print("Failed to invoke the interpreter with error: \(error.localizedDescription)")
//            return nil
//        }
//
//        let results: [Float]
//        switch outputTensor.dataType {
//        case .uInt8:
//            guard let quantization = outputTensor.quantizationParameters else {
//                print("No results returned because the quantization values for the output tensor are nil.")
//                return nil
//            }
//
//            let quantizedResults = [UInt8](outputTensor.data)
//            //results = quantizedResults
//            results = quantizedResults.map {
//                quantization.scale * Float(Int($0) - quantization.zeroPoint)
//            }
//        case .float32:
//            results = [Float32](unsafeData: outputTensor.data) ?? []
//        default:
//            print("Output tensor data type \(outputTensor.dataType) is unsupported for this example app.")
//            return nil
//        }
//
//        // Process the results.
//        let topNInferences = getTopN(results: results)
//
//        // Return the inference time and inference results.
//        return Result(inferenceTime: interval, inferences: topNInferences)
//    }
//
//    // MARK: - Private Methods
//    /// Returns the top N inference results sorted in descending order.
//    private func getTopN(results: [Float]) -> [Inference] {
//        // Create a zipped array of tuples [(labelIndex: Int, confidence: Float)].
//        let zippedResults = zip(labels.indices, results)
//
//        // Sort the zipped results by confidence value in descending order.
//        let sortedResults = zippedResults.sorted { $0.1 > $1.1 }.prefix(resultCount)
//
//        // Return the `Inference` results.
//        return sortedResults.map { result in Inference(confidence: result.1, label: labels[result.0]) }
//    }
//
//    /// Loads the labels from the labels file and stores them in the `labels` property.
//    private func loadLabels(fileInfo: FileInfo) {
//        let filename = fileInfo.name
//        let fileExtension = fileInfo.extension
//        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
//            fatalError("Labels file not found in bundle. Please add a labels file with name " +
//                "\(filename).\(fileExtension) and try again.")
//        }
//        do {
//            let contents = try String(contentsOf: fileURL, encoding: .utf8)
//            labels = contents.components(separatedBy: .newlines)
//        } catch {
//            fatalError("Labels file named \(filename).\(fileExtension) cannot be read. Please add a " +
//                "valid labels file and try again.")
//        }
//
//        //print("Total: \(labels.count)")
//        //print(labels.dropLast())
//    }
//
//    /// Returns the RGB data representation of the given image buffer with the specified `byteCount`.
//    ///
//    /// - Parameters
//    ///   - buffer: The pixel buffer to convert to RGB data.
//    ///   - byteCount: The expected byte count for the RGB data calculated using the values that the
//    ///       model was trained on: `batchSize * imageWidth * imageHeight * componentsCount`.
//    ///   - isModelQuantized: Whether the model is quantized (i.e. fixed point values rather than
//    ///       floating point values).
//    /// - Returns: The RGB data representation of the image buffer or `nil` if the buffer could not be
//    ///     converted.
//    private func rgbDataFromBuffer(
//        _ buffer: CVPixelBuffer,
//        byteCount: Int,
//        isModelQuantized: Bool
//    ) -> Data? {
//        CVPixelBufferLockBaseAddress(buffer, .readOnly)
//        defer {
//            CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
//        }
//        guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
//            return nil
//        }
//
//        let width = CVPixelBufferGetWidth(buffer)
//        let height = CVPixelBufferGetHeight(buffer)
//        let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
//        let destinationChannelCount = 3
//        let destinationBytesPerRow = destinationChannelCount * width
//
//        var sourceBuffer = vImage_Buffer(data: sourceData,
//                                         height: vImagePixelCount(height),
//                                         width: vImagePixelCount(width),
//                                         rowBytes: sourceBytesPerRow)
//
//        guard let destinationData = malloc(height * destinationBytesPerRow) else {
//            print("Error: out of memory")
//            return nil
//        }
//
//        defer {
//            free(destinationData)
//        }
//
//        var destinationBuffer = vImage_Buffer(data: destinationData,
//                                              height: vImagePixelCount(height),
//                                              width: vImagePixelCount(width),
//                                              rowBytes: destinationBytesPerRow)
//
//        let pixelBufferFormat = CVPixelBufferGetPixelFormatType(buffer)
//
//        switch (pixelBufferFormat) {
//        case kCVPixelFormatType_32BGRA:
//            vImageConvert_BGRA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
//        case kCVPixelFormatType_32ARGB:
//            vImageConvert_ARGB8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
//        case kCVPixelFormatType_32RGBA:
//            vImageConvert_RGBA8888toRGB888(&sourceBuffer, &destinationBuffer, UInt32(kvImageNoFlags))
//        default:
//            // Unknown pixel format.
//            return nil
//        }
//
//        let byteData = Data(bytes: destinationBuffer.data, count: destinationBuffer.rowBytes * height)
//        if isModelQuantized {
//            return byteData
//        }
//
//        // Not quantized, convert to floats
//        let bytes = Array<UInt8>(unsafeData: byteData)!
//        var floats = [Float]()
//        for i in 0..<bytes.count {
//            floats.append((Float(bytes[i]) - 127.5) / 127.5)
//        }
//        return Data(copyingBufferOf: floats)
//    }
//}
//
//// MARK: - Extensions
//extension Data {
//    /// Creates a new buffer by copying the buffer pointer of the given array.
//    ///
//    /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
//    ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
//    ///     data from the resulting buffer has undefined behavior.
//    /// - Parameter array: An array with elements of type `T`.
//    init<T>(copyingBufferOf array: [T]) {
//        self = array.withUnsafeBufferPointer(Data.init)
//    }
//}
//
//extension Array {
//    /// Creates a new array from the bytes of the given unsafe data.
//    ///
//    /// - Warning: The array's `Element` type must be trivial in that it can be copied bit for bit
//    ///     with no indirection or reference-counting operations; otherwise, copying the raw bytes in
//    ///     the `unsafeData`'s buffer to a new array returns an unsafe copy.
//    /// - Note: Returns `nil` if `unsafeData.count` is not a multiple of
//    ///     `MemoryLayout<Element>.stride`.
//    /// - Parameter unsafeData: The data containing the bytes to turn into an array.
//    init?(unsafeData: Data) {
//        guard unsafeData.count % MemoryLayout<Element>.stride == 0 else { return nil }
//        #if swift(>=5.0)
//        self = unsafeData.withUnsafeBytes { .init($0.bindMemory(to: Element.self)) }
//        #else
//        self = unsafeData.withUnsafeBytes {
//            .init(UnsafeBufferPointer<Element>(
//                start: $0,
//                count: unsafeData.count / MemoryLayout<Element>.stride
//            ))
//        }
//        #endif  // swift(>=5.0)
//    }
//}
//
//extension CVPixelBuffer {
//
//    /**
//     Returns thumbnail by cropping pixel buffer to biggest square and scaling the cropped image to
//     model dimensions.
//     */
//    func centerThumbnail(ofSize size: CGSize ) -> CVPixelBuffer? {
//
//        let imageWidth = CVPixelBufferGetWidth(self)
//        let imageHeight = CVPixelBufferGetHeight(self)
//        let pixelBufferType = CVPixelBufferGetPixelFormatType(self)
//
//        //assert(pixelBufferType == kCVPixelFormatType_32BGRA)
//
//        let inputImageRowBytes = CVPixelBufferGetBytesPerRow(self)
//        let imageChannels = 3
//
//        let thumbnailSize = min(imageWidth, imageHeight)
//        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
//
//        var originX = 0
//        var originY = 0
//
//        if imageWidth > imageHeight {
//            originX = (imageWidth - imageHeight) / 2
//        }
//        else {
//            originY = (imageHeight - imageWidth) / 2
//        }
//
//        // Finds the biggest square in the pixel buffer and advances rows based on it.
//        guard let inputBaseAddress = CVPixelBufferGetBaseAddress(self)?.advanced(
//            by: originY * inputImageRowBytes + originX * imageChannels) else {
//                return nil
//        }
//
//        // Gets vImage Buffer from input image
//        var inputVImageBuffer = vImage_Buffer(
//            data: inputBaseAddress, height: UInt(thumbnailSize), width: UInt(thumbnailSize),
//            rowBytes: inputImageRowBytes)
//
//        let thumbnailRowBytes = Int(size.width) * imageChannels
//        guard  let thumbnailBytes = malloc(Int(size.height) * thumbnailRowBytes) else {
//            return nil
//        }
//
//        // Allocates a vImage buffer for thumbnail image.
//        var thumbnailVImageBuffer = vImage_Buffer(data: thumbnailBytes, height: UInt(size.height), width: UInt(size.width), rowBytes: thumbnailRowBytes)
//
//        // Performs the scale operation on input image buffer and stores it in thumbnail image buffer.
//        let scaleError = vImageScale_ARGB8888(&inputVImageBuffer, &thumbnailVImageBuffer, nil, vImage_Flags(0))
//
//        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
//
//        guard scaleError == kvImageNoError else {
//            return nil
//        }
//
//        let releaseCallBack: CVPixelBufferReleaseBytesCallback = {mutablePointer, pointer in
//
//            if let pointer = pointer {
//                free(UnsafeMutableRawPointer(mutating: pointer))
//            }
//        }
//
//        var thumbnailPixelBuffer: CVPixelBuffer?
//
//        // Converts the thumbnail vImage buffer to CVPixelBuffer
//        let conversionStatus = CVPixelBufferCreateWithBytes(
//            nil, Int(size.width), Int(size.height), pixelBufferType, thumbnailBytes,
//            thumbnailRowBytes, releaseCallBack, nil, nil, &thumbnailPixelBuffer)
//
//        guard conversionStatus == kCVReturnSuccess else {
//
//            free(thumbnailBytes)
//            return nil
//        }
//
//        return thumbnailPixelBuffer
//    }
//
////    static func buffer(from image: UIImage) -> CVPixelBuffer? {
////        let attrs = [
////            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
////            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
////            ] as CFDictionary
////
////        var pixelBuffer: CVPixelBuffer?
////        let status = CVPixelBufferCreate(kCFAllocatorDefault,
////                                         Int(image.size.width),
////                                         Int(image.size.height),
////                                         kCVPixelFormatType_32ARGB,
////                                         attrs,
////                                         &pixelBuffer)
////
////        guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
////            return nil
////        }
////
////        CVPixelBufferLockBaseAddress(buffer, [])
////        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
////        let pixelData = CVPixelBufferGetBaseAddress(buffer)
////
////        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
////        guard let context = CGContext(data: pixelData,
////                                      width: Int(image.size.width),
////                                      height: Int(image.size.height),
////                                      bitsPerComponent: 8,
////                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
////                                      space: rgbColorSpace,
////                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
////                                        return nil
////        }
////
////        context.translateBy(x: 0, y: image.size.height)
////        context.scaleBy(x: 1.0, y: -1.0)
////
////        UIGraphicsPushContext(context)
////        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
////        UIGraphicsPopContext()
////
////        return pixelBuffer
////    }
//    
////    static func buffer(from image: UIImage) -> Data? {
////        let image: CGImage = image.cgImage!
////        guard let context = CGContext(
////          data: nil,
////          width: image.width, height: image.height,
////          bitsPerComponent: 8, bytesPerRow: image.width * 4,
////          space: CGColorSpaceCreateDeviceRGB(),
////          bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
////        ) else {
////          return nil
////        }
////
////        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
////        guard let imageData = context.data else { return nil }
////
////        var inputData = Data()
////        for row in 0 ... 224 {
////            for col in 0 ... 224 {
////            let offset = 4 * (row * context.width + col)
////            // (Ignore offset 0, the unused alpha channel)
////            let red = imageData.load(fromByteOffset: offset+1, as: UInt8.self)
////            let green = imageData.load(fromByteOffset: offset+2, as: UInt8.self)
////            let blue = imageData.load(fromByteOffset: offset+3, as: UInt8.self)
////
////            // Normalize channel values to [0.0, 1.0]. This requirement varies
////            // by model. For example, some models might require values to be
////            // normalized to the range [-1.0, 1.0] instead, and others might
////            // require fixed-point values or the original bytes.
////            var normalizedRed = Float32(red) / 255.0
////            var normalizedGreen = Float32(green) / 255.0
////            var normalizedBlue = Float32(blue) / 255.0
////
////            // Append normalized values to Data object in RGB order.
////            let elementSize = MemoryLayout.size(ofValue: normalizedRed)
////            var bytes = [UInt8](repeating: 0, count: elementSize)
////            //memcpy(&amp,bytes, &amp,normalizedRed, elementSize)
////            inputData.append(normalizedRed, bytes, count: elementSize)
////            //memcpy(&amp,bytes, &amp,normalizedGreen, elementSize)
////            inputData.append(normalizedGreen, bytes, count: elementSize)
////            //memcpy(&ammp,bytes, &amp,normalizedBlue, elementSize)
////            inputData.append(normalizedBlue, bytes, count: elementSize)
////          }
////        }
////    }
//
//}
//
//extension UIImage {
//
//  /// Creates and returns a new image scaled to the given size. The image preserves its original PNG
//  /// or JPEG bitmap info.
//  ///
//  /// - Parameter size: The size to scale the image to.
//  /// - Returns: The scaled image or `nil` if image could not be resized.
//  public func scaledImage(with size: CGSize) -> UIImage? {
//    UIGraphicsBeginImageContextWithOptions(size, false, scale)
//    defer { UIGraphicsEndImageContext() }
//    draw(in: CGRect(origin: .zero, size: size))
//    return UIGraphicsGetImageFromCurrentImageContext()?.data.flatMap(UIImage.init)
//  }
//
//  // MARK: - Private
//  /// The PNG or JPEG data representation of the image or `nil` if the conversion failed.
//  private var data: Data? {
//    #if swift(>=4.2)
//      return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
//    #else
//      return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
//    #endif  // swift(>=4.2)
//  }
//}
//
//// MARK: - Constants
//private enum Constant {
//  static let jpegCompressionQuality: CGFloat = 0.8
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

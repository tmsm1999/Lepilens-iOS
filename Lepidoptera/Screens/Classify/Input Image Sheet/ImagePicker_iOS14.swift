//
//  ImagePicker.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 26/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import UIKit
import PhotosUI

@available(iOS 14, *)
struct ImagePicker_iOS14: UIViewControllerRepresentable {
    
    @Binding var imageToImport: UIImage
    @Binding var isPresented: Bool
    @Binding var imageWasImported: Bool
    @Binding var presentAlert: Bool
    @Binding var activeAlert: ActiveAlert?
    
    ///Opptional value that contains the date in which the photo wa taken.
    @Binding var date: Date?
    ///Optional value that depending on the user settings sends to the parent view the location of the observation.
    @Binding var location: CLLocation?
    ///Height in pixels of the image imported by the user.
    @Binding var imageHeight: Int
    ///Width in pixels of the image imported by the user.
    @Binding var imageWidth: Int
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker_iOS14>) -> some UIViewController {
        
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: ImagePicker_iOS14.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker_iOS14>) {}
    
    func makeCoordinator() -> ImagePicker_iOS14.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker_iOS14
        
        init(parent: ImagePicker_iOS14) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            if results.count != 1 {
                return
            }
            
            if let image = results.first {
                
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
                       
                        guard error == nil else {
                            print(error!)
                            return
                        }
                        
                        if let image = image {
                            
                            let identifiers = results.compactMap(\.assetIdentifier)
                            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                            
                            if fetchResult.count > 0 {
                                let imageMetadata = fetchResult[0]
                                
                                if let date = imageMetadata.creationDate {
                                    self.parent.date = date
                                }
                                else {
                                    self.parent.date = Date()
                                }
                                
                                if let location = imageMetadata.location, UserDefaults.standard.bool(forKey: "include_location") {
                                    self.parent.location = location
                                }
                                
                                self.parent.imageHeight = imageMetadata.pixelHeight
                                self.parent.imageWidth = imageMetadata.pixelWidth
                                
                                print("Image impoted.")
                                self.parent.imageToImport = image as! UIImage
                                self.parent.imageWasImported.toggle()
                            }
                            else {
                                self.parent.activeAlert = .canNotImportPhoto
                                self.parent.presentAlert.toggle()
                            }
                        }
                    }
                }
            }
            
            self.parent.isPresented.toggle()
        }
    }
}

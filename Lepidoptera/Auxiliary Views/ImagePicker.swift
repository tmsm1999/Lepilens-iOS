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
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var imageToImport: UIImage
    @Binding var isPresented: Bool
    @Binding var imageWasImported: Bool
    @Binding var presentAlert: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
        
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
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
                                print(imageMetadata.creationDate!)

                                print("Image impoted.")
                                self.parent.imageToImport = image as! UIImage
                                self.parent.imageWasImported.toggle()
                            }
                            else {
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

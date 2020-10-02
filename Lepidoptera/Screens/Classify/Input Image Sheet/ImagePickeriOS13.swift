//
//  ImagePickerView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos

///UIView that allows the user to pick an image from the Photos app.
struct ImagePickeriOS13: UIViewControllerRepresentable {
    
    ///Communicates to the parent view whether the picker is open or not.
    @Binding var isPresented: Bool
    ///Communicates to the parent the image chosen by the user to be classified.
    @Binding var selectedImage: UIImage
    ///Communicates to the parent view whether the image was imported with success.
    @Binding var imageWasImported: Bool
    ///Opptional value that contains the date in which the photo wa taken.
    @Binding var date: Date?
    ///Optional value that depending on the user settings sends to the parent view the location of the observation.
    @Binding var location: CLLocation?
    ///Height in pixels of the image imported by the user.
    @Binding var imageHeight: Int
    ///Width in pixels of the image imported by the user.
    @Binding var imageWidth: Int
    
    ///variable that stores the source of the image - Photos app or Camera app.
    var sourceType: String
    
    ///This function configures the picker depending on the source type.
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickeriOS13>) -> UIViewController {
        
        let controller = UIImagePickerController()
        
        if sourceType == "Photos" {
            //let library = PHPhotoLibrary.shared()
            controller.sourceType = .photoLibrary
        }
        else {
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.cameraDevice = .rear
            //controller.cameraCaptureMode = .photo
        }
        
        controller.delegate = context.coordinator
        return controller
    }
    
    ///The coordinator is responsible to communicate to the SwiftUI elements whether something as changed.
    func makeCoordinator() -> ImagePickeriOS13.Coordinator {
        return Coordinator(parent: self, sourceType: sourceType)
    }
    
    func updateUIViewController(_ uiViewController: ImagePickeriOS13.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickeriOS13>) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePickeriOS13
        var sourceType: String
        
        init(parent: ImagePickeriOS13, sourceType: String) {
            self.sourceType = sourceType; self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if sourceType == "Photos" {
                if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                    
                    guard let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else {
                        return
                    }
                    
                    if let date = asset.creationDate {
                        parent.date = date
                    }
                    else {
                        parent.date = Date()
                    }
                    
                    if let location = asset.location, UserDefaults.standard.bool(forKey: "include_location") {
                        parent.location = location
                    }
                    
                    parent.imageHeight = asset.pixelHeight
                    parent.imageWidth = asset.pixelWidth
                    
                    parent.selectedImage = selectedImageFromPicker
                    parent.imageWasImported = true
                }
            }
            else {
                let image = info[.originalImage]
                
                if let selectedImageFromPicker = image as? UIImage {
                    
                    if UserDefaults.standard.bool(forKey: "include_location") {
                        parent.location = UserLocation().getUserLocation()
                    }
                    
                    parent.date = Date()
                    
                    let heightInPixels = selectedImageFromPicker.size.height * selectedImageFromPicker.scale
                    parent.imageHeight = Int(heightInPixels)
                    
                    let widthInPixels = selectedImageFromPicker.size.width * selectedImageFromPicker.scale
                    parent.imageWidth = Int(widthInPixels)
                    
                    parent.selectedImage = selectedImageFromPicker
                    parent.imageWasImported = true
                }
            }
            
            parent.isPresented = false
        }
    }
}

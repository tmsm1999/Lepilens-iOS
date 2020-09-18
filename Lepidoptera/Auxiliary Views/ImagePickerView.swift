//
//  ImagePickerView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var imageWasImported: Bool
    @Binding var date: Date?
    @Binding var location: CLLocation?
    
    var sourceType: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> some UIViewController {
        
        let controller = UIImagePickerController()
        
        if sourceType == "Photos" {
            controller.sourceType = .photoLibrary
        }
        else {
            controller.sourceType = .camera
            controller.allowsEditing = true
            controller.cameraDevice = .rear
        }
        
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self, sourceType: sourceType)
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        let sourceType: String
        
        init(parent: ImagePickerView, sourceType: String) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined {
                PHPhotoLibrary.requestAuthorization { status in }
            }
            
            self.sourceType = sourceType
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if sourceType == "Photos" {
                if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                    
                    let asset = info[UIImagePickerController.InfoKey.phAsset] as! PHAsset
                    
                    if let date = asset.creationDate {
                        self.parent.date = date
                    }
                    else {
                        self.parent.date = Date()
                    }
                    
                    if let location = asset.location {
                        self.parent.location = location
                    }
                    
                    self.parent.selectedImage = selectedImageFromPicker
                    self.parent.imageWasImported = true
                }
            }
            else {
                if let selectedImageFromPicker = info[.editedImage] as? UIImage {
                    self.parent.selectedImage = selectedImageFromPicker
                    self.parent.imageWasImported = true
                    
                    self.parent.date = Date()
                    self.parent.location = UserLocation().getUserLocation()
                    print(self.parent.location ?? "No location")
                }
             }
            
            self.parent.isPresented = false
         }
    }
}

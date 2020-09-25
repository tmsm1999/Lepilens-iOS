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
struct ImagePickerView: UIViewControllerRepresentable {
    
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
    
    ///variable that stores the source of the image - Photos app or Camera app.
    var sourceType: String
    
    ///This function configures the picker depending on the source type.
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
    
    ///The coordinator is responsible to communicate to the SwiftUI elements whether something as changed.
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self, sourceType: sourceType)
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        let sourceType: String
        
        private var userPermission: PHAuthorizationStatus
        
        init(parent: ImagePickerView, sourceType: String) {
            
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .notDetermined || status == .denied {
                //Requests user authorization to use the Photos app.
                PHPhotoLibrary.requestAuthorization { status in
                    self.userPermission = status
                }
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

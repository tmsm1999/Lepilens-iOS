//
//  ImagePicker.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 26/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import PhotosUI

@available(iOS 14, *)
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var imageToImport: UIImage
    @Binding var isPresented: Bool
    @Binding var imageWasImported: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
        
        var configuration = PHPickerConfiguration()
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
                
                print("Aqui")
                
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
                        
                        if let image = image {
                            print("Importou imagem")
                            self.parent.imageToImport = image as! UIImage
                            self.parent.imageWasImported.toggle()
                        }
                    }
                }
            }
            
            self.parent.isPresented.toggle()
        }
    }
}

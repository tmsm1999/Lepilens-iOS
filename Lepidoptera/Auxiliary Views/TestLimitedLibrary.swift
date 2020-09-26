//
//  TestLimitedLibrary.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 26/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import SwiftUI
import PhotosUI


@available(iOS 14, *)
struct TestLimitedLibraryPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()

        DispatchQueue.main.async {
            PHPhotoLibrary.requestAuthorization() { result in
                PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller)
                context.coordinator.trackCompletion(in: controller)
            }
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
    class Coordinator: NSObject {
        private var isPresented: Binding<Bool>
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }

        func trackCompletion(in controller: UIViewController) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self, weak controller] in
                if controller?.presentedViewController == nil {
                    self?.isPresented.wrappedValue = false
                } else if let controller = controller {
                    self?.trackCompletion(in: controller)
                }
            }
        }
    }
}

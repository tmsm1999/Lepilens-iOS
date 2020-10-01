//
//  SendEmailSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 01/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import Foundation
import SwiftUI
import MessageUI

struct SendEmailSheet: UIViewControllerRepresentable {
    
    @Binding var emailError: Bool
    
    let emailSubject: String = "Hello Developer! 🦋"
    
    func makeCoordinator() -> SendEmailSheet.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SendEmailSheet>) -> MFMailComposeViewController {
        
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setToRecipients(["tomas.sant.mamede@icloud.com"])
        controller.setSubject(emailSubject)
        controller.setMessageBody("", isHTML: false)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<SendEmailSheet>) {

    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        var parent: SendEmailSheet
        
        init(parent: SendEmailSheet) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            
            controller.dismiss(animated: true)
            
            guard error == nil else {
                self.parent.emailError.toggle()
                return
            }
        }
    }
}

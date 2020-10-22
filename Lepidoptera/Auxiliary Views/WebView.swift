//
//  WebView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 13/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import SafariServices

struct WebView: UIViewControllerRepresentable {
    
    var webLink: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        
        let controller = SFSafariViewController(url: webLink)
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.edgesForExtendedLayout = .all
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        uiViewController.dismissButtonStyle = .close
    }
}

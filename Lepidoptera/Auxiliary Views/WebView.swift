//
//  WebView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 13/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var webLink: String
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        
        let webView = WKWebView()
        let pageURL = URL(string: webLink)
        webView.load(URLRequest(url: pageURL!))
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {}
}

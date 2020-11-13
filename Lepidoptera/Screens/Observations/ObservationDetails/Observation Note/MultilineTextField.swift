//
//  MultilineTextField.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Text field that allows the user to take notes about an observation.
///For example, here the user can specify if a butterfly is male or female.
struct MultilineTextField: UIViewRepresentable {
    
    ///Binding variable that passes the user note to the parent view.
    @Binding var userNote: String
    
    ///Stores the current observation about which the user is taking notes.
    var observation: Observation
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        
        if(observation.userNote == "") {
            textView.text = "Start here..."
            textView.textColor = .gray
        }
        else {
            userNote = observation.userNote!
            textView.text = observation.userNote
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {}
    
    func makeCoordinator() -> Coordinator {
        return MultilineTextField.Coordinator(parent: self, observation: observation)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultilineTextField
        var observation: Observation
        
        init(parent: MultilineTextField, observation: Observation) {
            self.parent = parent
            self.observation = observation
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.userNote = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            textView.text = self.parent.userNote
            textView.textColor = .label
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            self.parent.userNote = textView.text
        }
    }
}

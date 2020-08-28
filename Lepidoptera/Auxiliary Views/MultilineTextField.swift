//
//  MultilineTextField.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct MultilineTextField: UIViewRepresentable {
    
    @Binding var userNote: String
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
            textView.text = observation.userNote
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {
    }
    
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
            self.parent.userNote = observation.userNote
            
            textView.text = self.parent.userNote
            textView.textColor = .label
        }
    }
 }

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextField(userNote: .constant(""), observation: mockRecord[0])
    }
}
//
//  MultilineTextField.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct MultilineTextField: UIViewRepresentable {
    
    var noteText: String
    
    func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> UITextView {
        
        let textView = UITextView()
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.text = "Start here..."
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 16)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return MultilineTextField.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultilineTextField
        
        init(parent: MultilineTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.noteText = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            textView.text = ""
            textView.textColor = .label
        }
    }
 }

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextField(noteText: "")
    }
}

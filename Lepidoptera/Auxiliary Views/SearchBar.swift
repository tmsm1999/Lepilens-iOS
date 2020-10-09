//
//  SearchBar.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 09/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    
    @Binding var searchText: String
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Species Name"
        searchBar.showsCancelButton = true
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = searchText
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent: SearchBar
        
        init(parent: SearchBar) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchBar.showsCancelButton = true
            self.parent.searchText = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.parent.searchText = ""
            searchBar.resignFirstResponder()
            //searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
    }
}

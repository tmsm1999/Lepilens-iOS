//
//  ContentView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    var body: some View {
        
        TabView {
            //Aqui coloco a minha view em vez de Text
            ClassificationView(records: ObservationRecords())
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Classify")
                }
            Text("Records View")
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Records")
                }
            Text("Settings View")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}

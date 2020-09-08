//
//  ContentView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    private let location = UserLocation()
    
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor(red: 153 / 255, green: 255 / 255, blue: 153 / 255, alpha: 1)
//    }
    
    var body: some View {
        
        TabView {
            
            //Aqui coloco a minha view em vez de Text
            ClassificationView().environmentObject(self.records)
                .tabItem {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 22))
                    Text("Classify")
                }
            RecordsListView().environmentObject(self.records)
                .tabItem {
                    Image(systemName: "book.fill")
                        .font(.system(size: 22))
                    Text("Observations")
                }
            Text("Settings View")
                .tabItem {
                    Image(systemName: "gear")
                        .font(.system(size: 22))
                    Text("Settings")
                }
        }
        .font(.headline)
        //.animation(.easeInOut)
        //.transition()
//        .accentColor(Color.init(red: 0 / 255, green: 153 / 255, blue: 51 / 255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView().environmentObject(ObservationRecords())
    }
}

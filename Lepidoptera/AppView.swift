//
//  ContentView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///View that contains the tab bar and manages the main screens in the application.
///The first screen that appears in the TabView is the default screen in the application.
struct AppView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    ///Prompts user to allow or deny acess to the location when the application is launched.
    private let location = UserLocation()
    
    var body: some View {
        
        TabView {
            ClassificationView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "camera.fill")
                        .font(.system(size: tabBarItemFontSize))
                    Text("Classify")
                }
            RecordsListView().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "book.fill")
                        .font(.system(size: tabBarItemFontSize))
                    Text("Observations")
                }
            Discover().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "safari.fill")
                        .font(.system(size: tabBarItemFontSize))
                    Text("Discover")
                }
            Settings().environment(\.managedObjectContext, self.managedObjectContext)
                .tabItem {
                    Image(systemName: "gear")
                        .font(.system(size: tabBarItemFontSize))
                    Text("Settings")
                }
        }
        .font(.headline)
        .onAppear() {
            loadSpeciesInfoJSON()
        }
    }
}

private let tabBarItemFontSize: CGFloat = 22

//
//  Discover.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 11/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import CoreData

struct Discover: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var searchText: String = ""
    @State var searchType: Int = 0 //0 = My Observations | 1 = Find Species
    @State var occurencesFound = 0
    @State var occurrencesWithLocation = 0
    
    @State var observationList = [Observation]()
    
    var body: some View {
        
        GeometryReader { geometry in
                
            NavigationView {
                
                VStack {
                    
                    SearchBar(searchText: self.$searchText)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.top, 80)
                    
                    Picker(selection: self.$searchType, label: Text("Mode")) {
                        Text("My Observations").tag(0)
                        Text("Find Species").tag(1)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    HStack {
                        Text("Occurrences found: \(self.occurencesFound)")
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    
                    Spacer()
                    
                    if self.searchType == 0 {
                        MyObservationsMap(observationList: $observationList, observationsWithLocation: $occurrencesWithLocation, query: $searchText)
                            .frame(width: geometry.size.width, height: geometry.size.height / 1.42, alignment: .center)
                    }
                    else {
                        MapView(latitude: -15.369974, longitude: 28.315628999999998)
                            .frame(width: geometry.size.width, height: geometry.size.height / 1.42, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            //.edgesIgnoringSafeArea(.top)
                    }
                }
                .navigationBarTitle(Text("Discover"))
            }
            .onAppear() {
                observationList = fetchRequest(query: searchText)
            }
        }
    }
    
    func fetchRequest(query: String) -> [Observation] {
        
        let request = NSFetchRequest<Observation>(entityName: "Observation")
        request.sortDescriptors = [NSSortDescriptor(key: "observationDate", ascending: false)]
        
        let observations = (try? managedObjectContext.fetch(request)) ?? []
        if !observations.isEmpty {
            self.occurencesFound = observations.count
            return observations
        }
        self.occurencesFound = 0
        return observations
    }
}

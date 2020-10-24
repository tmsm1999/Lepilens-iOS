//
//  Discover.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 11/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

//
//  Discover.swift
//  Lepilens
//
//  Created by Tomás Mamede on 23/10/2020.
//

import SwiftUI

import SwiftUI
import CoreData

struct Discover: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var searchText: String = ""
    @State var searchType: Int = 0 //0 = My Observations | 1 = Find Species
    @State var occurencesFound = 0
    @State var occurrencesWithLocation = 0
    @State var safaryModalIsVisible: Bool = false
    @State var iNaturalistLink: String = ""
    
    @State var observationList = [Observation]()
    
    var body: some View {
        
        
        GeometryReader { geometry in
            
            NavigationView {
                
                VStack {
                    
                    Picker(selection: $searchType, label: Text("Mode")) {
                        Text("My Observations").tag(0)
                        Text("Find Species").tag(1)
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, 15)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                    
                    
                    if searchType == 0 {
                        
                        HStack {
                            Text("Occurrences with location: \(occurencesFound)")
                            Spacer()
                        }
                        .padding(15)
                        
                        SearchBar(searchText: $searchText)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                        
                        Spacer()
                        
                        MyObservationsMap(observationList: $observationList, observationsWithLocation: $occurencesFound, query: $searchText)
                            .frame(width: geometry.size.width, height: geometry.size.height / 1.50, alignment: .center)
                            .position(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.height / 1.50))
                    }
                    else {
                        Section {
                            List {
                                ForEach(iNatLinkDictionary.sorted(by: <), id: \.key) { key, value in
                                        
                                    Button(action: {
                                        iNaturalistLink = iNatLinkDictionary[key]!
                                        safaryModalIsVisible.toggle()
                                    }) {
                                        
                                        HStack {
                                            
                                            Image(key)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60, alignment: .center)
                                                .clipped()
                                                .cornerRadius(8)
                                            
                                            VStack(alignment: .leading) {
                                                Text(key)
                                                    .font(.system(size: 20))
                                                    .bold()
                                                Text(secundaryNameDictionary[key]!)
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.leading, 10)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "arrow.up.forward.app.fill")
                                                .padding(.trailing, 5)
                                            
                                        }
                                    }
                                    .sheet(isPresented: $safaryModalIsVisible) {
                                        WebView(webLink: URL(string: iNatLinkDictionary[key]!)!)
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .listStyle(PlainListStyle())
                        }
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
            occurencesFound = observations.count
            return observations
        }
        occurencesFound = 0
        return observations
    }
}


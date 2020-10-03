//
//  RecordsListView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///This view lists the observations made by the user.
///It includes photos imported from the Photos app and photos taken directly with the camera.
struct RecordsListView: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    ///Controls which obsrvations are showed in the list based on being a favorite or not.
    @State var showFavoritesOnly = false
    
    @State var reloadView = true
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                Section {
                    Toggle(isOn: self.$showFavoritesOnly) {
                        Text("Show Favorites only")
                    }
                }
                
                Section {
                    
                    ForEach(self.records.record) { record in
                        
                        if !self.showFavoritesOnly || record.isFavorite {
                            NavigationLink(destination: ObservationDetails(dismissModalView: $reloadView, observation: record)) {
                                
                                HStack {
                                    
                                    Image(uiImage: record.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(record.speciesName)
                                            .font(.system(size: 20))
                                            .bold()
                                        Text(record.date.description)
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    if(record.isFavorite) {
                                        Image(systemName: "star.fill")
                                            .imageScale(.medium)
                                            .foregroundColor(.yellow)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                            .environmentObject(self.records)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .navigationBarTitle(Text("Observations"))
            .navigationBarItems(trailing: EditButton())
            .listStyle(GroupedListStyle())
        }
        .onAppear() {
            self.reloadView.toggle()
        }
    }
    
    ///Funtion that removes an observation from the list of observations.
    func delete(at offset: IndexSet) {
        records.record.remove(atOffsets: offset)
        print(records.record.count)
    }
    
    ///Allows the user to organize the order in which the observations appear in the list.
    func move(from source: IndexSet, to destination: Int) {
        records.record.move(fromOffsets: source, toOffset: destination)
    }
    
    ///Adds an observation to the favorites.
    func favoriteAction(at offset: IndexSet) {
        offset.forEach { i in
            records.record[i].isFavorite = !records.record[i].isFavorite
        }
    }
}

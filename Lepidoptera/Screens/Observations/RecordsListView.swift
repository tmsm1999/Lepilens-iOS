//
//  RecordsListView.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 25/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import CoreData

///This view lists the observations made by the user.
///It includes photos imported from the Photos app and photos taken directly with the camera.
struct RecordsListView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Observation.entity(), sortDescriptors: [NSSortDescriptor(key: "observationDate", ascending: false)]) var observationList: FetchedResults<Observation>
    
    ///Controls which obsrvations are showed in the list based on being a favorite or not.ti
    @State var showFavoritesOnly = false
    ///Text that comes from the search bar.
    @State var searchText: String = ""
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                Section {
                    SearchBar(searchText: self.$searchText)
                    
                    Toggle(isOn: self.$showFavoritesOnly) {
                        Text("Show Favorites only")
                    }
                }
                
                Section {
                    
                    ForEach(self.observationList, id: \.self) { observation in
                        
                        if (self.searchText.isEmpty || observation.speciesName!.lowercased().contains(self.searchText.lowercased())) && (!self.showFavoritesOnly || observation.isFavorite) {
                            NavigationLink(destination: ObservationDetails(observation: observation)) {
                                
                                HStack {
                                    
                                    Image(uiImage: UIImage(data: observation.image!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(observation.speciesName!)
                                            .font(.system(size: 20))
                                            .bold()
                                        Text(observation.observationDate != nil ? formatDate(date: observation.observationDate!) : "Date not found")
                                            .font(.system(size: 15))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.leading, 10)
                                    
                                    Spacer()
                                    
                                    if(observation.isFavorite) {
                                        Image(systemName: "star.fill")
                                            .imageScale(.medium)
                                            .foregroundColor(.yellow)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                            .environment(\.managedObjectContext, managedObjectContext)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationBarTitle(Text("Observations"))
            .navigationBarItems(trailing: EditButton())
            .listStyle(GroupedListStyle())
        }
    }
    
    ///Funtion that removes an observation from the list of observations.
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let observationToRemove = observationList[index]
            managedObjectContext.delete(observationToRemove)
        }
        
        try? managedObjectContext.save()
    }
    
    ///Adds an observation to the favorites.
    func favoriteAction(at offsets: IndexSet) {
        offsets.forEach { i in
            observationList[i].isFavorite = !observationList[i].isFavorite
        }
        
        try? managedObjectContext.save()
    }
}

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
    ///Controls the appearence of the sheet in the list view.
    @State var sheetIsOpen: Bool = false
    
    var body: some View {
        VStack {
        
            NavigationView {
                
                ZStack {
                    
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
                                    
                                    NavigationLink(destination: ObservationDetails(sheetIsOpen: Binding.constant(false), observation: observation).environment(\.managedObjectContext, self.managedObjectContext)
                                                    .onAppear {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }) {
                                        
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
                                    //.environment(\.managedObjectContext, managedObjectContext)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .sheet(isPresented: self.$sheetIsOpen, content: {
                        SheetImagePicker(sheetIsPresented: $sheetIsOpen)
                            .environment(\.managedObjectContext, self.managedObjectContext)
                    })
                    
                    Spacer()
                    if observationList.count < 1 {
                        HStack(alignment: .center) {
                            VStack(alignment: .center) {
                                Text("You don't have any observations yet.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("Press + to start.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Spacer()
                }
                .navigationBarTitle(Text("Observations"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        self.sheetIsOpen.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 28.5, height: 28.5, alignment: .center)
                    }
                )
            }
        }
//        .sheet(isPresented: self.$sheetIsOpen, content: {
//            NewClassificationController(importFromPhotos: true, isPresented: $sheetIsOpen)
//                //.environment(\.managedObjectContext, self.managedObjectContext)
//        })
    }
    
    ///Funtion that removes an observation from the list of observations.
    func delete(at offsets: IndexSet) {
        
        //DispatchQueue.main.async {
        for index in offsets {
            let observationToRemove = observationList[index]
            managedObjectContext.delete(observationToRemove)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Can't delete from Core Data")
        }
        //}
    }
    
    ///Adds an observation to the favorites.
    func favoriteAction(at offsets: IndexSet) {
        
        //DispatchQueue.main.async {
        offsets.forEach { i in
            observationList[i].isFavorite = !observationList[i].isFavorite
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Can't change Core Data object.")
        }
        //}
    }
}

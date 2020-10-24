//
//  ClassificationDetails.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MapKit

///Model view that is used to present an observation.
///This show a circular image, map view with the location of the image.
///Also it includes buttons to show details, add to favorites and delete a view.
struct ObservationDetails: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    ///Works with child modal view to present the sheet with the details for that observation.
    @State private var presentObservationDetailsSheet: Bool = false
    ///Works with child modal view to present the sheet with the note for that observation.
    @State private var presentAddNoteSheet: Bool = false
    ///Controls the toggle of the alert for deleting observation.
    @State var showDeleteObservationAlert: Bool = false
    ///Controls when the share sheet is presented.
    @State var isPresentedShareSheet: Bool = false
    ///Icon name for when observation is favorite.
    @State var imageName: String = "star"
    ///Icon name for when observation is not favorite.
    @State var buttonLabel: String = "Add to Favorites"
    
    @State var showInformationSheet: Bool = false
    
    @Binding var sheetIsOpen: Bool
    
    ///Current observation being shown.
    @State var observation: Observation
    
    @ViewBuilder var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack {
                    
                    ZStack {
                        
                        MapView(latitude: observation.latitude, longitude: observation.longitude)
                            .frame(width: geometry.size.width, height: geometry.size.height / 3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .edgesIgnoringSafeArea(.top)
                            .onAppear() {
                                print("Map view apareceu")
                            }
                        
                        
                        ObservationImage(image: UIImage(data: observation.image!)!)
                            .frame(width: geometry.size.height / 4.3, height: geometry.size.height / 4.3, alignment: .center)
                            .offset(x: 0, y: geometry.size.height / 4.9)
                            .onAppear() {
                                print("Imagem cirular aparece")
                            }
                    }
                    
                    HStack() {
                        
                        VStack(alignment: .leading) {
                            Text(formatSpaciesName(name: observation.speciesName!))
                                .font(.system(size: geometry.size.height / 22, weight: .semibold))
                                .lineLimit(2)
                            
                            Text(formatDate(date: observation.observationDate!))
                                .font(.system(size: geometry.size.height / 51, weight: .medium))
                        }
                        .padding(.leading, 13)
                        .onAppear() {
                            print("Texto aparece")
                        }
                        
                        Spacer()
                        
                        ConfidenceCircleResults(confidence: observation.confidence)
                            .frame(width: geometry.size.width / 4.4, height: geometry.size.width / 4.4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.trailing, 13)
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height / 7)
                    .padding(.top, geometry.size.height / 6.5)
                    //.padding(.bottom, 30)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            
                            Divider()
                            
                            Button(action: { presentObservationDetailsSheet.toggle() }) {
                                HStack {
                                    Image(systemName: "plus.square.fill")
                                    Text("Observation Details").bold()
                                }
                                .padding(.leading, 15)
                            }
                            .sheet(isPresented: $presentObservationDetailsSheet) {
                                DetailsSheet(isPresented: $presentObservationDetailsSheet, observation: observation)
                                    .edgesIgnoringSafeArea(.bottom)
                            }
                            .padding(.top, 4.3)
                            .animation(.none)
                            
                            Divider()
                            
                            Button(action: { presentAddNoteSheet.toggle() }) {
                                HStack() {
                                    Image(systemName: "square.and.pencil")
                                    Text("Add Note").bold()
                                }
                                .padding(.leading, 15)
                            }
                            .sheet(isPresented: $presentAddNoteSheet) {
                                ObservationNoteSheet(isPresented: $presentAddNoteSheet, userNote: "", observation: observation)
                                    //.environment(\.managedObjectContext, managedObjectContext)
                            }
                            .padding(.top, 4.3)
                            .animation(.none)
                            
                            Divider()
                            
                            Button(action: {
                                showInformationSheet.toggle()
                            }) {
                                HStack() {
                                    Image(systemName: "info.circle.fill")
                                    Text("More Information").bold()
                                }
                                .padding(.leading, 15)
                            }
                            .padding(.top, 4.3)
                            .animation(.none)
                            .sheet(isPresented: $showInformationSheet) {
                                WebView(webLink: URL(string: wikipediaLinkDictionary[observation.speciesName!]!)!)
                            }

                            Divider()
                            
                            Button(action: { isPresentedShareSheet.toggle() }) {
                                HStack() {
                                    Image(systemName: "square.and.arrow.up.fill")
                                    Text("Share Observation").bold()
                                }
                                .padding(.leading, 15)
                            }
                            .sheet(isPresented: $isPresentedShareSheet) {
                                ShareSheet(items: getItemShareSheet())
                            }
                            .padding(.top, 4.3)
                            .animation(.none)
                            
                            Divider()
                        }
                        .padding(.bottom, 30)
                        
                        VStack(alignment: .leading) {
                            
                            Divider()
                            
                            Button(action: {
                                observation.isFavorite = !observation.isFavorite
                                changeFavoriteButton()
                                try? managedObjectContext.save()
                            }) {
                                HStack {
                                    Image(systemName: imageName).foregroundColor(.yellow)
                                    Text(buttonLabel)
                                        .bold()
                                }
                                .padding(.leading, 15)
                            }
                            .padding(.top, 4.3)
                            .animation(.none)
                            .onAppear() {
                                changeFavoriteButton()
                            }
                            
                            Divider()
                            
                            Button(action: {
                                showDeleteObservationAlert.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                    Text("Remove Observation").bold()
                                }
                                .padding(.leading, 15)
                            }
                            .padding(.top, 4.3)
                            
                            Divider()
                        }
                        .padding(.bottom, 30)
                        .animation(.none)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 90)
                    .alert(isPresented: $showDeleteObservationAlert) {
                        Alert(title: Text("Delete observation"), message: Text("Are you sure you want to delete this observation and associated data?"), primaryButton: .destructive(Text("Yes")) {
                            
                            do {
                                sheetIsOpen = false
                                presentationMode.wrappedValue.dismiss()
                                managedObjectContext.delete(observation)
                                try managedObjectContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }, secondaryButton: .cancel(Text("No")))
                    }
                    .accentColor(.none)
                }
                .navigationBarTitle(Text(""))
                .navigationBarItems(trailing:
                    Button(action: { sheetIsOpen.toggle() }) {
                        Text("Dismiss")
                    }
                )
             }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func changeFavoriteButton() {
        if observation.isFavorite {
            imageName = "star.fill"
            buttonLabel = "Remove from favorites"
        }
        else {
            imageName = "star"
            buttonLabel = "Add to Favorites"
        }
    }
    
    func getItemShareSheet() -> [Any] {
        //TODO: Adicionar link para a app na App Store

        let species = observation.speciesName!.appending(" by Lepilens iOS")
        let confidence = observation.confidence
        let image = UIImage(data: observation.image!)!.resized(withPercentage: 0.5)
        let date = observation.observationDate

        var finalText: String = ""

        if let latitude = observation.value(forKey: "latitude") as? Double, let longitude = observation.value(forKey: "longitude") as? Double {

            var latitude_ = ""
            var longitude_ = ""

            if latitude != -999 && longitude != -999 {
                latitude_ = String(format: "%.1f", latitude)
                longitude_ = String(format: "%.1f", longitude)
            }
            else {
                latitude_ = "Not available"
                longitude_ = "Not available"
            }

            finalText = "New observation - \(formatDate(date: date!))\nSpecies: \(species)\nConfidence: \(confidence)\nLatitude: \(latitude_)\nLongitude: \(longitude_)"
        }
        else {
            finalText = "New observation - \(formatDate(date: date!))\nSpecies: \(species)\nConfidence: \(confidence)"
        }

        let items: [Any] = [finalText, image!]
        return items
    }
    
    func formatSpaciesName(name: String) -> String {
        
        let nameArray = name.split(separator: " ")
        if nameArray[0].count >= 10 {
            return nameArray[0] + "\n" + nameArray[1]
        }
        
        return name
        //return nameArray[0] + "\n" + nameArray[1]
    }
}

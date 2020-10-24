//
//  ObservationActionButtons.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import UIKit

struct ObservationActionButtons: View {
    
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
    
    var observation: Observation
    
    @Binding var sheetIsOpen: Bool
    
    var body: some View {
        
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
        .padding(.bottom, 90)
        .alert(isPresented: $showDeleteObservationAlert) {
            Alert(title: Text("Delete observation"), message: Text("Are you sure you want to delete this observation and associated data?"), primaryButton: .destructive(Text("Yes")) {
                
                sheetIsOpen = false
                presentationMode.wrappedValue.dismiss()
                
                do {
                    managedObjectContext.delete(observation)
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
                
            }, secondaryButton: .cancel(Text("No")))
        }
        .onAppear() {
            changeFavoriteButton()
        }
        .accentColor(.none)
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
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

//
//  SheetImagePicker.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 15/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos
import CoreImage

struct SheetImagePicker: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    ///Stores the image imported by the user.
    @State var userImportedImage =  UIImage()
    
    ///User image metadata - if available stores the date in which the picture was taken.
    @State var imageDate: Date?
    ///User image metadata - if available stores the location where the picture was taken.
    @State var imageLocation: CLLocation?
    
    
    @State var imagePickerIsPresented = false
    @State var isVibible = false
    @State var imageWasImported = false
    @State var showAlert = false
    
    
    @Binding var sheetIsPresented: Bool
    @Binding var observation: Observation?
    
    var importImageFromPhotos: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                if !self.imageWasImported {
                    
                    if self.importImageFromPhotos {
                        
                        Button(action: {
                            self.imagePickerIsPresented.toggle()
                        }) {
                            Text(topRectangleButtonString)
                        }
                        .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            ImagePickerView(isPresented: self.$isVibible, selectedImage: self.$userImportedImage, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Photos")
                        })
                    }
                    else {
                        
                        Button(action: {
                            self.imagePickerIsPresented.toggle()
                        }) {
                            Text(bottomRectangleButtonString)
                        }
                        .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            ImagePickerView(isPresented: self.$isVibible, selectedImage: self.$userImportedImage, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Camera") //FIXME: Change the way the source type is handled.
                        })
                    }
                }
                else {
                    
                    ImageToClassifyPlaceholder(image: self.userImportedImage)
                        .opacity(self.isVibible ? 1 : 0)
                        .scaleEffect(self.isVibible ? 1 : 0)
                        .onAppear() {
                            withAnimation(.easeIn(duration: 1)) {
                                self.isVibible.toggle()
                            }
                        }
                }
                
                Spacer()
                
                VStack {
                    
                    Button(action: {
                        
                        //Runs user initiated action of classifying the image.
                        //Executed out of the main thread not to block the user interface.
                        DispatchQueue.global(qos: .userInitiated).async {
                            //TODO: What happens if the this is sync. Do I need the semaphore?
                            
                            let newInference = ModelInference()
                            newInference.runInference(image: self.userImportedImage)
                            
                            DispatchQueue.main.async {
                                
                                if let topFiveResults = newInference.getResults() {
                                    
                                    //Label comes in the format eg. Vanessa_atalanta.
                                    let labelComponents = topFiveResults[0].label.components(separatedBy: "_")
                                    let finalLabel = labelComponents[0] + " " + labelComponents[1]
                                    
                                    let confidence = topFiveResults[0].confidence
                                    
                                    let observation = Observation(speciesName: finalLabel, classificationConfidence: confidence, image: self.userImportedImage, location: self.imageLocation, date: Date(), isFavorite: false, time: "17:00")
                                    
                                    self.observation = observation
                                    self.records.addObservation(self.observation!)
                                }
                            }
                        }
                    }) {
                        Text("Classify")
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 30)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 60, style: .continuous))
                    }
                    .disabled(self.imageWasImported == false)
                    //If no image was imported the button is disabled.
                    
                    Button(action: {
                        
                        self.imageWasImported = false
                        self.isVibible.toggle()
                    }) {
                        Text("Clear")
                    }
                    .padding(.top, 15)
                    .disabled(self.imageWasImported == false)
                    //If no image was imported the button is disabled.
                }
            }
            .navigationBarTitle(Text("New Observation"))
        }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Location Error"), message: Text("To create a new observation Imago needs to use your location"), primaryButton: .destructive(Text("Close")) { self.sheetIsPresented.toggle() }, secondaryButton: .cancel(Text("Continue")))
            }
        //TODO: Change to show alert if the classification failed.
    }
}

private let topRectangleButtonString: String = "Import photo from Photos"
private let rectanglePaddingDivisor: CGFloat = 2.5 //FIXME: Is it possible to change this?
private let bottomRectangleButtonString: String = "Open the Camera app"

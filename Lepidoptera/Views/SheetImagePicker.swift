//
//  SheetImagePicker.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 15/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos
import PhotosUI
import CoreImage

///This View imports the image and has the buttons to manage the imported image.
///The classify button is used to classify an image and call the model to make a prediction.
///The clear button is used to clear the image from the view and that image is no longer used in the classification.
///At the center of this view a Text Button can be clicked to call the ImagePicker in order to select an image.
struct SheetImagePicker: View {
    
    ///Stores the classifications present in the application.
    @EnvironmentObject var records: ObservationRecords
    
    ///Stores the image imported by the user.
    @State var imageToClassify =  UIImage()
    ///Variable that stores whether the ImagePicker sheet is up or not.
    @State var imagePickerIsPresented = false
    ///User image metadata - if available stores the date in which the picture was taken.
    @State var imageDate: Date?
    ///User image metadata - if available stores the location where the picture was taken.
    @State var imageLocation: CLLocation?
    ///Shows alert if something went wrong this the classification.
    @State var showAlert = false
    ///Show alert if user denied access to the Photos app.
    @State var showPhotosAccessDeniedAlert = false
    ///Controls if the image placeholder for the image to classify is visible.
    @State var imagePlaceholderIsVisible = false
    ///Boolean variable that tells if the image Placeholder is empty or not.
    @State var imageWasImported = false
    
    ///Variable that controls wheater the classification sheet is open or not.
    ///Whenever this variable changes the state of the sheet changes - up or down.
    @Binding var sheetIsPresented: Bool
    ///The fact that this variable contains an observation or not lets the parent view know if
    ///it should present a new sheet to import an image or to show the result of a classification.
    @Binding var observation: Observation?
    
    ///Value comes from parent view to inform the current view the source of the image:
    ///Camera ou Photos application.
    var imageWillBeImportedFromPhotos: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                if !self.imageWasImported {
                    
                    if self.imageWillBeImportedFromPhotos {
                        
                        ///Handle Photos app acess.
                        Button(action: {
                            
                            if #available(iOS 14, *) {
                                
                                let accessLevel: PHAccessLevel = .readWrite
                                let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
                                
                                switch status {
                                case .authorized:
                                    self.imagePickerIsPresented.toggle()
                                case .limited:
                                    print("Limited access - show picker.")
                                    self.imagePickerIsPresented.toggle()
                                case .denied:
                                    self.showPhotosAccessDeniedAlert.toggle()
                                case .notDetermined:
                                    PHPhotoLibrary.requestAuthorization { newStatus in
                                        switch newStatus {
                                        case .authorized:
                                            print("Full access.")
                                        case .limited:
                                            print("Limited access.")
                                            break
                                        case .denied:
                                            break
                                        default:
                                            break
                                        }
                                    }
                                default:
                                    break
                                    
                                    
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                            
                            print(self.imagePickerIsPresented)
                        }) {
                            Text(openPhotosAppTextString)
                        }
                        .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            
                            if #available(iOS 14, *) {
                                ImagePicker(imageToImport: self.$imageToClassify, isPresented: self.$imagePickerIsPresented, imageWasImported: self.$imageWasImported)
                            }
                            //else {
//                                ImagePickerView(isPresented: self.$imagePlaceholderIsVisible, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Photos") //FIXME: Change the way the source type is handled.
                            //}
                        })
                    }
                    else {
                        
                        //Handle Camera access.
                        Button(action: {
                            
                            
                            
                            
                            
                            
                            
                            self.imagePickerIsPresented.toggle()
                            print(self.$imagePickerIsPresented)
                        }) {
                            Text(openCameraAppTextString)
                        }
                        .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            ImagePickerView(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Camera") //FIXME: Change the way the source type is handled.
                        })
                    }
                }
                else {
                    
                    Spacer()
                    
                    ImageToClassifyPlaceholder(image: self.imageToClassify)
                        .opacity(self.imagePlaceholderIsVisible ? 1 : 0)
                        .scaleEffect(self.imagePlaceholderIsVisible ? 1 : 0)
                        .onAppear() {
                            withAnimation(.easeIn(duration: 1)) {
                                self.imagePlaceholderIsVisible.toggle()
                            }
                        }
                        .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.4, alignment: .center)
                }
                
                Spacer()
                
                VStack {
                    
                    Button(action: {
                        
                        //Runs user initiated action of classifying the image.
                        //Executed out of the main thread not to block the user interface.
                        DispatchQueue.global(qos: .userInitiated).async {
                            //TODO: What happens if the this is sync. Do I need the semaphore?
                            
                            let newInference = ModelInference()
                            newInference.runInference(image: self.imageToClassify)
                            
                            DispatchQueue.main.async {
                                
                                if let topFiveResults = newInference.getResults() {
                                    
                                    //Label comes in the format eg. Vanessa_atalanta.
                                    let labelComponents = topFiveResults[0].label.components(separatedBy: "_")
                                    let finalLabel = labelComponents[0] + " " + labelComponents[1]
                                    
                                    let confidence = topFiveResults[0].confidence
                                    
                                    let observation = Observation(speciesName: finalLabel, classificationConfidence: confidence, image: self.imageToClassify, location: self.imageLocation, date: Date(), isFavorite: false, time: "17:00")
                                    
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
                        self.imagePlaceholderIsVisible.toggle()
                    }) {
                        Text("Clear")
                    }
                    .padding(.top, 15)
                    .disabled(self.imageWasImported == false)
                    //If no image was imported the button is disabled.
                }
            }
            .navigationBarTitle(Text("New Observation"))
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        //TODO: Change to show alert if the classification failed.
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location Error"), message: Text("To create a new observation Imago needs to use your location"), primaryButton: .destructive(Text("Close")) { self.sheetIsPresented.toggle() }, secondaryButton: .cancel(Text("Continue"))) //FIXME: This strings need to be put in constants outside the view.
        }
        .alert(isPresented: $showPhotosAccessDeniedAlert) {
            Alert(title: Text("Access to Photos was denied"), message: Text("If you want to give this app access to Photos, go to Settings -> Lepidoptera -> Photos."), dismissButton: .default(Text("Close")))
        }
    }
}

private let openPhotosAppTextString: String = "Import image from Photos"
private let openCameraAppTextString: String = "Open the Camera app"
private let rectanglePaddingDivisor: CGFloat = 2.5 //FIXME: Is it possible to change this?

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

enum ActiveAlert {
    case butterflyWasNotDetected,
         noResultsConfidenceThreshold,
         photosAccessDenied,
         canNotImportPhoto,
         canNotSaveCoreData
}

///This View imports the image and has the buttons to manage the imported image.
///The classify button is used to classify an image and call the model to make a prediction.
///The clear button is used to clear the image from the view and that image is no longer used in the classification.
///At the center of this view a Text Button can be clicked to call the ImagePicker in order to select an image.
struct SheetImagePicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var imageWillBeImportedFromPhotos: Bool
    
    ///Stores the image imported by the user.
    @State var imageToClassify = UIImage()
    ///User image metadata - if available stores the date in which the picture was taken.
    @State var imageDate: Date?
    ///User image metadata - if available stores the location where the picture was taken.
    @State var imageLocation: CLLocation?
    ///Height in Pixels of the image imported by the user.
    @State var imageHeight: Int = 0
    ///Width in pixels of the imahe imported by the user.
    @State var imageWidth: Int = 0
    ///Saves the origin of the photo for the observation.
    @State var imageSource: String = ""
    ///Shows alert if something went wrong this the classification.
    @State var showAlert = false
    ///Controls progress view when ImageIsBeingClassified
    @State var imageIsBeingClassified = false
    ///Controls if the image placeholder for the image to classify is visible.
    @State var imagePlaceholderIsVisible = false
    ///Boolean variable that tells if the image Placeholder is empty or not.
    @State var imageWasImported = false
    ///Variable that stores whether the ImagePicker sheet is up or not.
    @State var imagePickerIsPresented = false
    ///Controls the type of alert showed to the user.
    @State var activeAlert: ActiveAlert?
    
    
    ///Tells the previous control view if it can show the result for the classification or not.
    @Binding var classificationWasSuccessful: Bool
    ///Saves the result classification.
    @Binding var observation: Observation
    ///Variable that controls wheater the classification sheet is open or not.
    @Binding var sheetIsPresented: Bool
    
    let newInference = ModelInference()
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                if !self.imageWasImported {
                    
                    if self.imageWillBeImportedFromPhotos {
                        
                        ///Handle Photos app acess.
                        Button(action: {
                            
                            self.imageSource = "iOS Photo Library"
                            DispatchQueue.global(qos: .userInteractive).async {
                                
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
                                        self.activeAlert = .photosAccessDenied
                                        self.showAlert.toggle()
                                    case .notDetermined:
                                        PHPhotoLibrary.requestAuthorization(for: accessLevel) { newStatus in
                                            switch newStatus {
                                            case .limited:
                                                print("Limited access.")
                                            case .authorized:
                                                print("Full access.")
                                            case .denied:
                                                print("Access denied")
                                            default:
                                                break
                                            }
                                        }
                                    default:
                                        break
                                    }
                                } else {
                                    
                                    let status = PHPhotoLibrary.authorizationStatus()
                                    
                                    switch status {
                                    case .authorized:
                                        self.imagePickerIsPresented.toggle()
                                    case .denied:
                                        self.activeAlert = .photosAccessDenied
                                        self.showAlert.toggle()
                                    case .notDetermined:
                                        PHPhotoLibrary.requestAuthorization() { newStatus in
                                            switch newStatus {
                                            case .authorized:
                                                print("Full access")
                                            case .denied:
                                                print("Access denied")
                                            default:
                                                break
                                            }
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                        }) {
                            Text(openPhotosAppTextString).bold()
                        }
                        .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            
                            if #available(iOS 14, *) {
                                ImagePicker_iOS14(imageToImport: self.$imageToClassify, isPresented: self.$imagePickerIsPresented, imageWasImported: self.$imageWasImported, presentAlert: self.$showAlert, activeAlert: self.$activeAlert, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth)
                            }
                            else {
                                ImagePickeriOS13(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth, sourceType: "Photos") //FIXME: Change the way the source type is handled.
                            }
                        })
                    }
                    else {
                        //Handle Camera access.
                        if #available(iOS 14.0, *) {
                            Button(action: {
                                self.imageSource = "iPhone Camera"
                                self.imagePickerIsPresented.toggle()
                            }) {
                                Text(openCameraAppTextString).bold()
                            }
                            .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                            .fullScreenCover(isPresented: self.$imagePickerIsPresented, content: {
                                ImagePickeriOS13(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth, sourceType: "Camera").edgesIgnoringSafeArea(.all) //FIXME: Change the way the source type is handled.
                            })
                        } else {
                            Button(action: {
                                self.imageSource = "iPhone Camera"
                                self.imagePickerIsPresented.toggle()
                            }) {
                                Text(openCameraAppTextString)
                            }
                            .padding(.top, geometry.size.height / rectanglePaddingDivisor)
                            .sheet(isPresented: self.$imagePickerIsPresented, content: {
                                ImagePickeriOS13(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth, sourceType: "Camera") //FIXME: Change the way the source type is handled.
                            })
                        }
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
                    
                    if !imageIsBeingClassified {
                        
                        Button(action: {
                            
                            self.imageIsBeingClassified.toggle()
                            
                            //Runs user initiated action of classifying the image.
                            //Executed out of the main thread not to block the user interface.
                            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
                                //TODO: What happens if the this is sync. Do I need the semaphore?
                                
                                //                                let newInference = ModelInference()
                                let butterflyWasDetected = newInference.detectButterfly(receivedImage: self.imageToClassify)
                                
                                if butterflyWasDetected {
                                    runInference()
                                }
                                else {
                                    print("Butterfly not detected")
                                    self.activeAlert = .butterflyWasNotDetected
                                    self.showAlert.toggle()
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
                        .padding(.top, 10)
                        .disabled(self.imageWasImported == false)
                        //If no image was imported the button is disabled.
                    }
                    else {
                        if #available(iOS 14.0, *) {
                            ProgressView("Classifying image...").padding(.bottom, 10)
                        } else {
                            Text("Classifying image...")
                        }
                    }
                }
                .padding(.bottom, 15)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .navigationBarTitle(Text("New Observation"))
        }
        //TODO: Change to show alert if the classification failed.
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .butterflyWasNotDetected:
                return Alert(title: Text("Butterfly not detected"), message: Text("The ML Model was not able to detect a butterfly in your image. Therefore, results may not make sense for the content of your image. To obtain the best results make sure the subject of your observation is centered and visible in the image."), primaryButton: .default(Text("Cancel")) { self.sheetIsPresented.toggle()
                }, secondaryButton: .destructive(Text("Proceed")) {
                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
                        runInference() }
                })
            case .noResultsConfidenceThreshold:
                return Alert(title: Text("No results for chosen confidence threshold."), message: Text("The confidence obtained for the observation was below the confidence threshold that was set. If you want to change it go to the \"Settings\" section of the app."), dismissButton: .default(Text("OK")) {
                    self.sheetIsPresented.toggle()
                })
            case .canNotImportPhoto:
                return Alert(title: Text("Access denied"), message: Text("This app can not access the selected photo because of limited access to your Photo Library. To change this you need to edit your selection."), primaryButton: .default(Text("Edit selection")) {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }, secondaryButton: .default(Text("Ok")))
            case .photosAccessDenied:
                return Alert(title: Text("Access to Photos was denied"), message: Text("If you want to give this app access to Photos, go to Settings - Lepidoptera - Photos."), dismissButton: .default(Text("Close")))
            case .canNotSaveCoreData:
                return Alert(title: Text("Can not save new observation"), message: Text("There was an error will trying to save the new observation. Please, check if your device storage is full."), dismissButton: .default(Text("Close")))
            case .none:
                return Alert(title: Text("Default alert"))
            }
        }
    }
    
    func runInference() {
        
        newInference.runInference(image: self.imageToClassify)
        
        DispatchQueue.main.async {
            
            if let topFiveResults = newInference.getResults() {
                
                //Label comes in the format eg. Vanessa_atalanta.
                let labelComponents = topFiveResults[0].label.components(separatedBy: "_")
                let finalLabel = labelComponents[0] + " " + labelComponents[1]
                
                if UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int == nil {
                    UserDefaults.standard.setValue(0, forKey: "confidence_threshold_index")
                }
                
                guard let index = UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int else {
                    return
                }
                
                let chosenConfidenceThreshold = availableConfidence[index]
                let confidence = topFiveResults[0].confidence
                
                if confidence >= chosenConfidenceThreshold {
                    //let date = formatDate(date: Date())
                    //let time = formatTime(date: Date())
                    
                    let newObservation = Observation(entity: Observation.entity(), insertInto: managedObjectContext)
                    newObservation.id = UUID()
                    newObservation.speciesName = finalLabel
                    newObservation.confidence = confidence
                    newObservation.observationDate = Date()
                    newObservation.imageCreationDate = self.imageDate
                    newObservation.image = self.imageToClassify.jpegData(compressionQuality: 1.0)
                    newObservation.imageSource = self.imageSource
                    newObservation.imageHeight = Int16(self.imageHeight)
                    newObservation.imageWidth = Int16(self.imageWidth)
                    newObservation.isFavorite = false
                    newObservation.userNote = ""
                    
                    if let latitude = self.imageLocation?.coordinate.latitude, let longitude = self.imageLocation?.coordinate.longitude {
                        newObservation.latitude = latitude
                        newObservation.longitude = longitude
                    }
                    else {
                        newObservation.latitude = -1
                        newObservation.longitude = -1
                    }
                    
                    do {
                        try self.managedObjectContext.save()
                        self.observation = newObservation
                        self.classificationWasSuccessful = true
                        //self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        self.activeAlert = .canNotSaveCoreData
                        self.showAlert.toggle()
                    }
                }
                else {
                    self.imageIsBeingClassified = false
                    self.imageWasImported = false
                    self.activeAlert = .noResultsConfidenceThreshold
                    self.showAlert.toggle()
                }
            }
        }
    }
}

private let openPhotosAppTextString: String = "Import from Photos"
private let openCameraAppTextString: String = "Open Camera"
private let rectanglePaddingDivisor: CGFloat = 2.5 //FIXME: Is it possible to change this?

func formatDate(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "MMMM dd, yyyy"
    
    let date = dateFormatter.string(from: date)
    return date
}

func formatTime(date: Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.timeZone = .current
    dateFormatter.dateFormat = "hh:mm a"
    
    let time = dateFormatter.string(from: date)
    return time
}




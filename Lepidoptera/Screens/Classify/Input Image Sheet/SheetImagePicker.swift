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
import UniformTypeIdentifiers
import CoreData

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
    
    ///Variable that controls wheater the classification sheet is open or not.
    @Binding var sheetIsPresented: Bool
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
    ///Variable that controls when camera turns on
    @State var cameraIsPresented = false
    ///Variable that controls when file picker shows up
    @State var filePickerIsPresented = false
    ///Controls the type of alert showed to the user.
    @State var activeAlert: ActiveAlert?
    ///Tells the previous control view if it can show the result for the classification or not.
    @State var classificationWasSuccessful: Bool = false
    ///Saves the result classification.
    @State var observation: Observation?
    
    @State var viewTitle = "New Observation"
    
    let newInference = ModelInference()
    
//    @ViewBuilder var body: some View {
//
//        if !classificationWasSuccessful {
//
//            GeometryReader { geometry in
//
//                NavigationView {
//
//                    VStack {
//
//                        if !imageWasImported {
//
//                            //if self.imageWillBeImportedFromPhotos {
//                            //Spacer()
//
//                            HStack {
//                                ///Handle Photos app acess.
//                                //Spacer()
//
//                                Button(action: {
//
//                                    imageSource = "iOS Photo Library"
//                                    DispatchQueue.global(qos: .userInteractive).async {
//
//                                        if #available(iOS 14, *) {
//
//                                            let accessLevel: PHAccessLevel = .readWrite
//                                            let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)
//
//                                            switch status {
//                                            case .authorized:
//                                                imagePickerIsPresented.toggle()
//                                            case .limited:
//                                                print("Limited access - show picker.")
//                                                imagePickerIsPresented.toggle()
//                                            case .denied:
//                                                activeAlert = .photosAccessDenied
//                                                showAlert.toggle()
//                                            case .notDetermined:
//                                                PHPhotoLibrary.requestAuthorization(for: accessLevel) { newStatus in
//                                                    switch newStatus {
//                                                    case .limited:
//                                                        print("Limited access.")
//                                                    case .authorized:
//                                                        print("Full access.")
//                                                    case .denied:
//                                                        print("Access denied")
//                                                    default:
//                                                        break
//                                                    }
//                                                }
//                                            default:
//                                                break
//                                            }
//                                        } else {
//
//                                            let status = PHPhotoLibrary.authorizationStatus()
//
//                                            switch status {
//                                            case .authorized:
//                                                imagePickerIsPresented.toggle()
//                                            case .denied:
//                                                activeAlert = .photosAccessDenied
//                                                showAlert.toggle()
//                                            case .notDetermined:
//                                                PHPhotoLibrary.requestAuthorization() { newStatus in
//                                                    switch newStatus {
//                                                    case .authorized:
//                                                        print("Full access")
//                                                    case .denied:
//                                                        print("Access denied")
//                                                    default:
//                                                        break
//                                                    }
//                                                }
//                                            default:
//                                                break
//                                            }
//                                        }
//                                    }
//                                }) {
//                                    VStack {
//                                        Image(systemName: "photo.fill.on.rectangle.fill")
//                                            .resizable()
//                                            .frame(width: 40, height: 32, alignment: .center)
//                                            .padding(.bottom, 10)
//                                        Text(openPhotosAppTextString).bold()
//                                    }
//                                }
//                                .padding(.leading, geometry.size.width / 6)
//                                .sheet(isPresented: $imagePickerIsPresented, content: {
//
//                                    //if #available(iOS 14, *) {
//                                    ImagePicker_iOS14(imageToImport: $imageToClassify, isPresented: $imagePickerIsPresented, imageWasImported: $imageWasImported, presentAlert: $showAlert, activeAlert: $activeAlert, date: $imageDate, location: $imageLocation, imageHeight: $imageHeight, imageWidth: $imageWidth)
//                                    //}
//    //                                else {
//    //                                    ImagePickeriOS13(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth, sourceType: "Photos") //FIXME: Change the way the source type is handled.
//    //                                }
//                                })
//
//                                Spacer()
//
//                                Button(action: {
//                                    imageSource = "iPhone Files app"
//                                    filePickerIsPresented.toggle()
//                                }) {
//                                    VStack {
//                                        Image(systemName: "folder.fill")
//                                            .resizable()
//                                            .frame(width: 40, height: 32, alignment: .center)
//                                            .padding(.bottom, 10)
//                                        Text("Open Files").bold()
//                                    }
//                                }
//                                .fileImporter(isPresented: $filePickerIsPresented, allowedContentTypes: [.jpeg, .png]) { res in
//
//                                    do {
//                                        let selectedFile: URL = try res.get()
//
//                                        if selectedFile.startAccessingSecurityScopedResource() {
//                                            let imageData = try Data(contentsOf: res.get())
//                                            imageToClassify = UIImage(data: imageData)!
//                                            imageWasImported = true
//
//                                            do { selectedFile.stopAccessingSecurityScopedResource() }
//                                        }
//
//                                    } catch {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                                .padding(.trailing, geometry.size.width / 6)
//                            }
//                            .padding(.top, geometry.size.height / 3)
//
//                            HStack {
//
//                                Spacer()
//
//                                Button(action: {
//                                    imageSource = "iPhone Camera"
//                                    cameraIsPresented.toggle()
//                                }) {
//                                    VStack {
//                                        Image(systemName: "camera.on.rectangle.fill")
//                                            .resizable()
//                                            .frame(width: 40, height: 32, alignment: .center)
//                                            .padding(.bottom, 10)
//                                        Text(openCameraAppTextString).bold()
//                                    }
//                                }
//                                .padding(.top, 25)
//                                .fullScreenCover(isPresented: $cameraIsPresented, content: {
//                                    ImagePickeriOS13(isPresented: $cameraIsPresented, selectedImage: $imageToClassify, imageWasImported: $imageWasImported, date: $imageDate, location: $imageLocation, imageHeight: $imageHeight, imageWidth: $imageWidth, sourceType: "Camera").edgesIgnoringSafeArea(.all) //FIXME: Change the way the source type is handled.
//                                })
//
//                                Spacer()
//                            }
//                        }
//                        else {
//
//                            Spacer()
//
//                            ImageToClassifyPlaceholder(image: imageToClassify)
//                                .opacity(imagePlaceholderIsVisible ? 1 : 0)
//                                .scaleEffect(imagePlaceholderIsVisible ? 1 : 0)
//                                .onAppear() {
//                                    withAnimation(.easeIn(duration: 1)) {
//                                        imagePlaceholderIsVisible.toggle()
//                                    }
//                                }
//                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.4, alignment: .center)
//
//                        }
//
//                        Spacer()
//
//                        VStack {
//
//                            if !imageIsBeingClassified {
//
//                                Button(action: {
//
//                                    imageIsBeingClassified.toggle()
//
//                                    //Runs user initiated action of classifying the image.
//                                    //Executed out of the main thread not to block the user interface.
//                                    DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
//                                        //TODO: What happens if the this is sync. Do I need the semaphore?
//
//                                        //                                let newInference = ModelInference()
//                                        let butterflyWasDetected = newInference.detectButterfly(receivedImage: imageToClassify)
//
//                                        if butterflyWasDetected {
//                                            runInference()
//                                        }
//                                        else {
//                                            print("Butterfly not detected")
//                                            activeAlert = .butterflyWasNotDetected
//                                            showAlert.toggle()
//                                        }
//                                    }
//                                }) {
//                                    Text("Classify")
//                                        .padding([.top, .bottom], 12)
//                                        .padding([.leading, .trailing], 30)
//                                        .font(.system(size: 18, weight: .medium, design: .rounded))
//                                        .foregroundColor(.white)
//                                        .background(RoundedRectangle(cornerRadius: 60, style: .continuous))
//                                }
//                                .disabled(imageWasImported == false)
//                                //If no image was imported the button is disabled.
//
//                                Button(action: {
//
//                                    imageWasImported = false
//                                    imagePlaceholderIsVisible.toggle()
//                                }) {
//                                    Text("Clear")
//                                }
//                                .padding(.top, 10)
//                                .disabled(imageWasImported == false)
//                                //If no image was imported the button is disabled.
//                            }
//                            else {
//                                if #available(iOS 14.0, *) {
//                                    ProgressView("Classifying image...").padding(.bottom, 10)
//                                } else {
//                                    Text("Classifying image...")
//                                }
//                            }
//                        }
//                        .padding(.bottom, 15)
//                    }
//                    .alert(isPresented: $showAlert) {
//                        switch activeAlert {
//                        case .butterflyWasNotDetected:
//                            return Alert(title: Text("Butterfly not detected"), message: Text("The ML Model was not able to detect a butterfly in your image. Therefore, results may not make sense for the content of your image. To obtain the best results make sure the subject of your observation is centered and visible in the image."), primaryButton: .default(Text("Cancel")) { sheetIsPresented.toggle()
//                            }, secondaryButton: .destructive(Text("Proceed")) {
//                                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
//                                    runInference() }
//                            })
//                        case .noResultsConfidenceThreshold:
//                            return Alert(title: Text("No results for chosen confidence threshold."), message: Text("The confidence obtained for the observation was below the confidence threshold that was set. If you want to change it go to the \"Settings\" section of the app."), dismissButton: .default(Text("OK")) {
//                                sheetIsPresented.toggle()
//                            })
//                        case .canNotImportPhoto:
//                            return Alert(title: Text("Access denied"), message: Text("This app can not access the selected photo because of limited access to your Photo Library. To change this you need to edit your selection."), primaryButton: .default(Text("Edit selection")) {
//                                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//                                }
//                            }, secondaryButton: .default(Text("Ok")))
//                        case .photosAccessDenied:
//                            return Alert(title: Text("Access to Photos was denied"), message: Text("If you want to give this app access to Photos, go to Settings - Lepidoptera - Photos."), dismissButton: .default(Text("Close")))
//                        case .canNotSaveCoreData:
//                            return Alert(title: Text("Can not save new observation"), message: Text("There was an error will trying to save the new observation. Please, check if your device storage is full."), dismissButton: .default(Text("Close")))
//                        case .none:
//                            return Alert(title: Text("Default alert"))
//                        }
//                    }
//                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                    .navigationBarTitle(Text("New Observation"))
//                    .navigationBarItems(trailing:
//                        Button(action: { sheetIsPresented.toggle() }) {
//                            Text("Dismiss")
//                        }
//                    )
//                }
//
//                Spacer()
//            }
//        }
//        else {
//            VStack {
////                if observation != nil {
//                    ObservationDetails(sheetIsOpen: $sheetIsPresented, observation: observation!)
//                        .environment(\.managedObjectContext, managedObjectContext)
//                        .onAppear() {
//                            print(classificationWasSuccessful)
//                        }
//                //}
//
//            }
////            .transition(.slide)
////            .animation(.easeInOut(duration: 1.5))
////            .navigationBarItems(trailing:
////                Button(action: { sheetIsPresented.toggle() }) {
////                    Text("Dismiss")
////                }
////            )
//
////            ObservationDetails(sheetIsOpen: $sheetIsPresented, observation: observation!)
////                .transition(.slide)
////                .animation(.easeInOut(duration: 1.5))
////                .environment(\.managedObjectContext, managedObjectContext)
////                .onAppear() {
////                    print(classificationWasSuccessful)
////                }
//        }
//    }
//
//    func runInference() {
//
//        //newInference.coreMLModelInference(receivedImage: self.imageToClassify)
//        newInference.runInference(image: imageToClassify)
//
//        DispatchQueue.main.sync {
//
//            if let topFiveResults = newInference.getResults() {
//
//                //Label comes in the format eg. Vanessa_atalanta.
//                //let labelComponents = topFiveResults[0].label.components(separatedBy: "_")
//                //let finalLabel = labelComponents[0] + " " + labelComponents[1]
//                let finalLabel = topFiveResults[0].label
//
//                if UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int == nil {
//                    UserDefaults.standard.setValue(0, forKey: "confidence_threshold_index")
//                }
//
//                guard let index = UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int else {
//                    return
//                }
//
//                let chosenConfidenceThreshold = availableConfidence[index]
//                let confidence = topFiveResults[0].confidence
//
//                if confidence >= chosenConfidenceThreshold {
//
//                    let newObservation = Observation(entity: Observation.entity(), insertInto: managedObjectContext)
//
//                    newObservation.id = UUID()
//                    newObservation.speciesName = finalLabel
//                    newObservation.genus = String(finalLabel.split(separator: " ")[0])
//                    newObservation.family = familyDictionary[finalLabel]
//                    newObservation.confidence = confidence
//                    newObservation.observationDate = Date()
//                    newObservation.imageCreationDate = imageDate
//                    newObservation.image = imageToClassify.jpegData(compressionQuality: 1.0)
//                    newObservation.imageSource = imageSource
//                    newObservation.imageHeight = Int16(imageHeight)
//                    newObservation.imageWidth = Int16(imageWidth)
//                    newObservation.isFavorite = false
//                    newObservation.userNote = ""
//
//                    if let latitude = imageLocation?.coordinate.latitude, let longitude = imageLocation?.coordinate.longitude {
//                        newObservation.latitude = latitude
//                        newObservation.longitude = longitude
//                    }
//                    else {
//                        newObservation.latitude = -999
//                        newObservation.longitude = -999
//                    }
//
//                    do {
//                        try managedObjectContext.save()
//                        observation = newObservation
//
//                        //presentationMode.wrappedValue.dismiss()
//
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                            print("Aqui")
////                            classificationWasSuccessful = true
////                        }
//
//                        viewTitle = ""
//                        //self.presentationMode.wrappedValue.dismiss()
//                    } catch {
//                        activeAlert = .canNotSaveCoreData
//                        showAlert.toggle()
//                        return
//                    }
//
//                    classificationWasSuccessful = true
//                }
//                else {
//                    imageIsBeingClassified = false
//                    imageWasImported = false
//                    activeAlert = .noResultsConfidenceThreshold
//                    showAlert.toggle()
//                }
//            }
//        }
//    }
    
    var body: some View {

        NavigationView {

            VStack {

                if !classificationWasSuccessful {

                    GeometryReader { geometry in

                        VStack {

                            if !imageWasImported {

                                //if self.imageWillBeImportedFromPhotos {
                                //Spacer()

                                HStack {
                                    ///Handle Photos app acess.
                                    //Spacer()

                                    Button(action: {

                                        imageSource = "iOS Photo Library"
                                        DispatchQueue.global(qos: .userInteractive).async {

                                            if #available(iOS 14, *) {

                                                let accessLevel: PHAccessLevel = .readWrite
                                                let status = PHPhotoLibrary.authorizationStatus(for: accessLevel)

                                                switch status {
                                                case .authorized:
                                                    imagePickerIsPresented.toggle()
                                                case .limited:
                                                    print("Limited access - show picker.")
                                                    imagePickerIsPresented.toggle()
                                                case .denied:
                                                    activeAlert = .photosAccessDenied
                                                    showAlert.toggle()
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
                                                    imagePickerIsPresented.toggle()
                                                case .denied:
                                                    activeAlert = .photosAccessDenied
                                                    showAlert.toggle()
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
                                        VStack {
                                            Image(systemName: "photo.fill.on.rectangle.fill")
                                                .resizable()
                                                .frame(width: 40, height: 32, alignment: .center)
                                                .padding(.bottom, 10)
                                            Text(openPhotosAppTextString).bold()
                                        }
                                    }
                                    .padding(.leading, geometry.size.width / 6)
                                    .sheet(isPresented: $imagePickerIsPresented, content: {

                                        //if #available(iOS 14, *) {
                                        ImagePicker_iOS14(imageToImport: $imageToClassify, isPresented: $imagePickerIsPresented, imageWasImported: $imageWasImported, presentAlert: $showAlert, activeAlert: $activeAlert, date: $imageDate, location: $imageLocation, imageHeight: $imageHeight, imageWidth: $imageWidth)
                                        //}
        //                                else {
        //                                    ImagePickeriOS13(isPresented: self.$imagePickerIsPresented, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, imageHeight: self.$imageHeight, imageWidth: self.$imageWidth, sourceType: "Photos") //FIXME: Change the way the source type is handled.
        //                                }
                                    })

                                    Spacer()

                                    Button(action: {
                                        imageSource = "iPhone Files app"
                                        filePickerIsPresented.toggle()
                                    }) {
                                        VStack {
                                            Image(systemName: "folder.fill")
                                                .resizable()
                                                .frame(width: 40, height: 32, alignment: .center)
                                                .padding(.bottom, 10)
                                            Text("Open Files").bold()
                                        }
                                    }
                                    .fileImporter(isPresented: $filePickerIsPresented, allowedContentTypes: [.jpeg, .png]) { res in

                                        do {
                                            let selectedFile: URL = try res.get()

                                            if selectedFile.startAccessingSecurityScopedResource() {
                                                let imageData = try Data(contentsOf: res.get())
                                                imageToClassify = UIImage(data: imageData)!
                                                imageWasImported = true

                                                do { selectedFile.stopAccessingSecurityScopedResource() }
                                            }

                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    .padding(.trailing, geometry.size.width / 6)
                                }
                                .padding(.top, geometry.size.height / 3)

                                HStack {

                                    Spacer()

                                    Button(action: {
                                        imageSource = "iPhone Camera"
                                        cameraIsPresented.toggle()
                                    }) {
                                        VStack {
                                            Image(systemName: "camera.on.rectangle.fill")
                                                .resizable()
                                                .frame(width: 40, height: 32, alignment: .center)
                                                .padding(.bottom, 10)
                                            Text(openCameraAppTextString).bold()
                                        }
                                    }
                                    .padding(.top, 25)
                                    .fullScreenCover(isPresented: $cameraIsPresented, content: {
                                        ImagePickeriOS13(isPresented: $cameraIsPresented, selectedImage: $imageToClassify, imageWasImported: $imageWasImported, date: $imageDate, location: $imageLocation, imageHeight: $imageHeight, imageWidth: $imageWidth, sourceType: "Camera").edgesIgnoringSafeArea(.all) //FIXME: Change the way the source type is handled.
                                    })

                                    Spacer()
                                }
                            }
                            else {

                                Spacer()

                                ImageToClassifyPlaceholder(image: imageToClassify)
                                    .opacity(imagePlaceholderIsVisible ? 1 : 0)
                                    .scaleEffect(imagePlaceholderIsVisible ? 1 : 0)
                                    .onAppear() {
                                        withAnimation(.easeIn(duration: 1)) {
                                            imagePlaceholderIsVisible.toggle()
                                        }
                                    }
                                    .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.4, alignment: .center)

                            }

                            Spacer()

                            VStack {

                                if !imageIsBeingClassified {

                                    Button(action: {

                                        imageIsBeingClassified.toggle()

                                        //Runs user initiated action of classifying the image.
                                        //Executed out of the main thread not to block the user interface.
                                        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2) {
                                            //TODO: What happens if the this is sync. Do I need the semaphore?

                                            //                                let newInference = ModelInference()
                                            let butterflyWasDetected = newInference.detectButterfly(receivedImage: imageToClassify)

                                            if butterflyWasDetected {
                                                runInference()
                                            }
                                            else {
                                                print("Butterfly not detected")
                                                activeAlert = .butterflyWasNotDetected
                                                showAlert.toggle()
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
                                    .disabled(imageWasImported == false)
                                    //If no image was imported the button is disabled.

                                    Button(action: {

                                        imageWasImported = false
                                        imagePlaceholderIsVisible.toggle()
                                    }) {
                                        Text("Clear")
                                    }
                                    .padding(.top, 10)
                                    .disabled(imageWasImported == false)
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
                        .navigationBarItems(trailing:
                            Button(action: { sheetIsPresented.toggle() }) {
                                Text("Dismiss")
                            }
                        )
                    }
                    //TODO: Change to show alert if the classification failed.
                    .alert(isPresented: $showAlert) {
                        switch activeAlert {
                        case .butterflyWasNotDetected:
                            return Alert(title: Text("Butterfly not detected"), message: Text("The ML Model was not able to detect a butterfly in your image. Therefore, results may not make sense for the content of your image. To obtain the best results make sure the subject of your observation is centered and visible in the image."), primaryButton: .default(Text("Cancel")) { sheetIsPresented.toggle()
                            }, secondaryButton: .destructive(Text("Proceed")) {
                                DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
                                    runInference() }
                            })
                        case .noResultsConfidenceThreshold:
                            return Alert(title: Text("No results for chosen confidence threshold."), message: Text("The confidence obtained for the observation was below the confidence threshold that was set. If you want to change it go to the \"Settings\" section of the app."), dismissButton: .default(Text("OK")) {
                                sheetIsPresented.toggle()
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
                else {
                    VStack {
                        ObservationDetails(sheetIsOpen: $sheetIsPresented, observation: observation!)
                            .environment(\.managedObjectContext, managedObjectContext)
                            .onAppear() {
                                print(classificationWasSuccessful)
                            }
                    }
                    .transition(.slide)
                    .animation(.easeInOut(duration: 1.5))
                }
            }
            .navigationTitle(Text(viewTitle))
            .navigationBarItems(trailing:
                Button(action: { sheetIsPresented.toggle() }) {
                    Text("Dismiss")
                }
            )
        }
    }

    func runInference() {

        //newInference.coreMLModelInference(receivedImage: self.imageToClassify)
        newInference.runInference(image: imageToClassify)

        DispatchQueue.main.async {
            print("DispathcQueue")

            if let topFiveResults = newInference.getResults() {

                //Label comes in the format eg. Vanessa_atalanta.
                //let labelComponents = topFiveResults[0].label.components(separatedBy: "_")
                //let finalLabel = labelComponents[0] + " " + labelComponents[1]
                let finalLabel = topFiveResults[0].label

                if UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int == nil {
                    UserDefaults.standard.setValue(0, forKey: "confidence_threshold_index")
                }

                guard let index = UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int else {
                    return
                }

                let chosenConfidenceThreshold = availableConfidence[index]
                let confidence = topFiveResults[0].confidence

                if confidence >= chosenConfidenceThreshold {

                    let newObservation = Observation(entity: Observation.entity(), insertInto: managedObjectContext)

                    newObservation.id = UUID()
                    newObservation.speciesName = finalLabel
                    newObservation.genus = String(finalLabel.split(separator: " ")[0])
                    newObservation.family = familyDictionary[finalLabel]
                    newObservation.confidence = confidence
                    newObservation.observationDate = Date()
                    newObservation.imageCreationDate = imageDate
                    newObservation.image = imageToClassify.jpegData(compressionQuality: 1.0)
                    newObservation.imageSource = imageSource
                    newObservation.imageHeight = Int16(imageHeight)
                    newObservation.imageWidth = Int16(imageWidth)
                    newObservation.isFavorite = false
                    newObservation.userNote = ""

                    if let latitude = imageLocation?.coordinate.latitude, let longitude = imageLocation?.coordinate.longitude {
                        newObservation.latitude = latitude
                        newObservation.longitude = longitude
                    }
                    else {
                        newObservation.latitude = -999
                        newObservation.longitude = -999
                    }

                    do {
                        try managedObjectContext.save()
                        observation = newObservation
                        //presentationMode.wrappedValue.dismiss()
                        classificationWasSuccessful = true
                        viewTitle = ""
                        //self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        activeAlert = .canNotSaveCoreData
                        showAlert.toggle()
                    }
                }
                else {
                    imageIsBeingClassified = false
                    imageWasImported = false
                    activeAlert = .noResultsConfidenceThreshold
                    showAlert.toggle()
                }
            }
        }
    }
}

private let openPhotosAppTextString: String = "Open Photos"
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

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
    
    @State var imageToClassify =  UIImage()
    @State var imagePickerIsPresented = false
    @State var isVibible = false
    @State var imageWasImported = false
    @State var showAlert = false
    
    @State var imageDate: Date?
    @State var imageLocation: CLLocation?
    
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
                            Text("Import photo from Photos")
                        }
                        .padding(.top, geometry.size.height / 2.5)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            ImagePickerView(isPresented: self.$isVibible, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Photos")
                        })
                    }
                    else {
                        Button(action: {
                            self.imagePickerIsPresented.toggle()
                        }) {
                            Text("Open the Camera app")
                        }
                        .padding(.top, geometry.size.height / 2.5)
                        .sheet(isPresented: self.$imagePickerIsPresented, content: {
                            ImagePickerView(isPresented: self.$isVibible, selectedImage: self.$imageToClassify, imageWasImported: self.$imageWasImported, date: self.$imageDate, location: self.$imageLocation, sourceType: "Camera")
                        })
                    }
                }
                else {
                    ImageToClassifyPlaceholder(image: self.imageToClassify)
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
                        let modelFile = FileInfo(name: "model", extension: "tflite")
                        let dict = FileInfo(name: "dict", extension: "txt")
                        
                        let model = ModelDataHandler(modelFileInfo: modelFile, labelsFileInfo: dict)
                        let image = CVPixelBuffer.buffer(from: self.imageToClassify)
                        
                        let results = model?.runModel(onFrame: image!)
                        print(results)
                        
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            let classification = Classification()
                            
                            DispatchQueue.global().sync {
                                if let classificationResults = classification.classifyImage(receivedImage: self.imageToClassify) {
                                    
                                    //print(classificationResults)
                                
                                    DispatchQueue.main.async {
                                        
                                        let labelComponents = classificationResults[0].label.components(separatedBy: "_")
                                        let finalLabel = labelComponents[0] + " " + labelComponents[1]
                                        
                                        let confidence = classificationResults[0].confidence
                                        
                                        let observation = Observation(speciesName: finalLabel, classificationConfidence: confidence, location: self.imageLocation, date: Date(), isFavorite: false, image: self.imageToClassify, time: "17:00")
                                        
                                        self.observation = observation
                                        self.records.addObservation(self.observation!)
                                    }
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
                    
                    Button(action: {
                        self.imageWasImported = false
                        self.isVibible.toggle()
                    }) {
                        Text("Clear")
                    }
                    .padding(.top, 15)
                    .disabled(self.imageWasImported == false)
                }
            }
            .navigationBarTitle(Text("New Observation"))
        }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Location Error"), message: Text("To create a new observation Imago needs to use your location"), primaryButton: .destructive(Text("Close")) { self.sheetIsPresented.toggle() }, secondaryButton: .cancel(Text("Continue")))
            }
    }
}

//struct SheetImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetImagePicker()
//    }
//}

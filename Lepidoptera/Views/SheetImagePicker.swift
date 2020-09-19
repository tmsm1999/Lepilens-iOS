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
                        
//                        let classification = Classification()
//                        classification.classifyImage(receivedImage: self.imageToClassify)
                        
//                        let model = FileInfo(name: "model", extension: "tflite")
//                        let labels = FileInfo(name: "dict", extension: "txt")
//                        let modelHandler = ModelDataHandler(modelFileInfo: model, labelsFileInfo: labels)
//
////                        let image = CIImage(image: self.imageToClassify)
////                        let pixelBuffer = CIContext.render(image!, to: CVPixelBuffer as! CVPixelBuffer)
//                        let image = CVImageBuffer.buffer(from: self.imageToClassify)
//                        let results = modelHandler?.runModel(onFrame: image!)
//
//                        if let results = results {
//                            let res = results.inferences
//                            for inference in res {
//                                print("Label: \(inference.label) | Accuracy: \(inference.confidence)")
//                            }
//                        }
//                        else {
//                            print("error!")
//                        }
                        
                        
                        
//                        let image = Image(uiImage: self.imageToClassify)
//                        
//                        let automl = AutoML()
//                        guard let output = try? automl.prediction(image__0: image as! CVPixelBuffer) else {
//                                   fatalError("Unexpected runtime error.")
//                               }
//                        
//                        print(output)
                        let classification = Classification()
                        let results = classification.classifyImage(receivedImage: self.imageToClassify)
                        print(results ?? "No results available")

                        //let observation = Observation(speciesName: (results.inferences[0].label)!, classificationConfidence: Double((results?.inferences[0].confidence)!), location: self.imageLocation, date: Date(), isFavorite: false, image: self.imageToClassify, time: "17:00")
                        
                        //self.observation = observation
                        //self.records.addObservation(self.observation!)
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

//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassifyImageSheet: View {
    
    @EnvironmentObject var records: ObservationRecords
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool //Sheet atual
    
    @State var observation: Observation? = nil
    @State var pickerIsVisible = true
    
    @State var dismissModalView: Bool = false
    
    var importImageFromPhotos: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if self.observation == nil {
                    SheetImagePicker(observation: self.$observation, importImageFromPhotos: self.importImageFromPhotos).environmentObject(self.records)
                }
                else {
                    //ObservationDetails(records: observation!).environmentObject(self.records)
                    ObservationDetails(dismissModalView: self.$isPresented, observation: observation!).environmentObject(self.records)
                }
            }
                
            .navigationBarItems(trailing:
                Button(action: { self.isPresented.toggle() }) {
                    Text("Dismiss")
                }
            )
        }
    }
}

struct SheetImagePicker: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    @State var imageToClassify =  UIImage()
    @State var imagePickerIsPresented = false
    @State var isVibible = false
    @State var imageWasImported = false
    
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
                            ImagePickerView(
                                isPresented: self.$imagePickerIsPresented,
                                selectedImage: self.$imageToClassify,
                                imageWasImported: self.$imageWasImported)
                        })
                    }
                    else {
                        Button(action: {
                            self.imageWasImported.toggle()
                        }) {
                            Text("Open the Camera app")
                        }
                        .padding(.top, geometry.size.height / 2.5)
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
                    //                            .transition(AnyTransition.slide)
                    //                            .animation(.default)
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        self.observation = self.createObservation()
                        self.records.addObservation(self.observation!)
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
    }
    
    func createObservation() -> Observation {
        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: 34.011286, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: imageToClassify, time: "17:00")
        
        return observation
    }
}

//struct ClassifyImageSheet_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
//
//        return ClassifyImageSheet(isPresented: .constant(true), importImageFromPhotos: false, observation: observation)
//    }
//}

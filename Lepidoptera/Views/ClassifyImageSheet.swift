//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassifyImageSheet: View {
    
    @Binding var isPresented: Bool //Sheet atual
    
    @State var imagePickerIsPresented = false
    @State var imageWasImported = false
    
    @State var imageToClassify =  UIImage()
    
    var importImageFromPhotos: Bool
    
    @EnvironmentObject var records: ObservationRecords
    
    @State var observation: Observation? = nil
    @State var showResult = false
    
    //Animation properties for image
    @State var isVibible = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationView {
                
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
                            self.showResult.toggle()
                            //self.isPresented.toggle()
                            //                            NavigationLink(destination: ObservationDetails(observation: observation).environmentObject(self.records)) {
                            //                                EmptyView()
                            //                            }
                            //print(self.records.record.count)
                        }) {
                            Text("Classify")
                                .padding([.top, .bottom], 12)
                                .padding([.leading, .trailing], 30)
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 60, style: .continuous))
                        }
                        .disabled(self.imageWasImported == false)
                        .sheet(isPresented: self.$showResult) {
                            if self.observation != nil {
                                ViewWithNavigationLink(observation: self.observation!, isPresented: self.$showResult, parentIsPresented: self.$isPresented).environmentObject(self.records)
                            }
                        }
                        
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
                .navigationBarItems(trailing:
                    
                    Button(action: { self.isPresented.toggle() }) {
                        Text("Cancel")
                    }
                )
            }
        }
    }
    
    func createObservation() -> Observation{
        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: 34.011286,
                                      longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: imageToClassify, time: "17:00")
        
        return observation
    }
}

struct ViewWithNavigationLink: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    var observation: Observation
    @Binding var isPresented: Bool
    @Binding var parentIsPresented: Bool
    
    var body: some View {
        
        NavigationView {
            NavigationLink(destination: ObservationDetails(observation: observation)) {
                ObservationDetails(observation: observation).environmentObject(records)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .onDisappear() {
                self.parentIsPresented.toggle()
            }
            .navigationBarItems(trailing:
                
                Button(action: { self.isPresented.toggle() }) {
                    Text("Cancel")
                }
            )
        }
        
//        ObservationDetails(observation: observation).environmentObject(records)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.all)
//            .onDisappear() {
//                self.parentIsPresented.toggle()
//        }
    }
}

struct ClassifyImageSheet_Previews: PreviewProvider {
    static var previews: some View {
        
        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
        
        return ClassifyImageSheet(isPresented: .constant(true), importImageFromPhotos: false, observation: observation)
    }
}

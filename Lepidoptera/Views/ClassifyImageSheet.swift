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
                                //self.imagePickerIsPresented.toggle()
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
                        Button(action: { return } ) {
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
                    
                .navigationBarItems(trailing:
                    
                    Button(action: { self.isPresented.toggle() }) {
                        Text("Cancel")
                    }
                )
            }
        }
    }
}

struct ClassifyImageSheet_Previews: PreviewProvider {
    static var previews: some View {
        ClassifyImageSheet(isPresented: .constant(true), importImageFromPhotos: false)
    }
}

//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassifyImageSheet: View {
    
    @Binding var isPresented: Bool
    @State var imageWasImported = false
    
    var importImageFromPhotos: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
        
            NavigationView {
                
                VStack {
                    Button(action: {
                        self.imageWasImported.toggle()
                    }) {
                        if(self.importImageFromPhotos) {
                            Text("Import photo from Photos")
                        }
                        else {
                            Text("Open Camera app")
                        }
                    }
                    .padding(.top, geometry.size.height / 2.5)
                    
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
                        
                        Button(action: { return } ) {
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

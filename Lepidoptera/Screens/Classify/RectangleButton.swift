//
//  RectangleButton.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 31/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Rectangle View that contains buttons to import image from Photos or open the Camera app to take a picture.
struct RectangleButton: View {
    
    ///String inside the button
    var buttonString: String
    ///Image from the assets folder that is the background for the rectangle.
    var imageTitle: String
    ///There are two different options: Photos or Camera.
    var action: String
    
    ///Controls the child modal view and stores if it is open or closed.
    @State var sheetIsOpen: Bool = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Button(action: { self.sheetIsOpen.toggle() } ) {
                        Text(self.buttonString)
                            .padding([.top, .bottom], 9)
                            .padding([.leading, .trailing], 16)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 60, style: .continuous))
                    }
                    .sheet(isPresented: self.$sheetIsOpen, content: {
                        
                        if self.action == "Photos" {
                            NewClassificationController(importFromPhotos: true, isPresented: $sheetIsOpen)
                                .environment(\.managedObjectContext, self.managedObjectContext)
                        }
                        else {
                            NewClassificationController(importFromPhotos: false, isPresented: $sheetIsOpen)
                                .environment(\.managedObjectContext, self.managedObjectContext)
                        }
                    })
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.leading, 20)
            }
            .background(
                Image(self.imageTitle)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill()
                    .opacity(0.85))
            
            .border(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), width: 2.3)
            .cornerRadius(4.3)
        }
    }
}

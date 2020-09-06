//
//  RectangleButton.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 31/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct RectangleButton: View {
    
    var buttonString: String
    var imageTitle: String
    var action: String
    
    @State var sheetIsOpen: Bool = false
    
    @EnvironmentObject var records: ObservationRecords
    
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
                            ClassifyImageSheet(isPresented: self.$sheetIsOpen, importImageFromPhotos: true)
                                .environmentObject(self.records)
                        }
                        else {
                            ClassifyImageSheet(isPresented: self.$sheetIsOpen, importImageFromPhotos: false)
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
                .border(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), width: 2)
                .cornerRadius(10)
        }
    }
    
    func openSheetWithPhoto() {
        return
    }
}

struct RectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
    }
}

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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
//                HStack {
//                    Text(self.buttonString)
//                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
//                        .font(.system(size: 22, weight: .semibold, design: .rounded))
//                    Spacer()
//                }
//                .padding(.bottom, 30)
//                .padding(.leading, 30)
                
                HStack {
                    Button(action: { self.openSheetWithPhoto() } ) {
                        Text(self.buttonString)
                            .padding([.top, .bottom], 12)
                            .padding([.leading, .trailing], 20)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 60, style: .continuous))
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                .padding(.leading, 20)
            }
            .background(
                Image(self.imageTitle)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill())
                .border(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), width: 2)
                .cornerRadius(10)
//            .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
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

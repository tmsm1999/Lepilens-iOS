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
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: self.imageTitle)
                    .padding(.top, 50)
                    .font(.system(size: geometry.size.width * 0.20))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                Spacer()
                HStack {
                    Text(self.buttonString)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                    Spacer()
                }
                .padding(.bottom, 30)
                .padding(.leading, 30)
            }
            .background(Color(#colorLiteral(red: 0.1563231496, green: 0.476623018, blue: 1, alpha: 0.750137544)))
            .border(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), width: 4)
            .cornerRadius(10)
        }
        
    }
}

struct RectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RectangleButton(buttonString: "Import from Photos", imageTitle: "photo")
    }
}

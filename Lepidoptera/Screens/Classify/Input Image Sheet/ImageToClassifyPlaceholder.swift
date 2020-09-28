//
//  ImageToClassifyPlaceholder.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///View that shows the image avout to be classified in the sheet with the classify button.
struct ImageToClassifyPlaceholder: View {
    
    @State var image: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Image(uiImage: self.image)
                    .resizable()
                    .scaledToFit()
                Spacer()
            }
        }
    }
}

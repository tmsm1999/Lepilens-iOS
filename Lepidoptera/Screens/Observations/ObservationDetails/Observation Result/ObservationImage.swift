//
//  ObservationImage.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Circular image visible in  the result view of an observation.
struct ObservationImage: View {
    
    var image: UIImage
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 180, height: 180, alignment: .center)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }
}

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
        
        //GeometryReader { geometry in
            
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
//                .frame(width: geometry.size.height / 3.5, height: geometry.size.height / 3.5, alignment: .center)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
        //}
    }
}

//
//  ObservationImage.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ObservationImage: View {
    
    var imageName: String
    
    var body: some View {
        
        Image(imageName)
            .resizable()
            .frame(width: 180, height: 180, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }
}

struct ObservationImage_Previews: PreviewProvider {
    static var previews: some View {
        ObservationImage(imageName: "aglais_io")
    }
}

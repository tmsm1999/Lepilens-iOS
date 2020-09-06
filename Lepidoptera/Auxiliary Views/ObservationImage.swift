//
//  ObservationImage.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ObservationImage: View {
    
    var image: UIImage
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .frame(width: 180, height: 180, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }
}

struct ObservationImage_Previews: PreviewProvider {
    static var previews: some View {
        ObservationImage(image: UIImage(named: "aglais_io")!)
    }
}

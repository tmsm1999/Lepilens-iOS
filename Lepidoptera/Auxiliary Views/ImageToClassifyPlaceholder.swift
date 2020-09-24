//
//  ImageToClassifyPlaceholder.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

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

struct ImageToClassifyPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        ImageToClassifyPlaceholder(image: UIImage(named: "aglais_io")!)
    }
}

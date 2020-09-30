//
//  Paragraph.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 30/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct Paragraph: View {
    @State var text: String = "This is a paragraph"
    
    var body: some View {
        //GeometryReader { geometry in
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Spacer()
                Text(text)
                    .fontWeight(.regular)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.center)
                    //.frame(width: geometry.size.width * 0.92, alignment: .leading)
                Spacer()
            }
        //}  
    }
}
    

struct Paragraph_Previews: PreviewProvider {
    static var previews: some View {
        Paragraph()
    }
}

//
//  Paragraph.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 30/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct Title: View {
    
    @State var text: String = "This is a paragraph"
    
    var body: some View {
//        GeometryReader { geometry in
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Text(text)
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .frame(alignment: .leading)
                Spacer()
            }
        //}
    }
}

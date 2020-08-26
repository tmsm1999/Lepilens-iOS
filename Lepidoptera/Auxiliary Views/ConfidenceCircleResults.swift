//
//  ConfidenceCircleResults.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 15/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ConfidenceCircleResults: View {
    
    var confidence: Double
    @State var show = false
    
    var body: some View {
        
        ZStack {
            Circle()
                .trim(from: show ? (1 - CGFloat(confidence)) : 0.99, to: 1)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x:1, y: 0, z: 0))
                .frame(width: 75, height: 75, alignment: .center)
                .animation(.easeOut(duration: 1.7))
                .onAppear() {
                    self.show.toggle()
            }
            
            Text(String(confidence * 100) + "%")
                .fontWeight(.semibold)
                .font(.system(size: 15))
        }
            .padding(10)
    }
}

struct ConfidenceCircleResults_Previews: PreviewProvider {
    static var previews: some View {
        ConfidenceCircleResults(confidence: 0.85)
    }
}

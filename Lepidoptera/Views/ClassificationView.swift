//
//  ClassificationView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct ClassificationView: View {

    @EnvironmentObject var records: ObservationRecords
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 50) {
                    RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                        .environmentObject(self.records)
                        .shadow(color: Color.gray, radius: 20)
                    
                    
                    RectangleButton(buttonString: "Take a photo", imageTitle: "taking_photo_camera", action: "Camera")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center).environmentObject(self.records)
                    .shadow(color: Color.gray, radius: 20)
                    
                    Spacer()
                }
                .padding(.top, 40)
                    
                .navigationBarTitle(Text("Classify"))
            }
        }
    }
}

struct ClassificationView_Previews: PreviewProvider {
    static var previews: some View {
        ClassificationView()//.environmentObject(ObservationRecords())
    }
}

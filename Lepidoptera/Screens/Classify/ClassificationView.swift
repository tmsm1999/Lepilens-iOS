//
//  ClassificationView.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 14/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Application main view that allows the user to start an observation.
///In this view the user can choose between importing an image from the Photos app or use the camera.
struct ClassificationView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: 50) {
                    RectangleButton(buttonString: "Import from Photos", imageTitle: "ImportFromPhotosRect", action: "Photos")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                        .shadow(color: Color.gray, radius: 20)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                    
                    
                    RectangleButton(buttonString: "Take a photo", imageTitle: "taking_photo_camera", action: "Camera")
                        .frame(width: geometry.size.width * 0.75, height: geometry.size.height * 0.3, alignment: .center)
                        .shadow(color: Color.gray, radius: 20)
                        .environment(\.managedObjectContext, self.managedObjectContext)
                    
                    Spacer()
                }
                .padding(.top, 40)
                
                .navigationBarTitle(Text("Classify"))
            }
        }
    }
}

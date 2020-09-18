//
//  ClassifyImageSheet.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 06/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import Photos

struct NewClassificationSheet: View {
    
    @EnvironmentObject var records: ObservationRecords
    //@Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool //Sheet atual
    
    @State var observation: Observation?
    @State var pickerIsVisible = true
    @State var dismissModalView: Bool = false
    
    var importImageFromPhotos: Bool
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if self.observation == nil {
                    SheetImagePicker(sheetIsPresented: self.$isPresented, observation: self.$observation, importImageFromPhotos: self.importImageFromPhotos)
                }
                else {
                    ObservationDetails(dismissModalView: self.$isPresented, observation: observation!).environmentObject(self.records)
                        .transition(.slide)
                        .animation(.linear(duration: 1))
                }
            }
                
            .navigationBarItems(trailing:
                Button(action: { self.isPresented.toggle() }) {
                    Text("Dismiss")
                }
            )
        }
    }
}

//struct ClassifyImageSheet_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let observation = Observation(speciesName: "Aglais io", classificationConfidence: 0.70, latitude: -116.166868, longitude: -116.166868, date: "02/02/1999", isFavorite: false, image: UIImage(named: "aglais_io")!, time: "17:00")
//
//        return ClassifyImageSheet(isPresented: .constant(true), importImageFromPhotos: false, observation: observation)
//    }
//}

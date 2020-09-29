//
//  More.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 28/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct More: View {
    
    @EnvironmentObject var records: ObservationRecords
    
    let availableConfidence = [0.1, 0.25, 0.5, 0.75, 1]
    let precision = [70.98, 85.82, 94.06, 97.66, 100]
    let recall = [89.29, 81.65, 72.22, 57.94, 0.69]
    
    @State var availableConfidenceIndex: Int = 0
    @State var showConfidencePicker = false
    
    @State var showDeleteDataAlert: Bool = false
    
    var includeLocation = Binding<Bool>(
        get: { UserDefaults.standard.bool(forKey: "include_location") },
        set: { UserDefaults.standard.set($0, forKey: "include_location") })
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("ML Model"), footer: Text("The selected Confidence threshold affects the overall precision and recall of the model. A high precision produces fewer false positives. A high recall produces fewer false negatives.")) {
                    
                    HStack {
                        Text("Precision")
                        Spacer()
                        Text(String(format: "%.2f", self.precision[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Recall")
                        Spacer()
                        Text(String(format: "%.2f", self.recall[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Confidence threshold")
                        Spacer()
                        Text(String(format: "%.2f", self.availableConfidence[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.showConfidencePicker.toggle()
                            }
                        }
                    
                    if showConfidencePicker {
                        Picker("Minimum Confidence", selection: self.$availableConfidenceIndex) {
                            
                            ForEach(0 ..< availableConfidence.count) {
                                Text(String(format: "%.2f", self.availableConfidence[$0]))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onDisappear() {
                            print("Confidence saved")
                            UserDefaults.standard.setValue(self.availableConfidenceIndex, forKey: "confidence_threshold_index")
                        }
                    }
                }
                .onAppear() {
                    
                    guard let confidenceThresholdIndex = UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int else {
                        return
                    }
                    
                    self.availableConfidenceIndex = confidenceThresholdIndex
                }
                
                Section(header: Text("Location"), footer: Text("The app uses your current location or the location metadata in photos only when performing a classiifcation.")) {
                    
                    Toggle(isOn: includeLocation) {
                        Text("Include Location")
                    }
                }
                
                Section(header: Text("Observation Data"), footer: Text("Your data is yours. It never leaves your device or your iCloud account.")) {
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Export observation data")
                        }
                    }
                    
                    Button(action: {
                        self.showDeleteDataAlert.toggle()
                    }) {
                        HStack {
                            Image(systemName: "trash.fill").foregroundColor(Color.red)
                            Text("Delete all observation data")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                
                Section(header: Text("This application")) {
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        label: {
                            Text("About")
                        })
                    
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        label: {
                            Text("Privacy Policy")
                        })
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/tmsm1999/lepidoptera-ios-project") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left.slash.chevron.right")
                            Text("View source code")
                            
                        }
                    }
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Contact the Developer")
                            
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Settings"))
        }
        .alert(isPresented: $showDeleteDataAlert) {
            Alert(title: Text("Delete all data"), message: Text("Are you sure you want to delete all observations and associated data?"), primaryButton: .destructive(Text("Yes")) { self.records.record.removeAll() }, secondaryButton: .cancel(Text("No")))
        }
    }
}

struct More_Previews: PreviewProvider {
    static var previews: some View {
        More(availableConfidenceIndex: 0)
    }
}

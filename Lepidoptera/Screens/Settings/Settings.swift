//
//  More.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 28/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI
import MessageUI
import StoreKit

let availableConfidence = [0.1, 0.25, 0.5, 0.75, 1]
let precision = [70.98, 85.82, 94.06, 97.66, 100]
let recall = [89.29, 81.65, 72.22, 57.94, 0.69]

enum AlertType {
    case deleteAllData,
         canNotSendEmail
}

struct Settings: View {
    
    @FetchRequest(entity: Observation.entity(), sortDescriptors: []) var observationList: FetchedResults<Observation>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var availableConfidenceIndex: Int = 0
    @State var showConfidencePicker = false
    
    @State var showDeleteDataAlert: Bool = false
    
    var includeLocation = Binding<Bool>(
        get: { UserDefaults.standard.bool(forKey: "include_location") },
        set: { UserDefaults.standard.set($0, forKey: "include_location") })
    
    
    @State var emailErrorAlert: Bool = false
    
    @State var showAlert: Bool = false
    @State var showEmailComposer: Bool = false
    
    @State var activeAlert: AlertType?
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("ML Model"), footer: Text("The selected Confidence threshold affects the overall precision and recall of the model. A high precision produces fewer false positives. A high recall produces fewer false negatives.")) {
                    
                    HStack {
                        Text("Precision")
                        Spacer()
                        Text(String(format: "%.2f", precision[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Recall")
                        Spacer()
                        Text(String(format: "%.2f", recall[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Confidence threshold")
                        Spacer()
                        Text(String(format: "%.2f", availableConfidence[self.availableConfidenceIndex])).fontWeight(.regular)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.showConfidencePicker.toggle()
                        }
                    }
                    
                    if showConfidencePicker {
                        Picker("Minimum Confidence", selection: self.$availableConfidenceIndex) {
                            
                            ForEach(0 ..< availableConfidence.count) {
                                Text(String(format: "%.2f", availableConfidence[$0]))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .onDisappear() {
                            print("Confidence saved")
                            UserDefaults.standard.setValue(availableConfidenceIndex, forKey: "confidence_threshold_index")
                        }
                    }
                }
                .onAppear() {
                    
                    guard let confidenceThresholdIndex = UserDefaults.standard.value(forKey: "confidence_threshold_index") as? Int else {
                        return
                    }
                    
                    self.availableConfidenceIndex = confidenceThresholdIndex
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
                        self.activeAlert = .deleteAllData
                        self.showAlert.toggle()
                        
                    }) {
                        HStack {
                            Image(systemName: "trash.fill").foregroundColor(Color.red)
                            Text("Delete all observation data")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                
                Section(header: Text("Location"), footer: Text("Pressing the toggle does not change your location settings. It only tells the app whether you want to include location in the next observation. The app uses your current location or the location metadata in photos only when performing a classification.")) {
                    
                    Button(action: {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Image(systemName: "location.fill")
                            Text("Change Location Settings")
                            
                        }
                    }
                    
                    Toggle(isOn: includeLocation) {
                        Text("Include Location")
                    }
                }
                
                Section(header: Text("Photos"), footer: Text("Every classification requires a photo. You can manage the type of access the app has to your photos.")) {
                    
                    Button(action: {
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text("Change Photos Settings")
                            
                        }
                    }
                }
                
                Section(header: Text("This application")) {
                    
                    NavigationLink(
                        destination: PrivacyPolicyScreen(),
                        label: {
                            Text("About")
                        })
                    
                    NavigationLink(
                        destination: PrivacyPolicyScreen(),
                        label: {
                            Text("Privacy Policy")
                        })
                    
                    Button(action: {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }) {
                        HStack {
                            Image(systemName: "star.square.fill")
                            Text("Rate & Review")
                            
                        }
                    }
                    
                    Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                            self.showEmailComposer.toggle()
                        }
                        else {
                            self.activeAlert = .canNotSendEmail
                            self.showAlert.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Contact Developer")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1").fontWeight(.regular)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://github.com/tmsm1999/lepidoptera-ios-project") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left.slash.chevron.right")
                            Text("View Source Code")
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .deleteAllData:
                return Alert(title: Text("Delete all data"), message: Text("Are you sure you want to delete all observations and associated data?"), primaryButton: .destructive(Text("Yes")) {
                    
                    for observation in observationList {
                        self.managedObjectContext.delete(observation)
                    }
                    
                    try? self.managedObjectContext.save()
                    
                }, secondaryButton: .cancel(Text("No")))
            case .canNotSendEmail:
                return Alert(title: Text("Can't send email"), message: Text("Please check your iPhone Settings and make sure you have an active email client."), dismissButton: .default(Text("OK")))
            default:
                return Alert(title: Text(""))
            }
        }
        .sheet(isPresented: self.$showEmailComposer) {
            SendEmailSheet(emailError: self.$emailErrorAlert)
        }
    }
}

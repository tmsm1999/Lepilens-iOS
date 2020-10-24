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
import UniformTypeIdentifiers

let availableConfidence = [0.1, 0.25, 0.5, 0.75, 1]
let precision = [70.98, 85.82, 94.06, 97.66, 100]
let recall = [89.29, 81.65, 72.22, 57.94, 0.69]

enum AlertType {
    case deleteAllData,
         canNotSendEmail
}

struct Settings: View {
    
//    @FetchRequest(entity: Observation.entity(), sortDescriptors: []) var observationList: FetchedResults<Observation>
    @FetchRequest(entity: Observation.entity(), sortDescriptors: [NSSortDescriptor(key: "observationDate", ascending: false)]) var observationList: FetchedResults<Observation>
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
    @State var presentExportCSV: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("ML Model"), footer: Text("The selected Confidence threshold affects the overall precision and recall of the model. A high precision produces fewer false positives. A high recall produces fewer false negatives.")) {
                    
                    HStack {
                        Text("Precision")
                        Spacer()
                        Text(String(format: "%.2f", precision[availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Recall")
                        Spacer()
                        Text(String(format: "%.2f", recall[availableConfidenceIndex])).fontWeight(.regular)
                    }
                    
                    HStack {
                        Text("Confidence threshold")
                        Spacer()
                        Text(String(format: "%.2f", availableConfidence[availableConfidenceIndex])).fontWeight(.regular)
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showConfidencePicker.toggle()
                        }
                    }
                    
                    if showConfidencePicker {
                        Picker("Minimum Confidence", selection: $availableConfidenceIndex) {
                            
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
                    
                    availableConfidenceIndex = confidenceThresholdIndex
                }
                
                Section(header: Text("Observation Data"), footer: Text("Your data is yours. It never leaves your device or your iCloud account.")) {
                    Button(action: {
                        presentExportCSV.toggle()
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("Export observation data")
                        }
                    }
                    
                    Button(action: {
                        activeAlert = .deleteAllData
                        showAlert.toggle()
                        
                    }) {
                        HStack {
                            Image(systemName: "trash.fill").foregroundColor(Color.red)
                            Text("Delete all observation data")
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .accentColor(.blue)
                
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
                .accentColor(.blue)
                
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
                .accentColor(.blue)
                
                Section(header: Text("This application")) {
                    
                    NavigationLink(
                        destination: AboutScreen(),
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
                            showEmailComposer.toggle()
                        }
                        else {
                            activeAlert = .canNotSendEmail
                            showAlert.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Contact Developer")
                        }
                    }
                }
                .accentColor(.blue)
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1").fontWeight(.regular)
                    }
                    
//                    Button(action: {
//                        if let url = URL(string: "https://github.com/tmsm1999/lepidoptera-ios-project") {
//                            UIApplication.shared.open(url)
//                        }
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left.slash.chevron.right")
//                            Text("View Source Code")
//
//                        }
//                    }
                }
                .accentColor(.blue)
            }
            .navigationBarTitle(Text("Settings"))
        }
        .alert(isPresented: $showAlert) {
            switch activeAlert {
            case .deleteAllData:
                return Alert(title: Text("Delete all data"), message: Text("Are you sure you want to delete all observations and associated data?"), primaryButton: .destructive(Text("Yes")) {
                    
                    for observation in observationList {
                        managedObjectContext.delete(observation)
                        
                        do {
                            try managedObjectContext.save()
                        } catch {
                            print("Can't delete from Core Data.")
                        }
                    }
                }, secondaryButton: .cancel(Text("No")))
            case .canNotSendEmail:
                return Alert(title: Text("Can't send email"), message: Text("Please check your iPhone Settings and make sure you have an active email client."), dismissButton: .default(Text("OK")))
            default:
                return Alert(title: Text(""))
            }
        }
        .sheet(isPresented: $showEmailComposer) {
            SendEmailSheet(emailError: $emailErrorAlert)
        }
        .fileMover(isPresented: $presentExportCSV, file: createFolderURL()!) { res in
            switch res {
            case .success(let url):
                print(url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createFolderURL() -> URL? {
            
        let fileManager = FileManager.default
        //Get apps document directory
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        //Create folder with obseravtion data
        let folderName = "Observations Data"
        let dataDirectory = path[0].appendingPathComponent("\(folderName)", isDirectory: true)
        try? fileManager.createDirectory(at: dataDirectory.absoluteURL, withIntermediateDirectories: true, attributes: nil)
        
        //Create folder with all images
        let imagesFolder = "Observation Images"
        let imagesDirectory = dataDirectory.appendingPathComponent("\(imagesFolder)", isDirectory: true)
        try? fileManager.createDirectory(at: imagesDirectory.absoluteURL, withIntermediateDirectories: true, attributes: nil)
        
        for observation in observationList {
            
            let image = UIImage(data: observation.image!)
            
            do {
                let imageName = observation.id!.description
                let imageURL = imagesDirectory.appendingPathComponent("\(imageName)" + ".jpeg")
                try image?.jpegData(compressionQuality: 1.0)?.write(to: imageURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let csvFileURL = dataDirectory.appendingPathComponent("Observation data.csv")
        let csvFile = createCSVFile()
        
        do {
            try csvFile?.write(to: csvFileURL, atomically: true, encoding: .utf16)
        } catch {
            print(error.localizedDescription)
        }
        
        return dataDirectory
    }
    
    func createCSVFile() -> String? {
        
        var csvString = "Observation ID;Date;Time;Latitude;Longitude;Family;Genus;Species;Confidence;Image Creation Date;Image Height;Image Width;Image Source;User Note"
        
        for observation in observationList {
            
            csvString.append("\n")
            
            let observationID = observation.id!
            let date = formatDate(date: observation.observationDate!)
            let time = formatTime(date: observation.observationDate!)
            let latitude = observation.latitude != -999 ? String(observation.latitude) : "Location not available"
            let longitude = observation.longitude != -999 ? String(observation.longitude) : "Location not available"
            let family = observation.family ?? "Not found"
            let genus = observation.genus ?? "Not found"
            let species = observation.speciesName!
            let confidence = String(observation.confidence)
            let imageCreationDate = observation.imageCreationDate != nil ? formatDate(date: observation.imageCreationDate!) : "Not available"
            let imageHeight = observation.imageHeight
            let imageWidth = observation.imageWidth
            let imageSource = observation.imageSource!
            let userNote = observation.userNote

            let row = "\(observationID);\(date);\(time);\(latitude);\(longitude);\(family);\(genus);\(species);\(confidence);\(imageCreationDate);\(imageHeight);\(imageWidth);\(imageSource);\(userNote ?? "")"
            
            csvString.append(row)
        }
        
        return csvString
    }
}

//struct FolderExport: FileDocument {
//
//    var url: URL
//
//    static var readableContentTypes: [UTType] {[.folder]}
//
//    init(url: URL) {
//        self.url = url
//    }
//
//    init(configuration: ReadConfiguration) throws {
//        url = URL(string: "")!
//    }
//
//    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//
//        print("Aqui: \(url)")
//        let file = try! FileWrapper(url: url, options: .immediate)
//        return file
//    }
//}

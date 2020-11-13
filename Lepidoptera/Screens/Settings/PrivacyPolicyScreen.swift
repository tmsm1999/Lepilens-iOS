//
//  PrivacyPolicyScreen.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 30/09/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct PrivacyPolicyScreen: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack {
                
                HStack {
                    Text("General")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                
                Text("I care about your privacy and I take it very seriously. I don’t want nor need to know anything about you or your personal data. Your personal data is yours and I have designed Lepilens to use as little of your personal data as possible and to ensure that the data used remains yours and under your control. I don’t want the responsibility of managing and protecting your data, so I don’t collect it. Therefore, your personal data never leaves your device and I will never have information about you or what you do within the app.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("Lepilens can only access personal data that you allow access to. This includes photos from your Photo Library or the Files app and associated metadata, photos you take while using the app and associated metadata and your location while using the app. The only photo metadata used is creation date of the photo and the location where the photo was captured - if available.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("In order to allow access to your Photo Library, to your camera or your location you have to grant it. Before using any of these for the first time Lepilens will explicitly ask for your consent and will only access your Photo Library, use your Camera or access your current location or the location associated to your photos if you allow it.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("To perform a classification a photo is always required. You can choose to import the photo from your Photos Library, the Files app or to take a photo from within the app using your iPhone camera. If the photo was imported from your Photo Library or the Files app Lepilens will use the creation date of the photo and the location matadata if these are available. If the photo is taken from the app using your camera the app will use your current location if you allow it.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("The photo is then passed to a Machine Learning Classifier trained and generate using Google Cloud Platform and AutoML Vision that runs only on your device and without requiring Internet access. Lepilens uses Google's GoogleMLKit/ImageLabelingAutoML CocoaPod to run inference on the model. After your photo is processed by the model the results associated to the operation do not leave your device. ")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack {
                
                HStack {
                    Text("Personally Identifying Information")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("Lepilens does not gather or transmit any Personally Identifying Information outside of your local device. It only stores data and app settings within the local database.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack {
                
                HStack {
                    Text("Privacy Policy changes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("Although most changes are likely to be minor, Lepilens may change its Privacy Polity from time to time at its sole discretion. Your continued use of this app after any change in its Privacy Policy will constitute your acceptance of such change.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack {
                
                HStack {
                    Text("Indemnity")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("You hereby indemnify me, Tomás Santiago, creator of Lepilens, and undertake to keep me indemnified against any losses, damages, costs, liabilities and expenses incurred or suffered by you arising out of use of this app or any breach by you of any provision of these terms of use, or arising out of any claim that you have breached any provision of these terms of use.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitle("Privacy Policy")
    }
}

struct PrivacyPolicyScreen_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyScreen()
    }
}

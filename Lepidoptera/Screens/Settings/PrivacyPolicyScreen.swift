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
                
                Text("I care about your privacy and I take it very seriously. I don’t want nor need to know anything about you or your personal data. Your personal data is yours and I have designed this app to use as little of your personal data as possible and to ensure that the data used remains yours and under your control.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("I care about your privacy and I take it very seriously. I don’t want nor need to know anything about you or your personal data. Your personal data is yours and I have designed this app to use as little of your personal data as possible and to ensure that the data used remains yours and under your control.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("I don’t want the responsibility of managing your data correctly, so I don’t collect it. Therefore, your personal data never leaves your device and I will never have information about you or what you do within the app.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("In order to allow access to your Photo Library, to your camera or your location you must grant it. Before using any of these for the first time the app will explicitly ask for your consent and will only access your Photo Library, use your Camera or access your current location or the location associated to your photos if you allow it.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("I care about your privacy and I take it very seriously. I don’t want nor need to know anything about you or your personal data. Your personal data is yours and I have designed this app to use as little of your personal data as possible and to ensure that the data used remains yours and under your control.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("To perform a classification a photo is always required. You can choose to import the photo from your Photos Library or to take a photo from the app using your camera and import it directly to the app. If the photo was imported from your Photo Library the app will use the creation date of the photo and the location if these are available. If the photo is taken from the app using your camera the app will use your current location.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("The photo is passed to a Machine Learning Classifier trained and generate using Google Cloud Platform and AutoML Vision that runs only on your device and without requiring Internet access. After your photo is processed by the model the results associated to the operation do not leave your device.")
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
                
                Text("This app does not gather or transmit any Personally Identifying Information outside of your local device. It only stores data and app settings within the local database.")
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
                
                Text("Although most changes are likely to be minor, this may change its Privacy Polity from time to time at its sole discretion. Your continued use of this app after any change in its Privacy Policy will constitute your acceptance of such change.")
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
                
                Text("You hereby indemnify me and undertake to keep me indemnified against any losses, damages, costs, liabilities and expenses (including, without limitation, legal expenses and any amounts paid by us to a third party in settlement of a claim or dispute on the advice of our legal advisers) incurred or suffered by you arising out of use of this app or any breach by you of any provision of these terms of use, or arising out of any claim that you have breached any provision of these terms of use.")
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

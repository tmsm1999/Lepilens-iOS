//
//  AboutScreen.swift
//  Lepidoptera
//
//  Created by Tomás Mamede on 18/10/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("The Developer")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("Hello! 🙂 My name is Tomás Santiago Mamede. I am 21 years old and I am a Portuguese student at the Faculty of Sciences of the University of Porto pursing a Master's Degree in Computer Science. In August 2020 I finished the Bachelor's Degree in Computer Science from the same institution.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("I love Computer Science and Science in general. The areas that I am most interested in are Artificial Intelligence, Human-Computer Interaction and Software Engineering. I enjoy working at the intersection of Computer Science, Science and the Humanities. I love running, playing tennis and listening to music.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("How Lepilens came to be?")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                
                VStack {
                    
                    Text("In March 2020, in the final semester of my Computer Science Degree I enrolled in a course called Project, which can be thought as an Introduction to Scientific Research. Since the very beginning it was my desire to work in Artificial Intelligence and I was very fortunate in finding a project proposal that I loved. It had the title of “Classification of images of butterflies using Deep Learning”.")
                        .fontWeight(.regular)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 10)
                }
                
                Text("From March to June I worked with Professor Luís B. Lopes and Professor Eduardo R. B. Marques from the Department of Computer Science of the Faculty of Sciences of the University of Porto. I could not have asked for better supervisors. In our many meetings I always felt confortable to ask questions and I understood I was in the perfect environment to do great work. They guided, encouraged and were always available to help me. I could not have asked for a better experience!")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("In the end I wrote a report with the title of “On using Deep Learning for Automatic Taxonomic Identification of Butterflies” where I cover the state of the art in Deep Learning and Convolutional Neural Networks and I go through the process of training and deploying a Classifier in a Web application that was able to classify different images of butterflies that can be found in Portugal.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("In June 2020 I was one of the 350 worldwide winners of the Apple WWDC Student Challenge. As part of the prize I won one year of individual membership in the Apple Developer Program. I wanted to make good use of it and develop an app. The Butterfly Classification project I worked on during the last semester of my Bachelor's Degree in Computer Science provided the perfect theme for my app. And this is how Lepilens came to be...")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("What is Lepilens?")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("Butterflies play an essential role in the natural ecosystem as pollinators and as food for other animals in all stages of their life cycle. Their intricate relationships with plants and animals means that they are often the first to be endangered if an ecosystem’s delicate balance is disturbed. Thus, the occurrence of certain species and their numbers are often used as indicators of ecosystem health.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("Lepilens is an iOS application that aims to connect its users with nature and butterflies. Using Lepilens anyone can become an expert in Lepidoptera and make observations, organize, share and export them. Lepilens can classify 134 different species of butterflies that can be found in Portugal and across Europe.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("The name - Lepilens")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("Butterflies (Rhopalocera) and moths (Heterocera) are the adult stage of insects belonging to a group called Lepidoptera. The word itself has its origins in Ancient Greek from lepidos (scale) and ptera (wing), meaning “wings with scales”, a reference to the fact that the wings of butterflies and moths are actually covered with thousands of tiny scales overlapping in rows.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
                
                Text("The name Lepilens aims to relate the core functionality of the app, which is creating observations of butterflies using the iPhone camera, with “Lepi” from Lepidoptera.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Acknowledgements")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 20)
                    
                    Spacer()
                }
                
                Text("In order to build this app and train the Machine Learning model that performs the classification I used images from different sources which are hereby acknowledged: iNaturalist, pyrgus.de, euroButterflies, Lepidoptera Mundi, Lepiforum, Naturdata, Butterflies of France, LEPIDOPTERA (Borboletas) em Portugal Facebook group.")
                    .fontWeight(.regular)
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 10)
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitle("About")
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}

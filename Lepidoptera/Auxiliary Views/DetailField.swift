//
//  DetailField.swift
//  Lepidoptera
//
//  Created by Tomás Santiago on 16/08/2020.
//  Copyright © 2020 Tomás Santiago. All rights reserved.
//

import SwiftUI

///Reresents a row of details in the Details sheet.
struct DetailField: View {
    
    var field: String
    var value: String
    
    var body: some View {
        
        VStack {
            HStack {
                Text(field).bold()
                Text(value)
                Spacer()
            }
            Divider()
        }
    }
}

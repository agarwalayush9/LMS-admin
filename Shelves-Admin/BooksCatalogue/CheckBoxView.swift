//
//  CheckBoxView.swift
//  Shelves-Admin
//
//  Created by Sahil Raj on 11/07/24.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.32, green: 0.23, blue: 0.06), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 255/255, green: 246/255, blue: 227/255)))
                    .frame(width: 25, height: 25)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .frame(width: 20, height: 20)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

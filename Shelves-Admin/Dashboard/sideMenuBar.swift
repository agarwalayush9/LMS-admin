//
//  sideMenuBar.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import SwiftUI


struct sideMenu : View {
    var body: some View {
        ZStack{
            
        }
    }
}

struct sideMenuBar: View {
    var body: some View {
        ZStack{
            Button(action: {
                //Menu
            }, label: {
                Text("Open Menu")
                    .frame(width: 200, height: 50, alignment: .center)
            })
        }
    }
}

//#Preview {
//   // sideMenuBar(isShowing: .constant(true))
//}

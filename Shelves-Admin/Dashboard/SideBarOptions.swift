//
//  SideBarOptions.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import SwiftUI

struct SideBarOptions: View {
    let sideBarOptionList = sideBarOptions.sideBaroptionList
    var body: some View {
        VStack{
            Text("Librarian")
                .font(.system(size: 34, weight: .bold, design: .default))
            
            ForEach(sideBarOptionList){ option in
                Text(option.optionName)
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .padding(.vertical, 10)
                
            }
            Spacer()
            
            
            ContactAdminButton()
                .padding([.top,.bottom],16)
            
            LibrarianProfile(userName: "Ankit Verma",
                             post: "Librarian",
                             porfileImage: "person.fill") 
        }
    }
}

#Preview {
    SideBarOptions()
}


struct ContactAdminButton : View {
    var body: some View {
        
        HStack{
            Image(systemName: "headphones")
                .padding(.leading, 8)
            Text("Contact Admin")
                .font(.system(size: 17, weight: .regular, design: .default))
                .padding(.all, 4)
        }
        .padding(.all, 11)
        .frame(width: 232, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color(red: 0.96, green: 0.35, blue: 0.4), lineWidth: 1)
        )
    }
}

struct LogOutButton : View {
    var body: some View {
        HStack{
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .frame(width: 17, height: 17)
            Text("Log Out")

                
        }
        .padding(.all)
        .frame(width: .infinity, height: 50)
        .background(.red)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}



struct LibrarianProfile: View {
    var userName : String
    var post : String
    var porfileImage : String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 110)
                .foregroundColor(.clear)
                .background(.clear)
            HStack {
                HStack(){
                    Rectangle()
                        .frame(width: 40, height: 40,alignment: .leading)
                        .foregroundColor(.clear)
                        .background(
                            Image(systemName: "\(porfileImage)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipped()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .padding(.trailing,16)
                    VStack{
                        Text(userName)
                            .font(.system(size: 16,
                                          weight: .bold,
                                          design: .default))
                            .foregroundStyle(Color.black)
                            .frame(width: .infinity,alignment: .topLeading)
                        Text(post)
                            .font(.system(size: 16,
                                          weight: .bold,
                                          design: .default))
                            .foregroundStyle(Color.gray)
                            .frame(width: .infinity,alignment: .topLeading)
                    }
                }
                .padding(.leading,16)
                LogOutButton()
            }
            
        }
                 
    }
}



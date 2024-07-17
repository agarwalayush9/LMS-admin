//
//  EventRequest.swift
//  Shelves-Admin
//
//  Created by Abhay singh on 14/07/24.
//

import SwiftUI

struct EventRequest: View {
    @State private var menuOpened = false

    var body: some View {
        NavigationStack {
            ZStack{
                backgroundView()
                        .ignoresSafeArea(.all)
                    backgroundView()
                        .ignoresSafeArea(.all)
                        .blur(radius: menuOpened ? 10 : 0)
                        .animation(.easeInOut(duration: 0.25), value: menuOpened)
                ScrollView {
                    
                    //main Vstack that holds every Card
                    //for each will be used here
                    VStack(alignment: .center){
                        
                        
//                        EventRequestCard(width: UIScreen.main.bounds.width * 0.90, 
//                                         height: 200,
//                                         eventName: "California Art Festival 2023 Dana Point 29-30",
//                        )
                        EventRequestCard(imageName: "adminVector",
                                         width: UIScreen.main.bounds.width * 0.95,
                                         height: 200,
                                         eventName: "California Art Festival 2023 Dana Point 29-30",
                                         eventDate: "14-Jul-2024",
                                         eventLocation: "Noida",
                                         hostName: "Zek")
                        
                    }.padding([.top,])
                        
                        
                    
                }
                if menuOpened {
                    sideMenu( width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                }
                
            }//Zstack ends
            .navigationTitle("LMS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        menuOpened.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.black)
                    })
                    
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.black)
                    })
                }
            }
        }//Navigation Stack ends
    }
    func toggleMenu() {
        menuOpened.toggle()
    }
}


//MARK: Custom car for each event card
struct EventRequestCard: View {
    var imageName : String
    var width : Double
    var height : Double
    var eventName : String
    var eventDate : String
    var eventLocation : String
    var hostName : String
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                HStack {
                    //Event Image
                    
                    HStack{
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 112, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                    Spacer()
                    //Event Detail
                    HStack{
                        VStack{
                            Text("Event Title: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                ).foregroundStyle(.gray)
                            Text(eventName)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold))
                            Text("Date: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                ).foregroundStyle(.gray)
                            Text(eventDate)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold))

                            Text("Location: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                ).foregroundStyle(.gray)
                            Text(eventLocation)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold))
                            
                            Text("Host: ")
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold)
                                ).foregroundStyle(.gray)
                            Text(hostName)
                                .font(
                                    Font.custom("DM Sans", size: 17)
                                        .weight(.bold))
                        }
                    }
                    Spacer()
                    HStack{
                       
                        VStack{
                            Spacer()
                            AorDCustomButton(width: 200,
                                             height: 100,
                                             title: "Approve",
                                             colorName: "ApproveButton", fontColor: "ApproveFontColor")
                            Spacer()
                            AorDCustomButton(width: 200,
                                             height: 100,
                                             title: "Decline",
                                             colorName: "DeclineButton", fontColor: "DeclineFontColor")
                            Spacer()
                        }
                       
                    }.padding()
                    
                }//End of HStack
            )
    }
}
struct AorDCustomButton : View {
    
    var width : CGFloat
    var height : CGFloat
    var title : String
    var colorName : String
    var fontColor : String
    var body: some View {
        HStack{
            Text(title)
                .font(
                Font.custom("DM Sans", size: 20)
                .weight(.bold)
                )
                .foregroundColor(Color(fontColor))
        }
        .padding(.all)
        .frame(maxWidth: width, maxHeight: height)
        .background(Color(colorName))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#Preview {
    EventRequest()
}

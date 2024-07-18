//
//  AdminDashboard.swift
//  Shelves-Admin
//
//  Created by Abhay singh on 05/07/24.
//

import SwiftUI

struct mainDashboarGraph : View{
    @StateObject private var viewModel = EventViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal){
                HStack() {
                    ForEach(viewModel.events) { event in
                        EventRow(event: event)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("All Events Listing")
        }
        .onAppear {
            viewModel.fetchEvents()
        }
    }
}

struct AdminDashboard: View {
    @State private var menuOpened = false
    @State private var isManageLibrarians = false
    @State private var isManageEvents = false
    @State private var isBookCatalogue = false
    
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
            backgroundView()
                    .ignoresSafeArea(.all)
                backgroundView()
                    .ignoresSafeArea(.all)
                    .blur(radius: menuOpened ? 10 : 0)
                    .animation(.easeInOut(duration: 0.25), value: menuOpened)
                ScrollView {
                    VStack{
                    HStack(spacing : 0){
                        VStack(alignment: .leading, spacing: 16){
                            userName(userName: "User")
                            todayDateAndTime()
                            
                        }
                       .padding(.all, 64)

                    }
                    .padding(.trailing, 462)
                    ScrollView{
                        VStack{
                            //inside this write BookCircilation
                            VStack(alignment: .leading,spacing: 20){
                                AnalyticHeader(title: "Main Analytics Below")
                                ScrollView(.horizontal,showsIndicators: false){
                                    HStack(spacing: 20){
                                        DashboardAnalytics()
                                    }
                                    .padding(.leading,64)
                                }
                                VStack(alignment: .leading, spacing: 20){
                                    AnalyticHeader(title: "Analytics")
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing: 20){
                                            DashboardGraph()
                                        }
                                        .padding(.leading,64)
                                    }
                                    
                                }
                                .padding([.bottom], 16)
                                Spacer()
                            }
                            .padding([.top,.bottom], 16)
                            Spacer()
                            .padding([.leading, .trailing],64)
                            .padding(.bottom, 85)
                            
                        }
                    }
                    
                    }
                }
                
                // Rectangle bar here
                // Tab bar
                               Rectangle()
                                   .ignoresSafeArea()
                                   .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.07)
                                   .foregroundColor(Color("librarianDashboardTabBar"))
                                   .overlay(
                                       HStack(alignment: .center) {
                                        
                                           Spacer()
                                           showTabBarButtons(isManageLibrarians: $isManageLibrarians,
                                                             isManageEvents: $isManageEvents,
                                                             isBookCatalogue : $isBookCatalogue
                                           )
                                       }
                                       .padding([.top, .leading])
                                      // .padding(.leading, 50)
                                       
                                   )
                                   .ignoresSafeArea()
            
                if menuOpened {
                    sideMenu( width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                }
        }//zstack end
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
    }//navihation stack end
 }
    func toggleMenu() {
        menuOpened.toggle()
    }

}

struct backgroundView : View {
    var body: some View {
        Color("dashboardbg").ignoresSafeArea()
        
    }
}


struct BookCirculationCard: View {
    
    var minHeight : CGFloat
    var title : String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            
            BookCirculationCardData(bookTitle: "Soul", authorName: "zek")
            Spacer()
        }
        .padding()
        .background(Color.white).frame(minHeight: minHeight)
        .clipShape(RoundedRectangle(cornerRadius: 12))

    }
}




//MARK: Tab bar buttons
struct showTabBarButtons: View {
    @Binding var isManageLibrarians: Bool
    @Binding var isManageEvents: Bool
    @Binding var isBookCatalogue: Bool
    
    var body: some View {
        // Manage event buttons
        NavigationStack {
            HStack {
                    Spacer()
                
                    //Manage Events
                Button(action: {
                    print("Manage Events Pressed")
                    
                },
                       label: {
                    NavigationLink(destination: EventRequest()){
                        CustomButton(width: 180, 
                                     height: 140,
                                     title: "Manage Events",
                                     colorName: "CustomButtonColor", fontColor: "white")
                    }
                })
                .padding()

                    //Manage Librarian
                    Button(action: {
                        print("Manage Librarian Pressed")
                        
                    },
                           label: {
                        NavigationLink(destination: AddLibrarian()){
                            CustomButton(width: 180, 
                                         height: 140,
                                         title: "Manage Librarian", colorName: "CustomButtonColor", fontColor: "white")
                        }
                    })
                    .padding()
                //Book Catalogue
                Button(action: {
                    print("Book Catalogue Pressed")
                    
                },
                       label: {
                    NavigationLink(destination: BooksCatalogue()){
                        CustomButton(width: 180,
                                     height: 140,
                                     title: "Book Catalogue",
                                     colorName: "CustomButtonColor", fontColor: "white")
                    }
                })
                .padding()
                
                Spacer()
            }
        }
        
    }
}



struct CustomButton : View {
    
    var width : CGFloat
    var height : CGFloat
    var title : String
    var colorName : String
    var fontColor : String
    var body: some View {
        HStack{
            Text(title)
                .font(
                Font.custom("DM Sans", size: 17)
                .weight(.bold)
                )
                .foregroundColor(.white)
        }
        .padding(.all)
        .frame(maxWidth: width, maxHeight: height)
        .background(Color(colorName))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
struct showingDetails : View {
    
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var userName : String
    var OverDuePeriod : String
    var Fine : Double
    
    var body: some View {
        VStack {
            HStack{
    //            BookCirculationCardData(bookTitle: bookTitle,
    //                                    authorName: authorName)
                bookInfo(bookTitle: BookTitle,
                         authorName: AuthorName,
                         ISBN: ISBN,
                         imageName: imageName)
                .padding()
                userInfo(userName: userName,
                         OverDuePeriod: OverDuePeriod, Fine: Fine)
            }
        }
    }
}

struct BookCirculationCardData : View {
    
    var bookTitle : String
    var authorName : String
    
    var body: some View {
        VStack (spacing : 30){
            HStack{
//                bookInfo(bookTitle: "soul", authorName: "zek")
                    //.padding(.leading, 128)
                Spacer()
                    
            }
        }
        
    }
}

struct userInfo : View {
    var userName : String
    var OverDuePeriod: String
    var Fine : Double
    var body: some View {
        HStack{
            Text(userName)
            Spacer()
            VStack{
                Text("Overdue")
                    .padding()
                Text("\(OverDuePeriod) days")
            }
            Spacer()
            VStack{
                Text("Fine")
                    .padding()
                Text("\(Fine)")
            }
        }
    }
}

struct bookInfo : View {
    
    var bookTitle : String
    var authorName : String
    var ISBN : String
    var imageName : String
    var body: some View {
        HStack(spacing : 20){
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 79, height: 125)
            .background(
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 79, height: 125)
                    .clipped()
            )
            .padding(.bottom, 12)
        VStack{
            Rectangle()
                .frame(width: 90, height: 25)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(Color("ISBNContainerColor"))
                .overlay(
                    Text(ISBN)
                        .font(
                            Font.custom("DM Sans", size: 14)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                )
            
            Text(bookTitle)
                .font(
                    Font.custom("DM Sans", size: 25)
                        .weight(.medium)
                )
                .foregroundColor(.black)
            Text(authorName)
            //Text("by Shshank")
                .font(
                    Font.custom("DM Sans", size: 17)
                        .weight(.medium)
                )
                .foregroundColor(Color("AuthorNameColor"))
            
        }
        
        // user Details go here
        
    }
    }
}

struct memberData : View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 91, height: 65)
          .background(
            Image(systemName: "person.3")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 91, height: 65)
              .clipped()
          )
    }
}

#Preview {
    AdminDashboard()
}

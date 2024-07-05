//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
            backgroundView()
                    .ignoresSafeArea(.all)
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
                                    AnalyticHeader(title: "Main Analytics Below")
                                    ScrollView(.horizontal, showsIndicators: false){
                                        HStack(spacing: 20){
                                            DashboardAnalytics()
                                        }
                                        .padding(.leading,64)
                                    }
                                    
                                }
                                .padding([.bottom], 16)
                                Spacer()
                            }
                            .padding([.top,.bottom], 16)
                            Spacer()
                            BookCirculationCard(minHeight: 160,
                                                title: "Book Circulation")
                            .padding([.leading, .trailing], 64)
                                
                        HStack(){
                            VStack{
                                overDueBooksDetailData()
                                .padding(.top,80)
                           
                            }
                            .background(
                                BookCirculationCard(minHeight: 160, title: "Overdue Book Details")
                                .padding(.bottom, 16))
                                
                                Spacer()
                            VStack{
                                NewlyArrivedBooksDetailData()
                                .padding(.top,80)
                            }
                            .background(
                                BookCirculationCard(minHeight: 160, title: "Newly Arrived Books")
                                .padding(.bottom, 16))
                            }
                            .padding([.leading, .trailing],64)
                            .padding(.bottom, 85)
                            
                        }
                    
                    }
                }
            
                // Tab bar
                Rectangle()
                    .ignoresSafeArea()
                    .frame(maxWidth:.infinity,maxHeight: UIScreen.main.bounds.height * 0.07)
                    .foregroundColor(Color("librarianDashboardTabBar"))
                    .overlay(
                        HStack(alignment: .center){
                            
                            CustomButton(systemImage: "plus",
                                         width: 98, 
                                         height: 39,
                                         title: "Add",
                                         colorName: "CustomButtonColor")
                            .padding()
                            Spacer()
                                
                            CustomButton(systemImage: "",
                                         width: 150,
                                         height: 39,
                                         title: "Lend Book",
                                         colorName: "CustomButtonColor")
                            CustomButton(systemImage: "",
                                         width: 180,
                                         height: 39,
                                         title: "Return Book",
                                         colorName: "CustomButtonColor")
                            .padding()
                                                    }.padding([.top, .leading])
                        
                    )
                    .ignoresSafeArea()
                
                
            }
            
            .navigationTitle("lms".capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
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
    }
 }
}


struct CustomButton : View {
    
    var systemImage : String
    var width : CGFloat
    var height : CGFloat
    var title : String
    var colorName : String
    
    var body: some View {
        HStack{
            Image(systemName: systemImage)
                .foregroundStyle(Color.white)
            Text(title)
                .font(
                Font.custom("DM Sans", size: 20)
                .weight(.bold)
                )
                .foregroundColor(.white)
        }
        .padding(.all)
        .frame(width: width, height: height)
        .background(Color(colorName))
        .clipShape(RoundedRectangle(cornerRadius: 10))
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

struct showingDetailsForOverDueDetails : View {
    
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

struct showingDetailsForNewlyArrivedBooks : View {
    
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var Quantity : Int
    var ArivedDate : String
    
    var body: some View {
        VStack {
            HStack{

                bookInfo(bookTitle: BookTitle,
                         authorName: AuthorName,
                         ISBN: ISBN,
                         imageName: imageName)
                .padding()
                NewlyArrivedBooksQuantityInfo(ArrivedDate: ArivedDate, Quantity: Quantity)
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
                Text("$\(String(format: "%.2f", Fine))")
            }
        }
    }
}

struct NewlyArrivedBooksQuantityInfo : View {
    
    var ArrivedDate : String
    var Quantity : Int
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Text("Arrived Date")
                    .padding()
                Text("\(ArrivedDate) ")
            }
            Spacer()
            VStack{
                Text("Quantity")
                    .padding()
                Text("\(Quantity) units")
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
    }
    }
}

struct memberData : View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 90.64484, height: 64.45855)
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
    LibrarianDashboard()
}

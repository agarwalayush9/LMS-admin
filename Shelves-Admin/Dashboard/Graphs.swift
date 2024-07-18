//
//  Graphs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI
import Charts

//MARK: for event revenue  data
struct eventRevenueData: Identifiable {
    var id = UUID()
    var date: Date
    var ticketCount: Int
    var ticketPrice: Int
}

class eventRevenueViewModel: ObservableObject {
    @Published var events = [eventRevenueData]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        // Generate sample data
        events = [
            eventRevenueData(date: Date(), ticketCount: 100, ticketPrice: 50),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, ticketCount: 150, ticketPrice: 60),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, ticketCount: 200, ticketPrice: 70),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, ticketCount: 120, ticketPrice: 55),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, ticketCount: 180, ticketPrice: 65)
        ]
    }
}

struct EventAreaGraphView: View {
    @StateObject private var viewModel = eventRevenueViewModel()

    var body: some View {
        VStack {
            Chart(viewModel.events) { event in
                AreaMark(
                    x: .value("Date", event.date),
                    y: .value("Revenue", event.ticketCount * event.ticketPrice)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 150) // Reduced height
            .padding(.horizontal) // Reduced padding
            .padding(.vertical, 10)
        }
    }
}

struct EventAreaGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EventAreaGraphView()
    }
}



// MARK: Data and Graph for Line chart for no. of visitor in events
struct VisitorData: Identifiable {
    let id = UUID()
    let date: Date
    let visitors: Int
}

class EventVisitorViewData: ObservableObject {
    @Published var visitors: [VisitorData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        visitors = [
            VisitorData(date: Date().addingTimeInterval(-6*24*60*60), visitors: 239),
            VisitorData(date: Date().addingTimeInterval(-5*24*60*60), visitors: 252),
            VisitorData(date: Date().addingTimeInterval(-4*24*60*60), visitors: 315),
            VisitorData(date: Date().addingTimeInterval(-3*24*60*60), visitors: 198),
            VisitorData(date: Date().addingTimeInterval(-2*24*60*60), visitors: 148),
            VisitorData(date: Date().addingTimeInterval(-1*24*60*60), visitors: 68),
            VisitorData(date: Date(), visitors: 183)
        ]
    }
}

struct VisitorLineChartView: View {
    let data: [VisitorData]

    var body: some View {
        Chart(data) { entry in
            LineMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.brown)
            AreaMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.weekday())
            }
        }
        .chartYAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .frame(height: 150) // Reduced height
        .padding(.horizontal) // Reduced padding
        .padding(.vertical, 10)
    }
}

struct LineChart: View {
    @ObservedObject var eventVisitorViewData = EventVisitorViewData()
    
    var body: some View {
        VStack {
            VisitorLineChartView(data: eventVisitorViewData.visitors)
                .padding(.horizontal) // Reduced padding
                .padding(.vertical, 10)

            Spacer()
        }
    }
}


#Preview("Line Chart"){
    LineChart()
}

//MARK: Data and Graph for Bar chart for no. of visitor in events

struct TicketData: Identifiable {
    let id = UUID()
    let day: String
    let ticketsSold: Int
    let ticketsAvailable: Int
}

class EventTicketSalesData: ObservableObject {
    @Published var tickets: [TicketData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        tickets = [
            TicketData(day: "Mon", ticketsSold: 150, ticketsAvailable: 80),
            TicketData(day: "Tue", ticketsSold: 120, ticketsAvailable: 60),
            TicketData(day: "Wed", ticketsSold: 170, ticketsAvailable: 50),
            TicketData(day: "Thu", ticketsSold: 100, ticketsAvailable: 45),
            TicketData(day: "Fri", ticketsSold: 130, ticketsAvailable: 50),
            TicketData(day: "Sat", ticketsSold: 140, ticketsAvailable: 70),
            TicketData(day: "Sun", ticketsSold: 160, ticketsAvailable: 90)
        ]
    }
}

struct BarChartView: View {
    var data: [TicketData]
    let maxTickets = 200 // Assuming the max tickets for scaling

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { entry in
                VStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        // Ticket Sold
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customButton)
                                .frame(width: 15, height: CGFloat(entry.ticketsSold) / CGFloat(maxTickets) * 100)
                        }
                        
                        // Ticket Available
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.librarianDashboardTabBar)
                                .frame(width: 15, height: CGFloat(entry.ticketsAvailable) / CGFloat(maxTickets) * 100)
                        }
                    }

                    Text(entry.day)
                        .font(.caption2)
                        
                }
            }
        }
        .padding()
    }
}

struct BarGraph: View {
    @StateObject private var viewModel = EventTicketSalesData()

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Circle()
                        .fill(Color.customButton)
                        .frame(width: 15, height: 15)
                    Text("200 Ticket Sold")
                        .font(.caption2)
                }
                
                HStack {
                    Circle()
                        .fill(Color.librarianDashboardTabBar)
                        .frame(width: 15, height: 15)
                    Text("330 Ticket Available")
                        .font(.caption2)
                }
            }
           
            BarChartView(data: viewModel.tickets)
            
            Spacer()
        }
        .padding()
    }
}
//MARK: Pie chart for Ticket Status


import SwiftUI

struct TicketStatus: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let color: Color
}

class TicketViewModel: ObservableObject {
    @Published var tickets: [TicketStatus] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        tickets = [
            TicketStatus(category: "Availed", value: 500, color: .customButton),
            TicketStatus(category: "Remaining", value: 200, color: .librarianDashboardTabBar),
            TicketStatus(category: "Cancelled", value: 100, color: .pieLesser)
        ]
    }
}

struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let path = Path { path in
                path.move(to: CGPoint(x: size / 2, y: size / 2))
                path.addArc(
                    center: CGPoint(x: size / 2, y: size / 2),
                    radius: size / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            path.fill(self.color)
        }
    }
}

struct PieChartView: View {
    var data: [TicketStatus]
    
    private func calculateAngles() -> [Angle] {
        let total = data.reduce(0) { $0 + $1.value }
        var angles: [Angle] = []
        var currentAngle: Double = -90
        
        for entry in data {
            let angle = entry.value / total * 360
            angles.append(.degrees(currentAngle))
            currentAngle += angle
        }
        angles.append(.degrees(currentAngle))
        
        return angles
    }
    
    var body: some View {
        let angles = calculateAngles()
        
        return ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                PieSliceView(
                    startAngle: angles[index],
                    endAngle: angles[index + 1],
                    color: data[index].color
                )
            }
        }
    }
}

struct PieChartDisplayView: View {
    @StateObject private var viewModel = TicketViewModel()

    var body: some View {
        VStack(alignment: .leading) {
//            Text("Ticket Status")
//                .font(.title2)
//                .bold()
//                .padding(.bottom, 10)
            
            HStack {
                PieChartView(data: viewModel.tickets)
                    .frame(width: 150, height: 150)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    ForEach(viewModel.tickets) { ticket in
                        HStack {
                            Circle()
                                .fill(ticket.color)
                                .frame(width: 15, height: 15)
                            VStack(alignment: .leading) {
                                Text("\(ticket.category):")
                                Text("\(ticket.value, specifier: "%.0f")")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}



#Preview{
    PieChartDisplayView()
}



// Preview provider for the main view
#Preview("bar graph"){
    BarGraph()
}

struct DashboardGraph: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center) {
                //MARK: Area graph for Event Revenue
                RoundedRectangle(cornerRadius: 14)
                    .frame(minWidth: 500, minHeight: 300)
                    .foregroundColor(.white)
                    .overlay(
                        GeometryReader { geometry in
                            Text("Event Revenue")
                                .padding()
                                .font(Font.custom("DM-Sans", size: 17)
                                    .weight(.bold))
                            EventAreaGraphView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .position(x: geometry.size.width / 2, y: (geometry.size.height + 50) / 2)
                        }
                    )
                    .padding(.trailing)
                
                //MARK: Pie chart for Ticket Status
                RoundedRectangle(cornerRadius: 14)
                    .frame(minWidth: 500, minHeight: 300)
                    .foregroundColor(.white)
                    .overlay(
                        GeometryReader { geometry in
                            Text("Ticket Status")
                                .padding()
                                .font(Font.custom("DM-Sans", size: 17)
                                    .weight(.bold))
                            PieChartDisplayView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .position(x: geometry.size.width / 2, y: (geometry.size.height + 50) / 2)
                                .padding(.top, 32)
                        }
                    )
                
                //MARK: Line Chart for Total Event Visitors
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(minWidth: 500, minHeight: 300)
                    .foregroundColor(.white)
                    .overlay(
                        GeometryReader { geometry in
                            Text("Total Event Visitors")
                                .padding()
                                .font(Font.custom("DM-Sans", size: 17)
                                    .weight(.bold))
                            LineChart()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .position(x: geometry.size.width / 2, y: (geometry.size.height + 50) / 2)
                                .padding(.top, 64)
                        }
                    )
                //MARK: Bar chart for Ticket sales
                
                RoundedRectangle(cornerRadius: 14)
                    .frame(minWidth: 500, minHeight: 300)
                    .foregroundColor(.white)
                    .overlay(
                        GeometryReader { geometry in
                            Text("Total Sales")
                                .padding()
                                .font(Font.custom("DM-Sans", size: 17)
                                    .weight(.bold))
                            BarGraph()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .position(x: geometry.size.width / 2, y: (geometry.size.height + 50) / 2)
                                .padding(.top, 64)
                        }
                    )
                
                
            }
        }
    }
}
//LineChart

#Preview("Dashboard"){
    AdminDashboard()
}

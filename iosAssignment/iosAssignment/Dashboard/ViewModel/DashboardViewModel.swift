//
//  DashboardViewModel.swift
//  iosAssignment
//
//  Created by Aunish Jayprakash Kewat on 06/05/24.
//

import Foundation

class DashboardViewModel: ObservableObject {
    
    @Published var graphData: [GraphData] = []
    @Published var recentLinks: [RecentLink] = []
    @Published var topLinks: [TopLink] = []
    @Published var userName: String = "Ajay Manva"
    
    func fetchDashboardData() {
        guard let url = URL(string: APIStrings.apiUrl) else {
            print("Invalid URL: \(APIStrings.apiUrl)")
            return
        }
        
        let request = APIUtilities.getRequest(url: url, accessToken: APIStrings.accessToken)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(DashboardResponse.self, from: data)
                    
                    // Update graphData
                    DispatchQueue.main.async {
                        self.graphData.removeAll() // Clear existing data
                        for (hour, clicks) in response.data.overallUrlChart ?? [:] {
                            self.graphData.append(GraphData(hour: hour, clicks: clicks))
                        }
                        self.recentLinks = response.data.recentLinks
                        self.topLinks = response.data.topLinks
                    }
                    
                } catch {
                    print("Error decoding response: \(error)")
                }
            }
        }
        task.resume()
    }
    
    // time wish
    
    @Published var dayWish: String = ""

    func updateDayWishAsOnTime() {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if hour >= 0 && hour < 12 {
            dayWish = "Good Morning"
        } else if hour >= 12 && hour < 17 {
            dayWish = "Good Afternoon"
        } else {
            dayWish = "Good Evening"
        }
    }
}

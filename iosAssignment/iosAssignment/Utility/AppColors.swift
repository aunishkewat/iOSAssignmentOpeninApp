//
//  AppColors.swift
//  iosAssignment
//
//  Created by Aunish Jayprakash Kewat on 05/05/24.
//

import Foundation

struct AppColors {
    static let blue = "#0E6FFF"
    static let lightGrey = "#F5F5F5"
}

struct APIStrings {
    static let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI"
    static let apiUrl = "https://api.inopenapp.com/api/v1/dashboardNew"
}

struct APIUtilities {
    static func getRequest(url: URL, accessToken: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

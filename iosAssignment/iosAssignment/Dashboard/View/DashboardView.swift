//
//  DashboardView.swift
//  iosAssignment
//
//  Created by Aunish Jayprakash Kewat on 05/05/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    
    @StateObject var vm: DashboardViewModel = DashboardViewModel()
   
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            VStack {
                Text("Dashboard")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading)
                
                ScrollView {
                    ZStack {
                        Rectangle()
                            .fill(Color(AppColors.lightGrey))
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        VStack {
                            Text(vm.dayWish)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .padding(.top)
                                .foregroundColor(.gray)
                            
                            Text(vm.userName)
                                .font(.system(size: 30))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            ZStack {
                                Rectangle()
                                    .fill(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .frame(height: 250)
                                    .padding(.all)
                                    .shadow(radius: 3)
                                // Graph UI
                                VStack {
                                    Chart {
                                        ForEach(vm.graphData) { data in
                                            LineMark (
                                                x:.value("Hour", data.hour),
                                                y:.value("Clicks", data.clicks)
                                            )
                                            .foregroundStyle(Color.blue) // adjust the color as needed
                                            .lineStyle(StrokeStyle(lineWidth: 3))
                                        }
                                    }
                                    .frame(height: 200)
                                    .padding(.all, 30)
                                    //segment view and list
                                    LinkSegmentView(vm: vm)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
            .background(Color(AppColors.blue))
            .onAppear(perform: {
                vm.fetchDashboardData()
                vm.updateDayWishAsOnTime()
            })
        }
    }
}

#Preview {
    DashboardView()
}

// tab bar
struct LinkSegmentView: View {

    @ObservedObject var vm: DashboardViewModel
    @State private var selectedSegment = 0

    var body: some View {

        VStack {
            HStack {
                Button(action: { self.selectedSegment = 0 }) {
                    Text("Top Links")
                        .foregroundColor(self.selectedSegment == 0 ? .white : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(self.selectedSegment == 0 ? Color.blue : Color.clear)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: { self.selectedSegment = 1 }) {
                    Text("Recent Links")
                        .foregroundColor(self.selectedSegment == 1 ? .white : .gray)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(self.selectedSegment == 1 ? Color.blue : Color.clear)
                        .cornerRadius(20)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

            ScrollView {
                if selectedSegment == 0 {
                    VStack {
                        ForEach(vm.topLinks.indices, id: \.self) { index in
                            LinkView(name: vm.topLinks[index].title ?? "", url: vm.topLinks[index].webLink ?? "", imageName: vm.topLinks[index].originalImage ?? "", date: "", clicks: vm.topLinks[index].totalClicks ?? 0)
                        }
                    }
                } else {
                    VStack {
                        ForEach(vm.recentLinks.indices, id: \.self) { index in
                            LinkView(name: vm.topLinks[index].title ?? "", url: vm.topLinks[index].webLink ?? "", imageName: vm.topLinks[index].originalImage ?? "", date: "", clicks: vm.topLinks[index].totalClicks ?? 0)
                        }
                    }
                }
            }
        }
        .accentColor(.blue)
    }
}

struct LinkView: View {
    let name: String
    let url: String
    let imageName: String
    let date: String
    let clicks: Int
    
    let imageLoader = ImageLoader()
    @State private var imageUI: UIImage = UIImage()
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(maxWidth: .infinity)
                .padding(.all, 10)
                .frame(height: 140)
            
            VStack(alignment: .leading) {
                HStack {
                    
                    Image(uiImage: imageUI)
                        .resizable()
                        .padding(.trailing, 10)
                        .frame(width: 48, height: 48)

                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.title3)
                            .lineLimit(1)
                        Text(date)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    VStack {
                        Text("\(clicks)")
                            .font(.title3)
                        Text("Clicks")
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
                .onAppear {
                    let url = URL(string: imageName)!
                    imageLoader.loadImage(with: url) { image in
                        if let image = image {
                            print("Image loaded successfully in onAppear")
                            // Update the image view with the loaded image
                            self.imageUI = image
                        } else {
                            print("Failed to load image in onAppear")
                            // Update the image view with an empty image vie
                        }
                    }
                }
                
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 5)
                        .frame(height: 40)
                        .border(.blue, width: 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))

                    HStack {
                        Text(url)
                            .padding(.leading, 10)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "doc.on.doc")
                            .padding(.trailing, 10)
                            .onTapGesture {
                                print("copy the link")
                            }
                    }
                }
            }
            .padding()
        }
        
    }
}

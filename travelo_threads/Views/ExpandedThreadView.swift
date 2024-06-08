//
//  ExpandedThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import CoreLocation
import MapKit

struct ExpandedThreadView: View {
    @Binding var isExpanded: Bool
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    
    var section: Thread
    var animation: Namespace.ID

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    HStack(spacing: 10) {
                        if let image = userImageLoader.image {
                            Circle()
                                .frame(width: 50, height: 50)
                                .matchedGeometryEffect(id: "image-\(section.id)", in: animation)
                                .overlay(
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFill()
                                        .clipShape(Circle())
                                )
                                .shadow(color: Color("Shadow").opacity(0.1), radius: 10, x: 0, y: 0)
                        } else {
                            Circle()
                                .frame(width: 50, height: 50)
                                .overlay(AnimatedCirclePlaceholder())
                                .shadow(color: Color("Shadow").opacity(0.1), radius: 10, x: 0, y: 0)
                                .onAppear {
                                    if let url = URL(string: section.userImage) {
                                        userImageLoader.load(url: url)
                                    }
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(section.userName)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .matchedGeometryEffect(id: "userName-\(section.id)", in: animation)
                            Text(section.title)
                                .font(.system(size: 24, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 10)
                                .matchedGeometryEffect(id: "title-\(section.id)", in: animation)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        if let imageUrl = section.imageUrl, let url = URL(string: imageUrl) {
                            Rectangle()
                                .frame(height: 180)
                                .matchedGeometryEffect(id: "imageURL-\(section.id)", in: animation)
                                .overlay(
                                    Group {
                                        if let image = sectionImageLoader.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .scaledToFill()
                                                .clipShape(Rectangle())
                                        } else {
                                            AnimatedRectanglePlaceholder()
                                        }
                                    }
                                )
                                .cornerRadius(30)
                                .shadow(color: Color("Shadow").opacity(0.25), radius: 30, x: 0, y: 2)
                                .onAppear {
                                    sectionImageLoader.load(url: url)
                                }
                        }
                        Text(section.caption)
                            .font(.system(size: 17))
                            .matchedGeometryEffect(id: "caption-\(section.id)", in: animation)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 20))
                            Text("Sigiriya Rock")
                                .font(.system(size: 13, weight: .semibold))
                                .onAppear {
                                    locationFetcher.fetchLocation(for: section.location)
                                }
                                .onTapGesture {
                                    openMaps(for: section.location)
                                }
                                .matchedGeometryEffect(id: "location-\(section.id)", in: animation)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .overlay(
                    CardButtons(color: .black).padding(.top, 10)
                        .matchedGeometryEffect(id: "buttons-\(section.id)", in: animation),
                    alignment: .topTrailing
                )
                .cornerRadius(30)
                .matchedGeometryEffect(id: "background-\(section.id)", in: animation)
            }

            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            isExpanded = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                    .frame(width: 30, height: 30)
                    .background(Circle().foregroundColor(Color.black.opacity(0.6)))
                    .padding(.trailing, 25)
                    .padding(.top, 50)
                }
                Spacer()
            }
            .ignoresSafeArea()
        }
        .background(Color("Background"))
        .statusBar(hidden: true)
    }
    
    private func openMaps(for coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationFetcher.locationName
        mapItem.openInMaps(launchOptions: nil)
    }
}

#Preview {
    ExpandedThreadView(isExpanded: .constant(true), section: sampleThreads[0], animation: Namespace().wrappedValue)
}

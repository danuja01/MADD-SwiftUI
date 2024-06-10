//
//  SharedThreadContent.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI
import CoreLocation
import MapKit

struct SharedThreadContent: View {
    @ObservedObject var userImageLoader: ImageLoader
    @ObservedObject var sectionImageLoader: ImageLoader
    @ObservedObject var locationFetcher: LocationFetcher
    
    var section: Thread
    var showCaption: Bool = true
    var buttonColor: Color = Color.white
    var userImageSize: CGFloat = 50
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                UserImage(userImageLoader: userImageLoader, imageUrl: section.userImage, size: userImageSize)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(section.userName)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(section.title)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 10)
                }
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                if let imageUrl = section.imageUrl, let url = URL(string: imageUrl) {
                    Rectangle()
                        .frame(height: 180)
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
                
                if showCaption {
                    Text(section.caption)
                        .font(.system(size: 17))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 20))
                    Text(locationFetcher.locationName)
                        .font(.system(size: 13, weight: .semibold))
                        .onAppear {
                            if let geoPoint = section.location {
                                locationFetcher.fetchLocation(for: geoPoint.toCLLocationCoordinate2D())
                            }
                        }
                        .onTapGesture {
                            if let geoPoint = section.location {
                                openMaps(for: geoPoint.toCLLocationCoordinate2D())
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private func openMaps(for coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationFetcher.locationName
        mapItem.openInMaps(launchOptions: nil)
    }
}

#Preview {
    SharedThreadContent(userImageLoader: ImageLoader(), sectionImageLoader: ImageLoader(), locationFetcher: LocationFetcher(), section: sampleThreads[0], showCaption: true).padding()
}


//
//  ThreadCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import CoreLocation
import MapKit

struct ThreadCard: View {
    @State private var locationName: String = "Loading..."
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    
    var section = sampleThreads[0]
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay(
                        Group {
                            if let image = userImageLoader.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaledToFill()
                                    .clipShape(Circle())
                            } else {
                                AnimatedCirclePlaceholder()
                            }
                            
                        }
                    )
                    .shadow(color: Color("Shadow").opacity(0.1), radius: 10, x: 0, y: 0)
                    .onAppear {
                        if let url = URL(string: section.userImage) {
                            userImageLoader.load(url: url)
                        }
                    }
                VStack(alignment: .leading, spacing: 3) {
                    Text(section.userName)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(section.title)
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.trailing, 10)
                }
                
            }.padding(.bottom, 10)
            
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
                Text(section.caption)
                    .font(.system(size: 17))
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 20))
                    Text(locationName)
                        .font(.system(size: 13, weight: .semibold))
                        .onAppear {
                            fetchLocationName(for: section.location)
                        }
                        .onTapGesture {
                            openMaps(for: section.location)
                        }
                }
            }
        }
        .padding()
        .padding(.vertical, 10)
        .overlay(
            CardButtons(),
            alignment: .topTrailing
        )
        .foregroundColor(.white)
        .background(Color("Green1"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
    
    private func fetchLocationName(for coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks, !placemarks.isEmpty {
                // Use the first available placemark as the nearest identifiable location
                if let place = placemarks.first {
                    if let locality = place.locality, let country = place.country {
                        self.locationName = "\(locality), \(country)"
                    } else if let name = place.name {
                        self.locationName = name
                    } else {
                        self.locationName = "Unknown location"
                    }
                }
            } else if let error = error {
                print("Error finding location: \(error.localizedDescription)")
                self.locationName = "Error finding location"
            } else {
                self.locationName = "No address found"
            }
        }
    }

    private func openMaps(for coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: nil)
    }
}



#Preview {
    ThreadCard().padding()
}

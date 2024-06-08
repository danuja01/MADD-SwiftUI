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
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    
    var section: Thread
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CloseButton(action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            ScrollView {
                VStack {
                    SharedThreadContent(
                        userImageLoader: userImageLoader,
                        sectionImageLoader: sectionImageLoader,
                        locationFetcher: locationFetcher,
                        section: section,
                        showCaption: false,
                        buttonColor: Color("Button")
                    )
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .overlay(
                    CardButtons(color: Color("Button")).padding(.top, 10),
                    alignment: .topTrailing
                )
                .cornerRadius(30)
            }
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
    ExpandedThreadView(section: sampleThreads[0])
}

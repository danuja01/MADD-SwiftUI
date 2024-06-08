//
//  LocationSearchView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: CLLocationCoordinate2D?
    @Binding var locationName: String
    @State private var searchText: String = ""
    @StateObject private var searchManager = SearchManager()

    var body: some View {
        NavigationView {
            ZStack {
                Color("Background").ignoresSafeArea()
                VStack(spacing: 0) {
                    TextField("Search for a location", text: $searchText)
                        .customTextField()
                        .padding([.horizontal, .top])
                        .onChange(of: searchText) { newValue in
                            searchManager.search(with: newValue)
                        }

                    if !searchManager.searchResults.isEmpty {
                        Form {
                            ForEach(searchManager.searchResults, id: \.self) { result in
                                Button(result.title) {
                                    selectLocation(result)
                                }
                            }
                        }
                        .background(Color("Background"))
                    }

                    Spacer()
                }
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
                .navigationBarTitle("Search Location", displayMode: .inline)
            }
        }
    }

    private func selectLocation(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                location = coordinate
                locationName = completion.title
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    LocationSearchView(
        location: .constant(nil),
        locationName: .constant("")
    )
}


//
//  AddNewThread.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//
import SwiftUI
import MapKit
import CoreLocation

struct AddNewThread: View {
    @State private var title: String = ""
    @State private var location: CLLocationCoordinate2D?
    @State private var locationName: String = "Search Location"
    @State private var isPresentingLocationSearch: Bool = false

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            VStack(alignment: .leading) {
                HStack {
                    Text("Post a new thread")
                        .font(.title2.bold())
                    Spacer()
                    Button("Post".uppercased()) {
                        // Post action
                    }
                    .font(.title3.bold())
                    .foregroundColor(Color("Green4"))
                }
                .padding(.bottom, 20)

                VStack {
                    TextField("Where did you go?", text: $title)
                        .customTextField(image: Image("Icon Car"), backgroundColor: Color("Green3"), borderColor: Color("Green1"), cornerRadius: 20)
                        .padding(.bottom, 20)

                    Button(action: {
                        isPresentingLocationSearch = true
                    }) {
                        HStack {
                            Image("Icon Location")
                            Text(locationName)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding( 8)
                        .background(Color("Green3"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Green1"), lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 20)
                    .fullScreenCover(isPresented: $isPresentingLocationSearch) {
                        LocationSearchView(location: $location, locationName: $locationName)
                    }

                    TextField("Additional Info", text: $title)
                        .customTextField(image: Image("Icon Car"), backgroundColor: Color("Green3"), borderColor: Color("Green1"), cornerRadius: 20)
                        .padding(.bottom, 20)
                }
                Spacer()
            }
            .padding()
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    AddNewThread()
}


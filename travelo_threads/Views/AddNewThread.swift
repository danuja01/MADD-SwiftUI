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
    @FocusState private var isFocused: Bool
    @State private var title: String = ""
    @State private var location: CLLocationCoordinate2D?
    @State private var locationName: String = "Search Location"
    @State private var isPresentingLocationSearch: Bool = false
    @State private var caption: String = ""
    @State private var selectedImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var isPresentingActionSheet: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

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

                VStack(spacing: 20) {
                    TextField("Where did you go?", text: $title)
                        .customTextField(image: Image("Icon Car"), backgroundColor: Color("Green3"), borderColor: Color("Green1"), cornerRadius: 20)

                    Button(action: {
                        isPresentingLocationSearch = true
                    }) {
                        HStack {
                            Image("Icon Location")
                            Text(locationName)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                        .background(Color("Green3"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Green1"), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fullScreenCover(isPresented: $isPresentingLocationSearch) {
                        LocationSearchView(location: $location, locationName: $locationName)
                    }

                    CustomTextArea(text: caption, placeholder: "Go ahead, tell us more!", height: 200)
                        .focused($isFocused)

                    Button(action: {
                        isPresentingActionSheet = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Upload a photo")
                                .foregroundColor(.white.opacity(0.8))
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(Color("Green4"))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("Green1"), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .actionSheet(isPresented: $isPresentingActionSheet) {
                        ActionSheet(title: Text("Select Photo"), buttons: [
                            .default(Text("Take Photo")) {
                                sourceType = .camera
                                isPresentingImagePicker = true
                            },
                            .default(Text("Choose Photo")) {
                                sourceType = .photoLibrary
                                isPresentingImagePicker = true
                            },
                            .cancel()
                        ])
                    }
                    .sheet(isPresented: $isPresentingImagePicker) {
                        ImagePicker(image: $selectedImage, sourceType: sourceType)
                    }

                    if let selectedImage = selectedImage {
                        Rectangle()
                            .frame(height: 200)
                            .foregroundColor(.black)
                            .overlay(
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Rectangle())
                            )
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 20)

                Spacer()
            }
            .padding()
            .padding(.horizontal, 10)
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    AddNewThread()
}


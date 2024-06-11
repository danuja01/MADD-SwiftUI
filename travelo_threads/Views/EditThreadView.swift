//
//  EditThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-11.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore

struct EditThreadView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @FocusState private var isFocused: Bool
    @State private var thread: Thread
    @State private var title: String
    @State private var location: CLLocationCoordinate2D?
    @State private var locationName: String = "Search Location"
    @State private var isPresentingLocationSearch: Bool = false
    @State private var caption: String
    @State private var selectedImage: UIImage?
    @State private var isPresentingImagePicker: Bool = false
    @State private var isPresentingActionSheet: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImageHidden: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var onSave: (Thread) -> Void

    init(thread: Thread, onSave: @escaping (Thread) -> Void) {
        self._thread = State(initialValue: thread)
        self._title = State(initialValue: thread.title)
        self._caption = State(initialValue: thread.caption)
        self.onSave = onSave
    }

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            VStack(alignment: .leading) {
                HStack {
                    Text("Edit Thread")
                        .font(.title2.bold())
                    Spacer()
                    Button("Update".uppercased()) {
                        updateThread()
                    }
                    .font(.title3.bold())
                    .foregroundColor(Color("Green4"))
                }
                .padding(.bottom, 20)

                VStack(spacing: 20) {
                    TextField("Where did you go?", text: $title)
                        .customTextField(image: Image("Icon Car"), backgroundColor: Color("CommentArea"), borderColor: Color("Green1"), cornerRadius: 20)

                    Button(action: {
                        isPresentingLocationSearch = true
                    }) {
                        HStack {
                            Image("Icon Location")
                            Text(locationName)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(8)
                        .background(Color("CommentArea"))
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

                    CustomTextArea(text: $caption, placeholder: "Go ahead, tell us more!", height: 200)
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
                                isImageHidden = false
                            },
                            .default(Text("Choose Photo")) {
                                sourceType = .photoLibrary
                                isPresentingImagePicker = true
                                isImageHidden = false
                            },
                            .cancel()
                        ])
                    }
                    .fullScreenCover(isPresented: $isPresentingImagePicker) {
                        ImagePicker(image: $selectedImage, sourceType: sourceType)
                    }.ignoresSafeArea()

                    if let selectedImage = selectedImage, !isImageHidden {
                        ZStack(alignment: .topTrailing) {
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

                            Button(action: {
                                isImageHidden = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .padding()
                        }
                    }
                }
                .padding(.bottom, 20)

                Spacer()
            }
            .padding()
            .padding(.horizontal, 10)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if alertMessage == "Thread updated successfully" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            initializeEditView()
        }
    }

    func initializeEditView() {
        if let location = thread.location {
            self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.locationName = "Selected Location"
        }
        if let imageUrl = thread.imageUrl, let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        self.selectedImage = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    func updateThread() {
        var updatedThread = thread
        updatedThread.title = title
        updatedThread.caption = caption
        if let location = location {
            updatedThread.location = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        }
        FirebaseManager.shared.updateThread(thread: updatedThread, image: selectedImage) { success, message in
            if success {
                alertMessage = "Thread updated successfully"
                showAlert = true
                onSave(updatedThread) // Notify parent view about the update
            } else {
                alertMessage = message ?? "Failed to update thread"
                showAlert = true
            }
        }
    }
}

#Preview {
    EditThreadView(thread: sampleThreads[0]) { _ in }
}



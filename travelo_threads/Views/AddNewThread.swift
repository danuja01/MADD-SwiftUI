//
//  AddNewThread.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseAuth

struct AddNewThreadView: View {
    @EnvironmentObject var authManager: AuthenticationManager
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
    @State private var isImageHidden: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var onAddThread: (Thread, UIImage?) -> Void

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            VStack(alignment: .leading) {
                HStack {
                    Text("Post a new thread")
                        .font(.title2.bold())
                    Spacer()
                    Button("Post".uppercased()) {
                        addNewThread()
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
                    if alertMessage == "Thread posted successfully" {
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        .onTapGesture {
            isFocused = false
        }
    }

    func addNewThread() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated"
            showAlert = true
            return
        }

        let newThread = Thread(
            title: title,
            caption: caption,
            imageUrl: nil,
            location: location,
            userImage: authManager.userImageURL ?? "",
            userName: authManager.userName ?? "Anonymous",
            createdBy: user.uid
        )

        onAddThread(newThread, selectedImage)
    }
}

#Preview {
    AddNewThreadView { _, _ in }
}


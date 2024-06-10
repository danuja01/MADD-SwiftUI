//
//  SignUp.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct SignUp: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State private var selectedImage: UIImage?
    @State private var isPresentingImagePicker = false
    @State private var isPresentingActionSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var imageName: String?
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Text("Sign Up")
                        .font(.system(size: 34, weight: .bold))
                    Text("Join us and start your journey!")
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $username)
                        .customTextField(image: Image("Icon Username"))
                }
                
                VStack(alignment: .leading) {
                    Text("Email")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("", text: $email)
                        .customTextField(image: Image("Icon Email"))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    SecureField("", text: $password)
                        .customTextField(image: Image("Icon Lock"))
                }
                
                VStack(alignment: .leading) {
                    Text("Profile Image")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    Button(action: {
                        isPresentingActionSheet = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Upload a image")
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
                        ImagePicker(image: $selectedImage, sourceType: sourceType, imageName: $imageName)
                    }

                    if let imageName = imageName {
                        VStack {
                            Text(imageName)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    signUp()
                }) {
                    HStack {
                        Text("Sign Up")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .largeButton()
                }
                
                HStack {
                    Rectangle().frame(height: 1).opacity(0.1)
                    Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                    Rectangle().frame(height: 1).opacity(0.1)
                }
                
                HStack {
                    Text("Already have an account? ")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Sign in")
                            .foregroundColor(Color("Green1"))
                    }
                }
            }
            .padding(30)
            .background(.regularMaterial)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.12), radius: 30, x: 0, y: 30)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .padding()
        }
    }

    func signUp() {
        if !email.isValidEmail {
            errorMessage = "Please enter a valid email address."
            return
        }

        FirebaseManager.shared.createUser(email: email, password: password, username: username, image: selectedImage) { success, message in
            if success {
                // Handle successful registration, possibly dismiss view or show success message
                presentationMode.wrappedValue.dismiss()
            } else {
                // Handle error
                errorMessage = message
            }
        }
    }
}

#Preview {
    SignUp()
}

//
//  ContentView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct SignIn: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State var email = ""
    @State var password = ""
    @State private var isPresentingSignUp = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Text("Sign In")
                        .font(.system(size: 34, weight: .bold))
                    Text("Highly for travelers!!!")
                        .foregroundColor(.secondary)
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
                Button(action: logIn) {
                    HStack {
                        Text("Sign in")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .largeButton()
                }
                .disabled(isLoading)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                HStack {
                    Rectangle().frame(height: 1).opacity(0.1)
                    Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                    Rectangle().frame(height: 1).opacity(0.1)
                }

                HStack {
                    Text("Don’t have an account? ")
                        .customFont(.subheadline)
                        .foregroundColor(.secondary)
                    Button(action: {
                        isPresentingSignUp = true
                    }) {
                        Text("Sign up")
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
            .blur(radius: isLoading ? 3.0 : 0.0)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
            }
        }
        .fullScreenCover(isPresented: $isPresentingSignUp) {
            SignUp()
                .environmentObject(authManager)
        }
    }

    func logIn() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        isLoading = true
        authManager.signIn(email: email.trimmingCharacters(in: .whitespaces), password: password) { success, message in
            isLoading = false
            if !success {
                alertMessage = message
                showAlert = true
            }
        }
    }
}

#Preview {
    SignIn()
}



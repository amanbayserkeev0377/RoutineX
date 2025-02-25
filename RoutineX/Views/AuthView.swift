//
//  AuthView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Sign in") {
                authViewModel.signIn(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Button ("Sign up") {
                authViewModel.signUp(email: email, password: password)
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

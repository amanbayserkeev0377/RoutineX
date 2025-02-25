//
//  AuthViewModel.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        authListener = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
    deinit {
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.user = result?.user
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.user = result?.user
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

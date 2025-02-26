//
//  SettingsView.swift
//  RoutineX
//
//  Created by Aman on 25/2/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("theme") private var selectedTheme: String = "System"
    @State private var notificationsEnabled = true

    let themes = ["Light", "Dark", "System"]

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("APPEARANCE")) {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0").foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

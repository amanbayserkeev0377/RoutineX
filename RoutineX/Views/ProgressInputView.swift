import SwiftUI

struct ProgressInputView: View {
    let habit: HabitEntity
    @ObservedObject var habitViewModel: HabitViewModel
    @Binding var isPresented: Bool
    
    @State private var progressInput: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Add Progress for \(habit.title ?? "Habit")")
                    .font(.headline)
                
                TextField("Enter progress", text: $progressInput)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Save") {
                    if let value = Double(progressInput) {
                        habitViewModel.addProgress(to: habit, value: value)
                    }
                    isPresented = true
                }
                .disabled(progressInput.isEmpty)
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

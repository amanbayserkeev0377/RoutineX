import SwiftUI

struct SaveButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Save")
                .fontWeight(.semibold)
                .foregroundStyle(isEnabled ? .black : .gray)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    HStack {
        Spacer()
        SaveButton(isEnabled: true) {
            print("Habit saved!")
        }
    }
    .padding()
}

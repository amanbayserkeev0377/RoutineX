import SwiftUI

struct FloatingAddButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title)
                .frame(width: 55, height: 55)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding()
    }
}

#Preview {
    FloatingAddButton(action: {})
}

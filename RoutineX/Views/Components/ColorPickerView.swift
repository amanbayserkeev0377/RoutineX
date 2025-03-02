import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color?
    @State private var customColor: Color = .black
    
    let colors: [Color] = [.red, .yellow, .orange, .green, .blue, .purple, .pink, .gray]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(colors, id: \.self) { color in
                    colorCircle(color)
                }
                customColorCircle()
            }
            .padding(.horizontal)
        }
    }
    
    private func colorCircle(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
            )
            .onTapGesture {
                selectedColor = color
            }
    }

    private func customColorCircle() -> some View {
        return ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
            Circle()
                .fill(customColor)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2)
                )
            ColorPicker("", selection: $customColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 32, height: 32)
                .background(Color.clear)
        }
        .contentShape(Circle())
        .onAppear {
            if customColor == .black {
                customColor = .clear
            }
        }
        .onChange(of: customColor) {
            selectedColor = customColor
        }
    }
}


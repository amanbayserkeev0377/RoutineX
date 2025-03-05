import SwiftUI
import UIKit

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = CustomEmojiTextField()
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 48)
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.async {
            if self.text != uiView.text, let newText = uiView.text, !newText.isEmpty {
                self.text = newText
                context.coordinator.parent.text = newText
                print("Emoji updated:", self.text) // LOG
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        
        init(_ parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string.isEmpty {
                DispatchQueue.main.async {
                    self.parent.text = ""
                }
                return true
            }
            
            if string.count == 1, string.unicodeScalars.first?.properties.isEmoji == true {
                DispatchQueue.main.async {
                    self.parent.text = string
                }
                return false
            }
            return false
        }
        
    }
}

class CustomEmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return super.textInputMode
    }
}

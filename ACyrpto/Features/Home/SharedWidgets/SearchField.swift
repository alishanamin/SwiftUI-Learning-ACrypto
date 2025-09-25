import SwiftUI

struct ModernSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search"
    

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
            Spacer()
            
            if !text.isEmpty
            {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        text = ""
                        UIApplication.shared.hideKeyboard()
                        
                    }
            }
                
        }
        .padding(10)
        .background(.ultraThinMaterial) 
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray.opacity(0.25), lineWidth: 0.5)
        )
        
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var search = ""
        var body: some View {
            ModernSearchField(text: $search, placeholder: "Search")
        }
    }
    return PreviewWrapper()
}


import SwiftUI
import SwiftData

struct RepeatEndView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var repeatendEnabled: Bool
    @Binding var repeatend: Date?
    
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text("무한 반복")
                        .foregroundColor(.primary)
                    Spacer()
                    if !repeatendEnabled {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    repeatendEnabled = false
                    repeatend = nil
                    dismiss()
                }
                
                HStack {
                    Text("반복 종료 날짜")
                        .foregroundColor(.primary)
                    Spacer()
                    if repeatendEnabled {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    repeatendEnabled = true
                }
                
                if repeatendEnabled {
                    DatePicker(
                        "반복 종료 날짜",
                        selection: Binding(
                            get: { repeatend ?? Date() },
                            set: { repeatend = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                }
            }
            .navigationTitle("반복 종료")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

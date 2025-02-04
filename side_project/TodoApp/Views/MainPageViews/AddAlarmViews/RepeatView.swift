import SwiftUI
import SwiftData

struct RepeatView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var daterepeatEnabled: Bool
    @Binding var daterepeat: RepeatFrequency

    
    var body: some View {
        NavigationStack {
            List {
                ForEach(RepeatFrequency.allCases, id: \.self) { frequency in
                    HStack {
                        Text(frequency.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if frequency == daterepeat {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        daterepeat = frequency
                        daterepeatEnabled = frequency != .none //.none이 아니면 true 설정
                        dismiss()
                    }
                }
            }
            .navigationTitle("반복")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

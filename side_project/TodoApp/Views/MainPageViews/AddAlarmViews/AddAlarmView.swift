import SwiftUI
import SwiftData

struct AddAlarmView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var memo: String = ""
    @State private var priority: Priority = .none
    @State private var dateEnabled = false
    @State private var date: Date? = nil
    @State private var timeEnabled = false
    @State private var time: Date? = nil
    @State private var daterepeatEnabled = false
    @State private var daterepeat: RepeatFrequency = .none
    @State private var repeatendEnabled = false
    @State private var repeatend: Date? = nil
    @State private var locationEnabled = false
    @State private var location: String? = nil
    @State private var userlist: UserList? = nil

    @State private var showingDetail = false
    @State private var showingListView = false
    
    let colors: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "brown"]
    let colorMap: [String: Color] = [
        "red": .red,
        "orange": .orange,
        "yellow": .yellow,
        "green": .green,
        "blue": .blue,
        "purple": .purple,
        "brown": .brown
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("제목", text: $title)
                    
                    ZStack(alignment: .topLeading) {
                        if memo.isEmpty {
                            Text("메모")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.top, 10)
                        }
                        
                        TextEditor(text: $memo)
                            .frame(minHeight: 100)
                            .padding(.leading, -5)
                    }
                    
                    
                }
                Section {
                    NavigationLink(destination: DetailView(
                        priority: $priority,
                        dateEnabled: $dateEnabled,
                        date: $date,
                        timeEnabled: $timeEnabled,
                        time: $time,
                        daterepeatEnabled: $daterepeatEnabled,
                        daterepeat: $daterepeat,
                        repeatendEnabled: $repeatendEnabled,
                        repeatend: $repeatend,
                        locationEnabled: $locationEnabled,
                        location: $location
                    )) {
                        Text("세부사항")
                    }
                }
                Section {
                    NavigationLink(destination: SlectListView(userlist: $userlist)) {
                        HStack {
                            iconBox(systemImage: "list.bullet.circle.fill", backgroundColor: .blue)
                            
                            Text(userlist?.name ?? "목록 없음")
                            
                            Spacer()
                        }
                    }
                }

                
            }
            .navigationTitle("새로운 미리 알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("추가") {
                        let todo = TodoItem(title: title,
                                            memo: memo,
                                            priority: priority,
                                            date: dateEnabled ? date : nil,
                                            time: timeEnabled ? time : nil,
                                            daterepeat: daterepeat,
                                            location: locationEnabled ? location : nil,
                                            userlist: userlist
                        )
                        modelContext.insert(todo)
                        dismiss()
                    }
                }
            }
            
        }
        
    }
    private func iconBox(systemImage: String, backgroundColor: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 32, height: 32)
            Image(systemName: systemImage)
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
    }
    private func settingRow(title: String, systemImage: String, backgroundColor: Color, toggleBinding: Binding<Bool>) -> some View {
        HStack {
            iconBox(systemImage: systemImage, backgroundColor: backgroundColor)
            Toggle(title, isOn: toggleBinding)
                .padding(.leading, 10)
        }
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

import SwiftUI
import SwiftData

struct AddAlarmView: View {
    // 데이터 저장소에 접근할 수 있는 환경 변수
    // SwiftData의 ModelContext 환경을 가져와 데이터 조작에 사용
    @Environment(\.modelContext) private var modelContext
    // 나를 호출한 뷰에서 닫기 기능을 동작 시키는 환경 변수(클로저)
    // 현재 화면을 닫기 위한 dismiss 환경 변수
    @Environment(\.dismiss) private var dismiss
    
    // SwiftData에서 카테고리를 쿼리
    //@Query private var categories: [Category]
    
    // 새로운 Todo 항목의 제목, 우선순위, 마감일 등을 관리할 상태 변수
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
    @State private var selectedCategory: Category?
    
    
    
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
                // Todo 입력 섹션
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
                            
                            // ✅ 선택된 목록이 없을 경우 "목록 없음", 있을 경우 해당 목록 이름 표시
                            Text(userlist?.name ?? "목록 없음")
                            
                            Spacer()
                        }
                    }
                }

                
            }
            .navigationTitle("새로운 미리 알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 취소 버튼: 현재 화면 닫기
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                // 저장 버튼: 새로운 Todo 항목 저장
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
                                            //category: selectedCategory
                        )
                        modelContext.insert(todo) // 모델 컨텍스트에 항목 삽입
                        // 뷰 닫기와 동시에 모델 컨텍스트 저장이 호출된다.
                        dismiss() // 화면 닫기
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

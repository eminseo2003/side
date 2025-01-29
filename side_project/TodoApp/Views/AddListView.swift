import SwiftUI
import SwiftData

struct AddListView: View {
    // 데이터 저장소에 접근할 수 있는 환경 변수
    // SwiftData의 ModelContext 환경을 가져와 데이터 조작에 사용
    @Environment(\.modelContext) private var modelContext
    // 나를 호출한 뷰에서 닫기 기능을 동작 시키는 환경 변수(클로저)
    // 현재 화면을 닫기 위한 dismiss 환경 변수
    @Environment(\.dismiss) private var dismiss
    
    // SwiftData에서 카테고리를 쿼리
    @Query private var categories: [Category]
    
    // 새로운 Todo 항목의 제목, 우선순위, 마감일 등을 관리할 상태 변수
    @State private var title: String = ""
    @State private var memo: String = ""
    @State private var priority: Priority = .medium
    @State private var dateEnabled = false
    @State private var date: Date? = nil
    @State private var selectedCategory: Category?
    
    // 새로운 카테고리 추가 팝업 상태 및 새 카테고리 이름 관리
    @State private var isAddingCategory = false
    @State private var newCategoryName = ""
    
    @State private var showingDetail = false
    @State private var showingListView = false
    
    
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
                    Text("")
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
                                            priority: priority,
                                            date: dateEnabled ? date : nil,
                                            category: selectedCategory
                        )
                        modelContext.insert(todo) // 모델 컨텍스트에 항목 삽입
                        // 뷰 닫기와 동시에 모델 컨텍스트 저장이 호출된다.
                        dismiss() // 화면 닫기
                    }
                }
            }
            
        }
        
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

//import SwiftUI
//import SwiftData
//
//struct AddTodoView: View {
//    // 데이터 저장소에 접근할 수 있는 환경 변수
//    // SwiftData의 ModelContext 환경을 가져와 데이터 조작에 사용
//    @Environment(\.modelContext) private var modelContext
//    // 나를 호출한 뷰에서 닫기 기능을 동작 시키는 환경 변수(클로저)
//    // 현재 화면을 닫기 위한 dismiss 환경 변수
//    @Environment(\.dismiss) private var dismiss
//    
//    // SwiftData에서 카테고리를 쿼리
//    @Query private var categories: [Category]
//    
//    // 새로운 Todo 항목의 제목, 우선순위, 마감일 등을 관리할 상태 변수
//    @State private var title: String = ""
//    @State private var priority: Priority = .medium
//    @State private var dueDateEnabled = false
//    @State private var dueDate: Date? = nil
//    @State private var selectedCategory: Category?
//    
//    // 새로운 카테고리 추가 팝업 상태 및 새 카테고리 이름 관리
//    @State private var isAddingCategory = false
//    @State private var newCategoryName = ""
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                // Todo 입력 섹션
//                Section {
//                    TextField("제목", text: $title) // 제목 입력 필드
//                    Picker("우선순위", selection: $priority) { // 우선순위 선택
//                        ForEach(Priority.allCases, id: \.self) {
//                            priority in
//                            Text(priority.title)
//                                .tag(priority)
//                        }
//                    }
//                    Toggle("마감일 설정", isOn: $dueDateEnabled) // 마감일 활성화 여부 토글
//                    if dueDateEnabled {
//                        DatePicker("마감일", // 마감일 선택
//                                   selection: Binding(get: {
//                            dueDate ?? Date()
//                        }, set:{
//                            dueDate = $0
//                        }))
//                    }
//                }
//                
//                // 카테고리 선택 및 추가 섹션
//                Section("Category") {
//                    Picker("카테고리", selection: $selectedCategory) {
//                        Text("선택안함").tag(Optional<Category>.none) // 선택안함 옵션
//                        ForEach(categories) { category in
//                            Text(category.name ?? "-").tag(Optional(category))
//                        }
//                    }
//                    Button("카테고리 추가") { // 새로운 카테고리 추가 버튼
//                        isAddingCategory = true
//                    }
//                }
//            }
//            .navigationTitle("New Todo") // 네비게이션 타이틀 설정
//            .toolbar {
//                // 취소 버튼: 현재 화면 닫기
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                // 저장 버튼: 새로운 Todo 항목 저장
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        let todo = TodoItem(title: title,
//                                            priority: priority,
//                                            dueDate: dueDateEnabled ? dueDate : nil,
//                                            category: selectedCategory
//                        )
//                        modelContext.insert(todo) // 모델 컨텍스트에 항목 삽입
//                        // 뷰 닫기와 동시에 모델 컨텍스트 저장이 호출된다.
//                        dismiss() // 화면 닫기
//                    }
//                }
//            }
//            // 카테고리 추가 팝업
//            .alert("카테고리 추가",
//                isPresented: $isAddingCategory
//            ) {
//                TextField("카테고리 이름", text: $newCategoryName) // 새 카테고리 이름 입력 필드
//                HStack {
//                    Button("취소") { // 카테고리 추가 취소
//                        newCategoryName = ""
//                    }
//                    Button("추가") { // 카테고리 추가 확인
//                        if !newCategoryName.isEmpty {
//                            let category = Category(name: newCategoryName)
//                            modelContext.insert(category) // 새 카테고리 저장
//                        }
//                    }
//                }
//            } message: {
//                Text("카테고리 이름을 입력하세요.")
//            }
//        }
//    }
//}
//
////#Preview {
////    AddTodoView()
////        .modelContainer(PreviewContainer.shared.container)
////}

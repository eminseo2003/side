//
//  EditTodoView.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/20/25.
//

import SwiftUI
import SwiftData

// 할 일(Todo) 아이템을 수정하는 뷰
struct EditTodoView: View {
    // 현재 뷰를 닫을 수 있는 dismiss 환경 변수
    @Environment(\.dismiss) private var dismiss
    
    // 데이터 모델에서 카테고리 목록을 가져옴
    @Query private var categories: [Category]
    
    // 수정할 TodoItem 객체
    let todo: TodoItem
    
    // 제목, 우선순위, 마감일, 선택된 카테고리 등의 상태를 관리
    @State private var title: String = ""
    @State private var priority: Priority
    @State private var dueDateEnabled = false // 마감일 설정 여부를 추적
    @State private var dueDate: Date? = nil // 선택된 마감일
    @State private var selectedCategory: Category? // 선택된 카테고리
    
    // 초기화 메서드: 수정할 TodoItem의 기존 데이터를 상태 값으로 초기화
    init(todo: TodoItem) {
        self.todo = todo
        self._title = State(initialValue: todo.title) // 제목 초기화
        self._priority = State(initialValue: todo.priority) // 우선순위 초기화
        self._dueDateEnabled = State(initialValue: todo.dueDate != nil) // 마감일 설정 여부 초기화
        self._dueDate = State(initialValue: todo.dueDate) // 마감일 초기화
    }
    
    var body: some View {
        // NavigationStack 이 팝업일 경우에만 사용되어 뷰에서 분리함
        // 다른 NavigationStack 에서 페이지를 부를 경우 오류가 발생함 (중복 NavigationStack)
        
        // 폼 형식으로 UI 구성
        Form {
            // 기본 정보 입력 섹션
            Section {
                // 제목 입력 필드
                TextField("Title", text: $title)
                // 우선순위를 선택하는 피커
                Picker("우선순위", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) {
                        priority in
                        Text(priority.title) // 우선순위 이름 표시
                            .tag(priority) // 각 우선순위 태그
                    }
                }
                // 마감일 설정 토글
                Toggle("마감일 설정", isOn: $dueDateEnabled)
                // 마감일 선택기 (마감일 설정이 활성화된 경우만 표시)
                if dueDateEnabled {
                    DatePicker("마감일",
                               selection: Binding(get: {
                        dueDate ?? Date() // 마감일이 없으면 기본값으로 현재 날짜 사용
                    }, set:{
                        dueDate = $0 // 선택된 날짜를 저장
                    }))
                }
            }
            // 카테고리 선택 섹션
            Section("Category") {
                // 카테고리를 선택하는 피커
                Picker("카테고리", selection: $selectedCategory) {
                    // 선택하지 않음 옵션
                    Text("선택안함").tag(Optional<Category>.none)
                    // 카테고리 목록을 순회하며 각 항목을 표시
                    ForEach(categories) { category in
                        Text(category.name ?? "-").tag(Optional(category)) // 각 카테고리 태그
                    }
                }
            }
        }
        // 네비게이션 바의 제목 설정
        .navigationTitle("Edit Todo")
        // 네비게이션 바의 툴바 설정
        .toolbar {
            // 저장 버튼
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // 수정 기능
                    // TodoItem의 데이터 업데이트
                    todo.title = title
                    todo.priority = priority
                    todo.dueDate = dueDateEnabled ? dueDate : nil // 마감일 설정 여부에 따라 저장
                    todo.category = selectedCategory
                    // 뷰 닫기와 동시에 모델 컨텍스트 저장이 호출된다.
                    dismiss()// 뷰 닫기 (변경사항 자동 저장)
                }
            }
            // 취소 버튼
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    // 수정 취소 기능
                    dismiss()// 뷰 닫기 (변경사항 저장하지 않음)
                }
            }
        }
    }
}

//#Preview {
//    EditTodoView(todo: TodoItem(title: "Hello, world!"))
//        .modelContainer(PreviewContainer.shared.container)
//}

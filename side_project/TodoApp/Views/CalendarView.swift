//
//  CalendarView.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import SwiftUI
import SwiftData

// 캘린더와 선택한 날짜의 할 일 목록을 보여주는 메인 뷰
struct CalendarView: View {
    // 데이터 모델에서 TodoItem 객체 목록을 가져옴
    @Query private var todos: [TodoItem]
    
    // 캘린더에서 현재 선택된 날짜를 추적
    @State private var selectedDate: Date = Date()
    
    // 선택한 날짜에 해당하는 할 일 목록을 필터링
    private var todosForSelectedDate: [TodoItem] {
        todos.filter { todo in
            // 할 일의 마감일이 존재하고, 선택된 날짜와 동일한 날인지 확인
            todo.dueDate != nil ? Calendar.current.isDate(todo.dueDate!, inSameDayAs: selectedDate) : false
        }
    }
    
    var body: some View {
        // 네비게이션 스택을 사용하여 앱 내에서 탐색 가능
        NavigationStack {
            VStack {
                // 사용자가 날짜를 선택할 수 있는 그래픽 캘린더
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical) // 캘린더 스타일로 설정
                    .padding()
                
                // 선택된 날짜의 할 일 목록을 보여주는 리스트
                List {
                    // 필터링된 할 일 목록을 순회하며 각 할 일을 표시
                    ForEach(todosForSelectedDate) { todo in
                        TodoRowView(todo: todo) // 할 일 항목을 표시하는 커스텀 Row View
                    }
                }
            }
            .navigationTitle("Calendar")
        }
    }
}

//#Preview {
//    CalendarView()
//        .modelContainer(PreviewContainer.shared.container)
//}

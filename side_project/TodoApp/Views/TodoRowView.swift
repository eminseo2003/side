import SwiftUI

//개별 Todo 항목을 목록 형태로 시각화하며, 제목, 완료 여부, 마감일, 카테고리, 우선순위 정보를 표시
struct TodoRowView: View {
    // Todo 항목 데이터를 전달받는 프로퍼티
    let todo: TodoItem
    // 카테고리 표시 여부를 제어하는 프로퍼티
    let showCategory: Bool
    
    // 초기화 메서드에서 기본값 설정
    init(todo: TodoItem, showCategory: Bool = true) {
        self.todo = todo
        self.showCategory = showCategory
    }
    // "Edit Todo" 팝업 표시 여부를 제어하는 상태
    @State private var showingEditView: Bool = false
    
    var body: some View {
        HStack {
            // 완료 여부에 따라 체크박스 아이콘 표시
            Image(systemName: todo.isCompleted ? "checkmark.square.fill" : "square")
                .foregroundStyle(todo.isCompleted ? .green : .gray)
            VStack(alignment: .leading) {
                // Todo 제목 표시 (완료 시 취소선 표시)
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                // 마감일 표시 (마감이 지난 경우 빨간색으로 강조)
                if let dueDate = todo.dueDate {
                    Text(dueDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                        .font(.caption)
                        .foregroundStyle(dueDate > Date.now ? .gray : .red)
                }
            }
            Spacer()
            
            // 카테고리 표시 (옵션 설정에 따라 표시 여부 결정)
            if showCategory,
               let category = todo.category {
                Text(category.name ?? "-")
                    .font(.caption)
                    .padding(4)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(.rect(cornerRadius: 4))
            }
            // 우선순위 배지 표시
            PriorityBadge(priority: todo.priority)
        }
        // 항목을 탭하면 완료 상태를 토글
        .onTapGesture {
            todo.isCompleted.toggle()
        }
        // 길게 누르면 "Edit Todo" 팝업 표시
        .onLongPressGesture(minimumDuration: 0.5) {
            showingEditView = true
        }
        
        // 왼쪽에서 스와이프하여 "Detail" 화면으로 이동
        .swipeActions(edge: .leading) {
            NavigationLink(value: TodoNavigation.detail(todo)) {
                Text("Detail")
            }
            .tint(.yellow) // 스와이프 버튼 색상 설정
        }
        // "Edit Todo" 팝업 표시
        .sheet(isPresented: $showingEditView) {
            // 팝업 내에서 독립적인 네비게이션 스택 추가
            // EditTodoView 안에서 빠진 NavigationStack 을 추가함
            // ( 팝업일 경우 네비게이션 바 제목을 출력하려면, 독립적인 NavigationStack 따로 필요함 )
            NavigationStack {
                EditTodoView(todo: todo)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        List {
//            TodoRowView(todo: TodoItem(title: "Hello, world!", dueDate: Date().addingTimeInterval(1000),
//                                       category: Category(name: "업무")))
//        }
//        .navigationTitle("Todo List")
//    }
//}

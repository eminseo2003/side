import SwiftUI
import SwiftData

// 네비게이션 경로에 따라 분기 처리를 위한 열거형
// TodoNavigation은 TodoItem과 관련된 화면 전환을 정의
// Hashable 프로토콜을 채택해 네비게이션에서 사용 가능

// 한가지 데이터 타입에 대해서, 다른 네비게이션 경로를 가질경우
// enum 값을 이용해서, 분기 처리를 해야 한다.
// (NavigationLink 는 Hashable 값을 가져야 하기 때문에, Hashable 프로토콜을 추가 해준다. )
enum TodoNavigation: Hashable {
    case detail(TodoItem) // 상세보기 화면
    case edit(TodoItem) // 편집 화면
}

//Todo 항목의 전체 목록(TodoItem 배열)을 관리하고 표시
struct TodoListView: View {
    // SwiftData의 ModelContext를 사용하기 위해 환경 변수로 주입
    @Environment(\.modelContext) private var modelContext
    
    // 검색 텍스트와 우선순위 필터를 저장하는 프로퍼티
    let searchText: String
    let priorityFilter: Priority?
    
    // SwiftData의 카테고리와 TodoItem 쿼리
    @Query private var categories: [Category]
    @Query private var todos: [TodoItem]
    
    // 초기화 메서드에서 쿼리 조건을 설정
    init(searchText: String = "", priorityFilter: Priority? = nil) {
        self.searchText = searchText
        self.priorityFilter = priorityFilter
        
        // 검색 조건에 따라 TodoItem을 필터링하는 쿼리 생성
        let predicate = #Predicate<TodoItem> { todo in
            searchText.isEmpty ? true : todo.title.contains(searchText) == true
        }
        
        // 생성된 쿼리를 todos 변수에 연결
        _todos = Query(filter: predicate, sort: [SortDescriptor(\TodoItem.createdAt)])
    }
    
    // 카테고리와 우선순위 필터를 적용한 TodoItem 리스트 반환
    func filteredTodos(category: Category? = nil) -> [TodoItem] {
        let categoryTodos = todos.filter { $0.category == category }        
        if let priority = priorityFilter {
            return categoryTodos.filter { $0.priority == priority }
        }
        return categoryTodos
    }
    
    var body: some View {
        List {
            // 카테고리가 없는 TodoItem 섹션
            Section("카테고리 없음") {
                ForEach(filteredTodos(category: nil)) { item in
                    TodoRowView(todo: item, showCategory: false) // TodoRowView로 각 항목 표시
                }
                .onDelete(perform: deleteItems) // 삭제 액션 처리
            }
            // 각 카테고리별 TodoItem 섹션 생성
            ForEach(categories) { category in
                Section(category.name ?? "-") {
                    ForEach(filteredTodos(category: category)) { item in
                        TodoRowView(todo: item, showCategory: false)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        // TodoNavigation을 사용해 화면 전환 분기 처리
        // 생성한 enum 값을 이용해서, 분기 처리를 한다.
        .navigationDestination(for: TodoNavigation.self) { navigation in
            switch navigation {
                case .detail(let item):
                    TodoDetailView(item: item) // 상세보기 화면으로 이동
                case .edit(let item):
                    EditTodoView(todo: item) // 편집 화면으로 이동
            }
        }
    }
    // TodoItem 삭제 처리
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(todos[index]) // SwiftData에서 삭제
            }
        }
    }
    
}

//#Preview {
//    TodoListView()
//        .modelContainer(PreviewContainer.shared.container)
//}


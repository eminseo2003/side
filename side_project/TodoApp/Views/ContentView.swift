import SwiftUI
import SwiftData

struct ContentView: View {
    // 리스트 페이지로 modelContext 기능이 이동하여 삭제됨
    
    // "Add Todo" 모달을 표시할지 여부를 상태로 관리
    @State private var showingAddTodo = false
    // 검색창 텍스트를 상태로 관리
    @State private var searchText = ""
    // 우선순위 필터를 상태로 관리 (초기값은 nil로 설정하여 전체 보기)
    @State private var priorityFilter: Priority? = nil
        
    var body: some View {
        // TabView를 사용하여 화면을 탭으로 분리
        TabView {
            // 첫 번째 탭: Todo 리스트
            NavigationStack {
                VStack {
                    // 우선순위 필터 버튼 영역
                    HStack {
                        // 전체 보기 버튼
                        Button {
                            priorityFilter = nil // 우선순위 필터 초기화
                        } label: {
                            Text("전체")
                                .font(.caption)
                                .padding(4)
                                .foregroundColor(.white)
                                .background(.gray)
                                .clipShape(.rect(cornerRadius: 4))
                                .overlay {
                                    if priorityFilter == nil {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(.blue, lineWidth: 2) // 선택된 상태 강조
                                    }
                                }
                            
                        }
                        // enum 타입에 CaseIterable 프로토콜을 사용하면, 반복문에 allCases 프로퍼티를 사용할 수 있다.
                        // Priority 열거형의 모든 케이스에 대해 필터 버튼 생성
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Button {
                                priorityFilter = priority // 선택된 우선순위로 필터 설정
                            } label: {
                                PriorityBadge(priority: priority) // 우선순위 배지를 표시하는 뷰
                            }
                            .overlay {
                                if priorityFilter == priority {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(.blue, lineWidth: 2) // 선택된 상태 강조
                                }
                            }
                        }
                    }
                    // TodoListView 표시 (검색 및 우선순위 필터 포함)
                    TodoListView(searchText: searchText, priorityFilter: priorityFilter)
                        .searchable(text: $searchText, prompt: "할 일 검색") // 검색 기능 활성화
                        .navigationTitle("Todo List") // 네비게이션 타이틀 설정
                        .toolbar {
                            // 네비게이션 바의 설정 버튼
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink {
                                    CategoryListView() // 카테고리 리스트 화면으로 이동
                                } label: {
                                    Image(systemName: "gearshape.fill") // 설정 아이콘
                                }
                            }
                            // "Add Todo" 버튼
                            ToolbarItem {
                                Button(action: {
                                    showingAddTodo = true // "Add Todo" 모달 표시
                                }) {
                                    Label("Add Item", systemImage: "plus") // 플러스 아이콘
                                }
                            }
                        }
                }
            }
            .tabItem {
                Label("List", systemImage: "list.bullet") // 첫 번째 탭: 리스트
            }
            
            // 두 번째 탭: 캘린더 뷰
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar") // 캘린더 탭
                }
        }
        // "Add Todo" 모달을 표시
        .sheet(isPresented: $showingAddTodo) {
            AddTodoView() // 새로운 Todo를 추가하는 뷰
        }
    }
    
}

//#Preview {
//    ContentView()
//        .modelContainer(PreviewContainer.shared.container)
//}

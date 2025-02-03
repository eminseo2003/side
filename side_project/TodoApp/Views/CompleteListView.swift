import SwiftUI
import SwiftData

struct CompleteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userLists: [UserList]
    
    @State private var showingAddAlarm = false
    @State private var showingSortOptions = false
    @State private var showingDeleteAlert = false
    
    var todos: [TodoItem] {
        let items = userLists.flatMap { $0.todos ?? [] }
            .filter { $0.isCompleted }
        return sortedTodos(items)
    }
    
    let listColor: Color = .black.opacity(0.6)
    let title: String = "완료됨"
    
    @State private var selectedSortOption: SortOption = .manual
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(listColor)
                
            }
            HStack {
                Text("\(todos.count)개 완료됨 ")
                    .foregroundColor(.gray)
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Text("지우기")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("완료된 모든 항목 삭제"),
                        message: Text("모든 완료된 미리 알림을 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            deleteAllCompletedTodos()
                        },
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
            
            List {
                ForEach(todos) { todo in
                    
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Image(systemName: todo.isCompleted ? "circle.inset.filled" : "circle")
                                .foregroundColor(todo.isCompleted ? listColor : .gray)
                                .onTapGesture {
                                    toggleCompletion(for: todo)
                                    
                                }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    priorityText(todo.priority)
                                    titleText(todo)
                                }
                                
                                Text(todo.memo)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                HStack(spacing: 0) {
                                    if let date = todo.date {
                                        Text(formattedDate(date))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    if let time = todo.time {
                                        Text(formattedTime(time))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    if todo.daterepeat != .none {
                                        Image(systemName: "repeat")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(" \(todo.daterepeat.rawValue)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                if let location = todo.location {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.gray.opacity(0.2))
                                        HStack {
                                            Image(systemName: "location.fill")
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            
                                            Text(location)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Spacer()
                                            
                                        }
                                        .padding(.leading, 5)
                                        
                                    }
                                    
                                }
                                
                            }
                            .padding(.leading, 8)
                            
                            
                            
                            
                        }
                        
                        
                    }
                }
                .onDelete(perform: deleteTodo)
            }
            .listStyle(.plain)
            .padding(.leading, -10)
            
            
        }
        .toolbar {
            // 취소 버튼: 현재 화면 닫기
            ToolbarItem(placement: .navigationBarLeading) {
                Button("") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    
                    
                    Button(action: {
                        // 미리 알림 선택 기능 추가
                    }) {
                        Label("미리 알림 선택", systemImage: "checkmark.circle")
                    }
                    Button(action: {
                        // 프린트 기능
                    }) {
                        Label("프린트", systemImage: "printer")
                    }
                    
                    
                } label: {
                    Image(systemName: "ellipsis.circle") // 상단 우측 '더보기' 아이콘
                        .imageScale(.large)
                }
                
            }
            
            
        }
        .padding()
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView()
        }
        
        
    }
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todoToDelete = todos[index]
            modelContext.delete(todoToDelete)
        }
    }
    
    private func deleteAllCompletedTodos() {
        userLists.forEach { list in
            list.todos?.removeAll { $0.isCompleted }
        }
    }
    private func toggleCompletion(for todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            
            
        }
    }
    
    private func titleText(_ todo: TodoItem) -> Text {
        if todo.isCompleted {
            return Text(todo.title).foregroundColor(.black.opacity(0.5))
        } else {
            return Text(todo.title).foregroundColor(.black)
        }
    }
    @ViewBuilder
    private func priorityText(_ priority: Priority) -> some View {
        switch priority {
        case .low:
            Text("!").foregroundColor(listColor)
        case .medium:
            Text("!!").foregroundColor(listColor)
        case .high:
            Text("!!!").foregroundColor(listColor)
        default:
            EmptyView()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.M.d. "
        return formatter.string(from: date)
    }
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm "
        return formatter.string(from: date)
    }
    private func sortedTodos(_ todos: [TodoItem]) -> [TodoItem] {
        switch selectedSortOption {
        case .manual:
            return todos
        case .dueDate:
            return todos.sorted { ($0.date ?? Date.distantFuture) < ($1.date ?? Date.distantFuture) }
        case .createdDate:
            return todos.sorted { $0.createdAt < $1.createdAt }
        case .priority:
            return todos.sorted { $0.priority.rawValue > $1.priority.rawValue }
        case .title:
            return todos.sorted { $0.title < $1.title }
        }
    }
}

import SwiftUI
import SwiftData

struct FullListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userLists: [UserList]
    
    @State private var showingAddAlarm = false
    @State private var showingSortOptions = false
    @State private var showCompletedItems = false
    
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
    
    var todos: [TodoItem] {
        let items = userLists.flatMap { $0.todos ?? [] }
        let filteredItems = showCompletedItems ? items : items.filter { !$0.isCompleted }
        return sortedTodos(filteredItems)
    }
    let listColor: Color = .black
    let title: String = "전체"
    
    @State private var selectedSortOption: SortOption = .manual
    
    var groupedTodos: [UserList: [TodoItem]] {
        Dictionary(grouping: todos) { todo in
            todo.userlist ?? UserList(name: "미정")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(listColor)
                
            }
            List {
                ForEach(groupedTodos.keys.sorted(by: { $0.name < $1.name }), id: \.self) { userlist in
                    if let todosForUser = groupedTodos[userlist] {
                        Section(header: Text(userlist.name)
                            .font(.title3)
                            .padding(.leading, -10)
                            .foregroundColor(colorMap[userlist.color] ?? .black)
                        ) {
                            todoListView(todosForUser, color: colorMap[userlist.color] ?? .black)
                                .frame(maxHeight: .infinity)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .padding(.leading, -10)
            .frame(maxHeight: .infinity)
            
            
            HStack {
                Button(action: { showingAddAlarm = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("새로운 미리 알림")
                            .fontWeight(.bold)
                            .font(.headline)
                    }
                    .foregroundColor(listColor)
                }
                Spacer()
                
            }
            .padding(.vertical)
        }
        .toolbar {
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
                        showCompletedItems.toggle()
                    }) {
                        Label(showCompletedItems ? "완료된 항목 숨기기" : "완료된 항목 보기", systemImage: "eye")
                    }
                    
                    
                    
                    Button(action: {
                        // 프린트 기능
                    }) {
                        Label("프린트", systemImage: "printer")
                    }
                    
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
                
            }
            
            
        }
        .padding()
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView()
        }
        
        
    }
    private func todoListView(_ todos: [TodoItem], color: Color) -> some View {
        ForEach(todos) { todo in
            
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: todo.isCompleted ? "circle.inset.filled" : "circle")
                        .foregroundColor(todo.isCompleted ? color : .gray)
                        .onTapGesture {
                            toggleCompletion(for: todo)
                            
                        }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            priorityText(todo.priority, color: color)
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
        .frame(maxHeight: .infinity)
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
    private func priorityText(_ priority: Priority, color: Color) -> some View {
        switch priority {
        case .low:
            Text("!").foregroundColor(color)
        case .medium:
            Text("!!").foregroundColor(color)
        case .high:
            Text("!!!").foregroundColor(color)
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

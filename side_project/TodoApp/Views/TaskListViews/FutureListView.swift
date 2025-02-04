import SwiftUI
import SwiftData

struct FutureListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userLists: [UserList]
    
    @State private var showingAddAlarm = false
    @State private var showingSortOptions = false
    @State private var showCompletedItems = false
    
    var todos: [TodoItem] {
        let items = userLists.flatMap { $0.todos ?? [] }
            .filter { ($0.date ?? Date()) > Date()}
        let filteredItems = showCompletedItems ? items : items.filter { !$0.isCompleted }
        return sortedTodos(filteredItems)
    }
    
    let listColor: Color = .red
    let title: String = "예정"
    
    @State private var selectedSortOption: SortOption = .manual
    
    private func getMonth(from date: Date?) -> Int {
        guard let date = date else { return -1 }
        return Calendar.current.component(.month, from: date)
    }
    
    private func getYear(from date: Date?) -> Int {
        guard let date = date else { return -1 }
        return Calendar.current.component(.year, from: date)
    }
    var todayTodos: [TodoItem] {
        todos.filter { Calendar.current.isDateInToday($0.date ?? Date()) }
    }
    
    var thisMonthTodos: [TodoItem] {
        todos.filter { getMonth(from: $0.date) == currentMonth && getYear(from: $0.date) == currentYear }
    }
    
    
    
    var monthlyTodos: [Int: [TodoItem]] {
        Dictionary(grouping: todos.filter {
            let month = getMonth(from: $0.date)
            return month >= 1 && month <= 12 && month > currentMonth
        }, by: { getMonth(from: $0.date) })
    }

    
    var nextYearTodos: [TodoItem] {
        todos.filter { getYear(from: $0.date) > currentYear }
    }
    private let currentYear = Calendar.current.component(.year, from: Date())
    private let currentMonth = Calendar.current.component(.month, from: Date())
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(listColor)
                
            }
            List {
                Section(header: Text("오늘")
                    .font(.headline)
                    .foregroundColor(todayTodos.isEmpty ? .gray.opacity(0.5) : .gray)
                    .padding(.vertical, 0)
                ) {
                    if !todayTodos.isEmpty {
                        todoListView(todayTodos)
                    } else {
                        EmptyView().frame(height: 10)
                    }
                }
                Section(header: Text("\(currentMonth)월")
                    .font(.headline)
                    .foregroundColor(thisMonthTodos.isEmpty ? .gray.opacity(0.5) : .gray)
                    .padding(.vertical, 0)
                ) {
                    if !thisMonthTodos.isEmpty {
                        todoListView(thisMonthTodos)
                    } else {
                        EmptyView().frame(height: 10)
                    }
                }
                ForEach(currentMonth+1...12, id: \.self) { month in
                    if let todosForMonth = monthlyTodos[month], !todosForMonth.isEmpty {
                        Section(header: Text("\(month)월")
                            .font(.headline)
                            .foregroundColor(nextYearTodos.isEmpty ? .gray.opacity(0.5) : .gray)
                            .padding(.vertical, 0)) {
                            todoListView(todosForMonth)
                        }
                    }
                }

                
                Section(header: Text("내년 이후")
                    .font(.headline)
                    .foregroundColor(nextYearTodos.isEmpty ? .gray.opacity(0.5) : .gray)
                    .padding(.vertical, 0)
                ) {
                    if !nextYearTodos.isEmpty {
                        todoListView(nextYearTodos)
                    } else {
                        EmptyView().frame(height: 10)
                    }
                }
                
            }
            .listStyle(.plain)
            .padding(.leading, -10)
            
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
    private func todoListView(_ todos: [TodoItem]) -> some View {
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
                            if let userlist = todo.userlist {
                                Text("\(userlist.name) ")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
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


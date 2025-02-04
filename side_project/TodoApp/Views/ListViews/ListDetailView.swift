import SwiftUI
import SwiftData

struct ListDetailView: View {
    let title: String
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userLists: [UserList]
    
    @State private var showingAddAlarm = false
    @State private var showingListInfo = false
    @State private var showingSortOptions = false
    @State private var showCompletedItems = false
    @State private var todoEditMode = false
    @State private var showingTodoInfo = false
    
    let checkSize: CGFloat = 23
    
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
    @State private var editableTitle: String
    
    init(title: String) {
        self.title = title
        _editableTitle = State(initialValue: title)
    }
    
    private var todos: [TodoItem] {
        let items = userLists.first(where: { $0.name == title })?.todos ?? []
        let filteredItems = showCompletedItems ? items : items.filter { !$0.isCompleted }
        return sortedTodos(filteredItems)
    }
    private var listColor: Color {
        if let colorString = userLists.first(where: { $0.name == title })?.color {
            return colorMap[colorString] ?? .blue
        }
        return .blue
    }
    @State private var selectedColorString: String = "blue"
    @State private var selectedSortOption: SortOption = .manual
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(listColor)
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
                            .onTapGesture {
                                todoEditMode = true
                            }
                            Spacer()
                            if todoEditMode {
                                Button(action: {
                                    showingTodoInfo = true
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: checkSize))
                                }
                            }
                        }
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
                        showingListInfo = true
                    }) {
                        Label("목록 정보 보기", systemImage: "info.circle")
                    }
                    
                    Button(action: {
                        // 미리 알림 선택 기능 추가
                    }) {
                        Label("미리 알림 선택", systemImage: "checkmark.circle")
                    }
                    
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                selectedSortOption = option
                            }) {
                                Label(option.rawValue, systemImage: selectedSortOption == option ? "checkmark" : "")
                            }
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Label("다음으로 정렬", systemImage: "arrow.up.arrow.down")
                            Text(selectedSortOption.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        
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
                    
                    Button(action: {
                        deleteList()
                    }) {
                        Label("목록 삭제", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
                
            }
            if todoEditMode {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        todoEditMode = false
                    }
                }
            }
            
            
        }
        .padding()
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView()
        }
        .sheet(isPresented: $showingListInfo) {
            ListInfoView(
                selectedColorString: $selectedColorString,
                listName: $editableTitle
            )
        }
        .onAppear {
            selectedColorString = userLists.first(where: { $0.name == title })?.color ?? "blue"
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
    private func deleteList() {
        if let list = userLists.first(where: { $0.name == title }) {
            modelContext.delete(list)
            dismiss()
        }
    }
    
}

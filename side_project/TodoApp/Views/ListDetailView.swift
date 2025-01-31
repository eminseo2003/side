import SwiftUI
import SwiftData

struct ListDetailView: View {
    let title: String // ✅ 리스트 제목 (ex: "미리 알림")
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userLists: [UserList]
    
    @State private var showingAddAlarm = false
    @State private var showingListInfo = false
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
    
    // ✅ title을 이용하여 해당 리스트의 todos를 가져오기
    private var todos: [TodoItem] {
        userLists.first(where: { $0.name == title })?.todos ?? []
    }
    private var listColor: Color {
        if let colorString = userLists.first(where: { $0.name == title })?.color {
            return colorMap[colorString] ?? .blue
        }
        return .blue
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
                        //.padding(.bottom, -5)
                        
                        
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
            // 취소 버튼: 현재 화면 닫기
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
                        Button(action: { /* 수동 정렬 */ }) {
                            Text("수동")
                        }
                    } label: {
                        Label("다음으로 정렬", systemImage: "arrow.up.arrow.down")
                    }
                    
                    Button(action: {
                        showCompletedItems.toggle()
                    }) {
                        Label("완료된 항목 보기", systemImage: "eye")
                    }
                    
                    Button(action: {
                        // 프린트 기능 추가
                    }) {
                        Label("프린트", systemImage: "printer")
                    }
                    
                    Button(action: {
                        // 목록 삭제 기능 추가
                    }) {
                        Label("목록 삭제", systemImage: "trash")
                            .foregroundColor(.red)
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
        .sheet(isPresented: $showingListInfo) {
            //ListInfoView()
        }
    }
    private func toggleCompletion(for todo: TodoItem) {
            if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                todos[index].isCompleted.toggle()
                
                if todos[index].isCompleted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            deleteTodo(todo)
                        }
                    }
                }
            }
        }
    private func deleteTodo(_ todo: TodoItem) {
            if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                modelContext.delete(todos[index])
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
}

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userLists: [UserList]
    @State private var newListName: String = ""
    
    // "Add Todo" 모달을 표시할지 여부를 상태로 관리
    @State private var showingAddAlarm = false
    @State private var showingAddList = false
    // 검색창 텍스트를 상태로 관리
    @State private var searchText = ""
    // 우선순위 필터를 상태로 관리 (초기값은 nil로 설정하여 전체 보기)
    @State private var priorityFilter: Priority? = nil
    @State private var selectedList: TaskList? = nil
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    let iconSize: CGFloat = 30

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
    
    var body: some View {
        NavigationStack {
            ZStack {
                //색깔 지정 - gpt 사용
                Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        
                        Spacer()
                        Button(action: { showingAddAlarm = true }) {
                            Text("편집")
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                    
                    SearchBar(text: $searchText)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        listButton(title: "오늘", list: .today, icon: TodayIcon(iconSize: iconSize))
                        listButton(title: "예정", list: .future, icon: Image(systemName: "calendar.circle.fill").foregroundColor(.red))
                        listButton(title: "전체", list: .full, icon: Image(systemName: "tray.circle.fill").foregroundColor(.black))
                        listButton(title: "완료됨", list: .complete, icon: Image(systemName: "checkmark.circle.fill").foregroundColor(.black.opacity(0.6)))
                    }
                    Spacer()
                    HStack {
                        Text("나의 목록")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    VStack {
                        List {
                            ForEach(userLists, id: \.self) { list in
                                listRow(
                                    title: list.name,
                                    count: list.todos?.filter { !$0.isCompleted }.count ?? 0,
                                    iconColor: colorMap[list.color] ?? .blue
                                )
                            }
                            .onDelete(perform: deleteList)
                        }
                        .listStyle(.plain)
                        .background(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
                        .cornerRadius(12)
                        
                        
                    }
                    
                    Spacer()
                    HStack {
                        Button(action: { showingAddAlarm = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("새로운 미리 알림")
                                    .fontWeight(.bold)
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                        }
                        Spacer()
                        Button(action: { showingAddList = true }) {
                            Text("목록 추가")
                                .foregroundColor(.blue)
                                .font(.headline)
                        }
                    }
                    .padding(.vertical)
                    
                    
                    //                TodoListView(searchText: searchText, priorityFilter: nil)
                    
                    
                }
                .padding()
            }
            
        }
        // "Add Todo" 모달을 표시
        .sheet(isPresented: $showingAddList) {
            AddListView() // 새로운 Todo를 추가하는 뷰
        }
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView() // 새로운 Todo를 추가하는 뷰
        }
    }
    private func listButton(title: String, list: TaskList, icon: some View) -> some View {
        Button(action: {
            selectedList = list
        }) {
            VStack(alignment: .leading) {
                HStack {
                    icon
                        .font(.system(size: iconSize))
                    
                    Spacer()
                    
                    Text("0")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                Spacer()
                Text(title)
                    .foregroundColor(.gray)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            .padding()
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(Color(.white))
            .cornerRadius(12)
        }
        .navigationDestination(isPresented: Binding(
            get: { selectedList == list },
            set: { if !$0 { selectedList = nil } }
        )) {
            destinationView(for: list)
        }
    }
    @ViewBuilder
    private func destinationView(for list: TaskList) -> some View {
        switch list {
        case .today:
            TodayListView()
        case .future:
            FutureListView()
        case .full:
            FullListView()
        case .complete:
            CompleteListView()
        }
    }
    // ✅ 새로운 리스트 추가
    
    
    private func deleteList(at offsets: IndexSet) {
        for index in offsets {
            let listToDelete = userLists[index]
            modelContext.delete(listToDelete)
        }
    }
    private func listRow(title: String, count: Int, iconColor: Color) -> some View {
        NavigationLink(destination: ListDetailView(title: title)) {
            HStack {
                ZStack {
                    Image(systemName: "list.bullet.circle.fill")
                        .foregroundColor(iconColor)
                        .font(.system(size: iconSize, weight: .bold))
                }
                
                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(count)")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
            }
            .listRowBackground(Color.white) // 리스트 배경을 흰색으로 유지
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("검색", text: $text)
                .foregroundColor(.primary)
            
            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
        
    }
}
struct TodayIcon: View {
    let iconSize: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: iconSize, height: iconSize)
            
            VStack {
                Text(Date().formatted(.dateTime.day()))
                    .font(.system(size: iconSize/2, weight: .bold))
                    .foregroundColor(.white)
                
            }
        }
    }
}
//#Preview {
//    ContentView()
//        .modelContainer(PreviewContainer.shared.container)
//}

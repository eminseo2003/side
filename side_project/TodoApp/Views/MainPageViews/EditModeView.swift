import SwiftUI
import SwiftData

struct EditModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var userLists: [UserList]
    @Query private var taskListSelection: [TaskListSelection]
    
    @State private var taskLists: [TaskList] = [.today, .future, .full, .complete]
    
    @State private var editMode: EditMode = .inactive
    
    @State private var selectedList: TaskList? = nil
    
    @Binding var todaySelected: Bool
    @Binding var futureSelected: Bool
    @Binding var fullSelected: Bool
    @Binding var completeSelected: Bool
    
    @State private var showingListInfo = false
    @State private var selectedColorString = ""
    @State private var editableTitle = ""
    
    let iconSize: CGFloat = 30
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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                        checkBoxRow(title: "오늘", list: .today, icon: TodayIcon(iconSize: iconSize), isSelected: $todaySelected)
                            .padding(.vertical, 3)
                        checkBoxRow(title: "예정", list: .future, icon: Image(systemName: "calendar.circle.fill").foregroundColor(.red), isSelected: $futureSelected)
                            .padding(.vertical, 3)
                        checkBoxRow(title: "전체", list: .full, icon: Image(systemName: "tray.circle.fill").foregroundColor(.black), isSelected: $fullSelected)
                            .padding(.vertical, 3)
                        checkBoxRow(title: "완료됨", list: .complete, icon: Image(systemName: "checkmark.circle.fill").foregroundColor(.black.opacity(0.6)), isSelected: $completeSelected)
                            .padding(.vertical, 3)
                    }
                    .listStyle(.plain)
                    //.background(.red)
                    .frame(maxHeight: 270)
                    .cornerRadius(12)
                    
                    HStack {
                        Text("나의 목록")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    VStack {
                        List {
                            ForEach(userLists, id: \.self) { list in
                                editRow(
                                    title: list.name,
                                    count: list.todos?.filter { !$0.isCompleted }.count ?? 0,
                                    iconColor: colorMap[list.color] ?? .blue,
                                    list: list
                                )
                            }
                        }
                        .listStyle(.plain)
                        .background(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
                        .cornerRadius(12)
                        
                        
                    }
                    Spacer()
                }
                
            }
            
            
        }
        .sheet(isPresented: $showingListInfo) {
            ListInfoView(
                selectedColorString: $selectedColorString,
                listName: $editableTitle
            )
        }
    }
    private func deleteSingleList(_ list: UserList) {
        if let index = userLists.firstIndex(of: list) {
            modelContext.delete(userLists[index])
        }
    }
    
    private func editRow(title: String, count: Int, iconColor: Color, list: UserList) -> some View {
        HStack {
            Button(action: {
                deleteSingleList(list)
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: checkSize))
            }
            .buttonStyle(PlainButtonStyle()) // 버튼만 클릭되도록 스타일 적용
            .contentShape(Rectangle()) // 버튼 클릭 영역을 정확하게 지정
            //gpt 사용
            
            ZStack {
                Image(systemName: "list.bullet.circle.fill")
                    .foregroundColor(iconColor)
                    .font(.system(size: iconSize, weight: .bold))
            }
            
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Spacer()
            Button(action: {
                selectedColorString = list.color
                editableTitle = list.name
                showingListInfo = true
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .font(.system(size: checkSize))
            }
            
        }
        .listRowBackground(Color.white)
    }
    private func checkBoxRow(title: String, list: TaskList, icon: some View, isSelected: Binding<Bool>) -> some View {
        VStack {
            HStack {
                Image(systemName: isSelected.wrappedValue ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
                    .font(.system(size: checkSize))
                    .onTapGesture {
                        isSelected.wrappedValue.toggle()//gpt 사용 : Binding<Bool> 타입의 isSelected에서 실제 값을 가져오거나 변경하는 역할
                    }
                
                icon
                    .font(.system(size: iconSize))
                
                Text(title)
                    .foregroundColor(.black)
                    .font(.body)
                
                Spacer()
                
            }
        }
        .background(Color(.white))
        .cornerRadius(12)
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
        .padding(.leading, 3)
        .padding(.vertical, 3)
    }
}


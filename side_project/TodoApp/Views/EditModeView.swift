import SwiftUI
import SwiftData

struct EditModeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.dismiss) private var dismiss
    
    @Query private var userLists: [UserList]
    @Query private var taskListSelection: [TaskListSelection]
    
    @State private var taskLists: [TaskList] = [.today, .future, .full, .complete]
    
    // "Add Todo" 모달을 표시할지 여부를 상태로 관리
    @State private var editMode: EditMode = .inactive
    // 검색창 텍스트를 상태로 관리
    @State private var searchText = ""
    // 우선순위 필터를 상태로 관리 (초기값은 nil로 설정하여 전체 보기)
    @State private var priorityFilter: Priority? = nil
    @State private var selectedList: TaskList? = nil
    
    @Binding var todaySelected: Bool
    @Binding var futureSelected: Bool
    @Binding var fullSelected: Bool
    @Binding var completeSelected: Bool
    //    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    let iconSize: CGFloat = 30
    let checkSize: CGFloat = 25
    
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
                Section{
                    VStack {
                        List {
                            Group {
                                checkBoxRow(title: "오늘", list: .today, icon: TodayIcon(iconSize: iconSize), isSelected: $todaySelected)
                                checkBoxRow(title: "예정", list: .future, icon: Image(systemName: "calendar.circle.fill").foregroundColor(.red), isSelected: $futureSelected)
                                checkBoxRow(title: "전체", list: .full, icon: Image(systemName: "tray.circle.fill").foregroundColor(.black), isSelected: $fullSelected)
                                checkBoxRow(title: "완료됨", list: .complete, icon: Image(systemName: "checkmark.circle.fill").foregroundColor(.black.opacity(0.6)), isSelected: $completeSelected)
                            }
                            //                        .onMove { indices, newOffset in
                            //                            taskLists.move(fromOffsets: indices, toOffset: newOffset)
                            //                        }
                            .padding(.vertical, 3)
                            
                        }
                        .listStyle(.plain)
                        .environment(\.editMode, .constant(.active))
                        .padding(.vertical, 3)
                    }
                }
                Spacer()
                HStack {
                    Text("나의 목록")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                Section{
                    Text("나의 목록")
                }
            }
            
            
        }
    }
    private func checkBoxRow(title: String, list: TaskList, icon: some View, isSelected: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: isSelected.wrappedValue ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.blue)
                .font(.system(size: checkSize))
                .onTapGesture {
                    isSelected.wrappedValue.toggle() // ✅ 개별 상태 변경
                }
            
            icon
                .font(.system(size: iconSize))
            
            Text(title)
                .foregroundColor(.black)
                .font(.body)
            
            Spacer()
            
        }
        
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


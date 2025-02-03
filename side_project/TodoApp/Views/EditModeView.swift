import SwiftUI
import SwiftData

struct EditModeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userLists: [UserList]
    @State private var newListName: String = ""
    
    // "Add Todo" 모달을 표시할지 여부를 상태로 관리
    @State private var editMode: EditMode = .inactive
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
        Text("EditModeView")
    }
}

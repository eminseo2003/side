import SwiftUI
import SwiftData

struct SlectListView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var userlist: UserList?
    @Query private var userLists: [UserList]
    
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
            VStack {
                List {
                    ForEach(userLists, id: \.self) { list in
                        Button(action: {
                            userlist = list  // 선택된 UserList 업데이트
                            dismiss() // 화면 닫기
                        }) {
                            listRow(
                                title: list.name,
                                count: list.todos?.count ?? 0,
                                iconColor: colorMap[list.color] ?? .blue,
                                isSelected: userlist == list
                            )
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)))
                .cornerRadius(12)
                
                
            }
            .navigationTitle("목록 선택")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func listRow(title: String, count: Int, iconColor: Color, isSelected: Bool) -> some View {
        HStack {
            Image(systemName: "list.bullet.circle.fill")
                .foregroundColor(iconColor)
                .font(.system(size: 30, weight: .bold))
            
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("\(count)")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            if isSelected {  // ✅ 선택된 항목 표시
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 5)
        .background(Color.white)
        .contentShape(Rectangle()) // 버튼 클릭 영역 확장
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

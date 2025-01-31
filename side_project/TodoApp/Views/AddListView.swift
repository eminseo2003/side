import SwiftUI
import SwiftData

struct AddListView: View {
    // 데이터 저장소에 접근할 수 있는 환경 변수
    // SwiftData의 ModelContext 환경을 가져와 데이터 조작에 사용
    @Environment(\.modelContext) private var modelContext
    @Query private var userLists: [UserList]
    @State private var newListName: String = ""
    @State private var selectedColor: String = "blue"
    @Environment(\.dismiss) private var dismiss
    
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
            Form {
                Section {
                    VStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .shadow(color: colorMap[selectedColor] ?? .blue, radius: 5)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "list.bullet.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(colorMap[selectedColor] ?? .blue)
                        }
                        .padding()
                        
                        TextField("목록 이름", text: $newListName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(colorMap[selectedColor] ?? .blue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)//gpt 사용
                    }
                }
                
                Section {
                    let columns = [GridItem(.adaptive(minimum: 40), spacing: 10)]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                // ✅ 바깥 회색 테두리
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: selectedColor == color ? 6 : 0)
                                    .frame(width: 50, height: 50) // 테두리 공간 확보
                                
                                // ✅ 안쪽 흰색 테두리
                                Circle()
                                    .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                    .frame(width: 45, height: 45) // 조금 작게 조정
                                
                                // ✅ 색상이 채워진 원
                                Circle()
                                    .fill(colorMap[color] ?? .gray)
                                    .frame(width: 40, height: 40)
                            }
                            .onTapGesture {
                                selectedColor = color
                            }
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
                
            }
            .navigationTitle("새로운 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 취소 버튼: 현재 화면 닫기
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                // 저장 버튼: 새로운 Todo 항목 저장
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        addList()
                        dismiss() // 화면 닫기
                    }
                }
            }
            
        }
        
    }
    private func addList() {
        if !newListName.isEmpty {
            let newUserList = UserList(name: newListName, color: selectedColor) // 새 목록 생성
            modelContext.insert(newUserList) // ✅ SwiftData에 저장
            newListName = "" // 입력 필드 초기화
            print("./(newListName) added")
        }
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

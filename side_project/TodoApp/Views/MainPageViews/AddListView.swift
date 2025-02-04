import SwiftUI
import SwiftData

struct AddListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var userLists: [UserList]
    @State private var newListName: String = ""
    @State private var selectedColor: String = "blue"
    
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
                            .multilineTextAlignment(.center)//gpt 사용 : Text나 TextField 같은 여러 줄 텍스트의 정렬을 설정
                    }
                }
                
                Section {
                    let columns = [GridItem(.adaptive(minimum: 40), spacing: 10)]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: selectedColor == color ? 6 : 0)
                                    .frame(width: 50, height: 50)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                    .frame(width: 45, height: 45)
                                
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        addList()
                        dismiss()
                    }
                }
            }
            
        }
        
    }
    private func addList() {
        if !newListName.isEmpty {
            let newUserList = UserList(name: newListName, color: selectedColor)
            modelContext.insert(newUserList)
            newListName = ""
        }
    }
}

//#Preview {
//    AddTodoView()
//        .modelContainer(PreviewContainer.shared.container)
//}

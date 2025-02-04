import SwiftUI
import SwiftData

struct ListInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedColorString: String
    @Binding var listName: String
    
    @Query private var userLists: [UserList]
    
    @State private var originalListName: String
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
    init(selectedColorString: Binding<String>, listName: Binding<String>) {
        self._selectedColorString = selectedColorString
        self._listName = listName
        self._originalListName = State(initialValue: listName.wrappedValue)
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .shadow(color: colorMap[selectedColorString] ?? .blue, radius: 5)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "list.bullet.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(colorMap[selectedColorString] ?? .blue)
                        }
                        .padding()
                        
                        TextField("목록 이름", text: $listName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(colorMap[selectedColorString] ?? .blue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Section {
                    let columns = [GridItem(.adaptive(minimum: 40), spacing: 10)]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.5), lineWidth: selectedColorString == color ? 6 : 0)
                                    .frame(width: 50, height: 50)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: selectedColorString == color ? 4 : 0)
                                    .frame(width: 45, height: 45)
                                
                                Circle()
                                    .fill(colorMap[color] ?? .gray)
                                    .frame(width: 40, height: 40)
                            }
                            .onTapGesture {
                                selectedColorString = color
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
            }
            .navigationTitle("목록 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        editList()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func editList() {
        if let userListIndex = userLists.firstIndex(where: { $0.name == originalListName }) {
            userLists[userListIndex].color = selectedColorString
            userLists[userListIndex].name = listName
        } else {
            print("해당 목록을 찾을 수 없습니다.")
        }
    }
}

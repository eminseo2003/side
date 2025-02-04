import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userLists: [UserList]
    @State private var newListName: String = ""
    
    // "Add Todo" 모달을 표시할지 여부를 상태로 관리
    @State private var showingAddAlarm = false
    @State private var showingAddList = false
    @State private var editMode: EditMode = .inactive
    
    @State private var todaySelected = true
    @State private var futureSelected = true
    @State private var fullSelected = true
    @State private var completeSelected = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                //색깔 지정 - gpt 사용
                Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        
                        Spacer()
                        Button(action: {
                            withAnimation {
                                editMode = editMode == .active ? .inactive : .active
                            }
                        }) {
                            Text(editMode == .active ? "완료" : "편집")
                                .foregroundColor(.blue)
                        }
                    }
                    Spacer()
                    
                    if editMode == .active {
                        EditModeView(
                            todaySelected: $todaySelected,
                            futureSelected: $futureSelected,
                            fullSelected: $fullSelected,
                            completeSelected: $completeSelected
                        )
                    } else {
                        MainView(
                            todaySelected: $todaySelected,
                            futureSelected: $futureSelected,
                            fullSelected: $fullSelected,
                            completeSelected: $completeSelected
                        )
                    }
                    
                    
                    Spacer()
                    if editMode == .inactive {
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
                    }
                    
                }
                .padding()
            }
            
        }
        .sheet(isPresented: $showingAddList) {
            AddListView()
        }
        .sheet(isPresented: $showingAddAlarm) {
            AddAlarmView()
        }
        
    }
    
}

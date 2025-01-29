import SwiftUI

struct TodoDetailView: View {
    // SwiftData의 ModelContext 환경을 가져와 데이터 조작에 사용
    @Environment(\.modelContext) private var modelContext
    // 현재 뷰를 닫기 위한 dismiss 환경 변수
    @Environment(\.dismiss) private var dismiss
    
    // 표시할 Todo 항목 데이터
    var item: TodoItem
    
    // "Edit Todo" 팝업 표시 여부를 제어하는 상태
    @State private var showingEditView: Bool = false
    
    var body: some View {
        // 상세 정보 텍스트 표시
        // NavigationStack 이 팝업일 경우에만 사용되어 뷰에서 분리함
        // 다른 NavigationStack 에서 페이지를 부를 경우 오류가 발생함 (중복 NavigationStack)
        Text("\(item.title) at \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
            .toolbar {
                // 삭제 버튼 추가 (툴바 우측 상단에 위치)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        // 삭제 기능: 항목 삭제 후 현재 화면 닫기
                        modelContext.delete(item)
                        dismiss()
                    }
                }
                // 수정 버튼 추가 (툴바 우측 상단에 위치)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        // "Edit Todo" 팝업 표시
                        showingEditView = true
                    }
                }
            }
            .navigationTitle(item.title) // 네비게이션 바 제목 설정
            // "Edit Todo" 팝업 설정
//            .sheet(isPresented: $showingEditView) {
//                NavigationStack {
//                    EditTodoView(todo: item) // 팝업 내 수정 화면 표시
//                }
//            }
    }
}

//#Preview {
//    TodoDetailView(item: TodoItem(title: "Hello, world!"))
//}

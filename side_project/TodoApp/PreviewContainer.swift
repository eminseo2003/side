//import Foundation
//import SwiftData
//
//@MainActor
//class PreviewContainer {
//    // 싱글톤 인스턴스 생성 - PreviewContainer는 앱 전체에서 하나만 사용
//    static let shared: PreviewContainer = PreviewContainer()
//    // SwiftData 모델 컨테이너 선언
//    let container: ModelContainer
//    
//    init() {
//        // 모델의 스키마를 정의 (TodoItem 모델 등록)
//        let schema = Schema([
//            TodoItem.self, // TodoItem은 SwiftData의 모델 클래스
//        ])
//        // 모델 컨테이너 설정 - 메모리에만 저장하며 CloudKit 연동은 사용하지 않음
//        let modelConfiguration = ModelConfiguration(schema: schema,
//                                                    isStoredInMemoryOnly: true,// 메모리에만 저장
//                                                    cloudKitDatabase: .none)// CloudKit 비활성화
//        
//        do {
//            // ModelContainer 생성 (SwiftData 컨텍스트 및 스키마 설정)
//            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
//            // 예제 데이터 삽입
//            insertPreviewData()
//        } catch {
//            // 컨테이너 생성 실패 시 앱 종료
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }
//    
//    // 미리보기에서 사용할 더미 데이터를 삽입
//    func insertPreviewData() {
//        let today = Date() // 오늘 날짜 가져오기
//        let calendar = Calendar.current // 현재 캘린더 가져오기
//        // 작업 기한 (오늘로부터 하루 뒤 날짜 계산)
//        let dueDate = calendar.date(byAdding: .day, value: 1, to: today)!
//        
//        // 카테고리 데이터 추가
//        let categories: [Category] = ["업무", "장보기", "여행"].map { categoryName in
//            let category = Category(name: categoryName) // 카테고리 객체 생성
//            container.mainContext.insert(category) // 컨텍스트에 삽입
//            return category
//        }
//
//        // TodoItem 더미 데이터 정의 (제목, 기한, 우선순위, 생성 날짜, 카테고리)
//        let todos: [(String, Date, Priority, Date, Category?)] = [
//            ("Buy groceries", today, .low, dueDate, categories[0]),
//            ("Walk the dog", calendar.date(byAdding: .day, value: 1, to: today)!, .medium, dueDate, categories[0]),
//            ("Do the laundry", calendar.date(byAdding: .day, value: 2, to: today)!, .medium, dueDate, categories[0]),
//            ("Take out the trash", calendar.date(byAdding: .day, value: 3, to: today)!, .low, dueDate, categories[1]),
//            ("완료된 작업", calendar.date(byAdding: .day, value: 4, to: today)!, .low, dueDate, categories[1]),
//            ("운동하기", calendar.date(byAdding: .day, value: 5, to: today)!, .high, dueDate, categories[1]),
//            ("책 읽기", calendar.date(byAdding: .day, value: 6, to: today)!, .high, dueDate, categories[2]),
//            ("SwiftUI 공부", calendar.date(byAdding: .day, value: 7, to: today)!, .high, dueDate, categories[2]),
//            ("TEST", calendar.date(byAdding: .day, value: 3, to: today)!, .low, dueDate, nil),
//
//        ]
//        
//        // dueDate, createdAt 더미 데이터 변경
//        // TodoItem 데이터를 컨텍스트에 삽입
//        for (title, due, priority, createdAt, category) in todos {
//            let todo = TodoItem(title: title, priority: priority, date: due, category: category, createdAt: createdAt)
//            container.mainContext.insert(todo)
//        }
//                
//        // 첫 번째 Todo를 완료 상태로 설정
//        if let firstTodo = try? container.mainContext.fetch(FetchDescriptor<TodoItem>()).first {
//            firstTodo.isCompleted = true
//        }
//        
//        // 변경사항을 저장
//        try? container.mainContext.save()
//    }
//}

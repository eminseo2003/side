import SwiftUI
import SwiftData

@main
struct TodoAppApp: App {
    // ModelContainer를 생성하는 전역 변수 (앱 전반에서 공유)
    var sharedModelContainer: ModelContainer = {
        // 스키마 정의 (SchemaV2를 사용하여 버전 관리된 스키마 지정)
        let schema = Schema(versionedSchema: SchemaV2.self)
        // ModelContainer 설정 (디스크 저장을 위해 isStoredInMemoryOnly를 false로 설정)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            // ModelContainer를 생성하며 마이그레이션 계획 적용
            let container = try ModelContainer(
                for: schema, // 스키마 설정
                migrationPlan: MigrationPlan.self, // 마이그레이션 계획
                configurations: [modelConfiguration] // 설정 추가
            )
            // 마이그레이션 성공 메시지 출력
            print("Successfully created ModelContainer with migration")
            return container
        } catch {
            // ModelContainer 생성 실패 시 에러 처리
            print("Failed to create ModelContainer: \(error)")
            print("Error details: \(error.localizedDescription)")
            
            // 데이터 초기화를 시도하며 새로운 ModelContainer 생성 (최후의 수단)
            do {
                let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                let container = try ModelContainer(for: schema, configurations: [configuration])
                print("Created fresh ModelContainer after error")
                return container
            } catch {
                // 초기화 실패 시 앱 종료
                print("Error details: \(error.localizedDescription)")
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView() // 앱의 메인 뷰 설정
                .modelContainer(sharedModelContainer)
        }
        //.modelContainer(sharedModelContainer) // 공유 ModelContainer를 SwiftUI 환경에 전달
    }
}

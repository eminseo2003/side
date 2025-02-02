import Foundation

enum TaskList: Int, Codable, CaseIterable, Hashable {
    case today = 0
    case future = 1
    case full = 2
    case complete = 3
    
    var title: String {
        switch self {
        case .today:
            return "오늘"
        case .future:
            return "예정"
        case .full:
            return "전체"
        case .complete:
            return "완료됨"
        }
    }

}

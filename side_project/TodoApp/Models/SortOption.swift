import Foundation

enum SortOption: String, CaseIterable, Codable {
    case manual = "수동"
    case dueDate = "마감일"
    case createdDate = "생성일"
    case priority = "우선 순위"
    case title = "제목"
}

import Foundation

enum RepeatFrequency: String, Codable, CaseIterable {
    case none = "안 함"
    case daily = "매일"
    case weekday = "평일"
    case weekend = "주말"
    case weekly = "매주"
    case biweekly = "격주"
    case monthly = "매월"
    case every3Months = "3개월마다"
    case every6Months = "6개월마다"
    case yearly = "매년"
}

//
//  Priority.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import Foundation

enum Priority: Int, Codable, CaseIterable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3
    
    var title: String {
        switch self {
        case .low:
            return "낮음"
        case .medium:
            return "중간"
        case .high:
            return "높음"
        case .none:
            return "없음"
        }
    }
}

//
//  PriorityBadge.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import SwiftUI

// 우선순위(Priority)를 시각적으로 표시하는 뷰
struct PriorityBadge: View {
    // 표시할 우선순위 값 (low, medium, high 중 하나)
    let priority: Priority
    
    var body: some View {
        // 우선순위 이름을 텍스트로 표시
        Text(priority.title)
            .font(.caption)
            .padding(4)
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 4))
    }
    // 우선순위에 따라 배경색을 반환하는 계산 속성
    private var backgroundColor: Color {
        switch priority {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}

//#Preview {
//    PriorityBadge(priority: TodoItem(title: "Hello, world!").priority)
//}

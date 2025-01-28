//
//  Category.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import Foundation
import SwiftData

// SwiftData의 데이터 모델을 정의하는 클래스
@Model
final class Category {
    var id: String = UUID().uuidString
    var name: String? 
    
    // 해당 카테고리와 연결된 TodoItem 목록
    // 삭제 규칙: 카테고리가 삭제되면 관련된 TodoItem들도 함께 삭제됨 (cascade rule)
    @Relationship(deleteRule: .cascade)
    var todos: [TodoItem]? = []
    
    init(name: String) {
        self.name = name
    }
}

//
//  V2MigrationPlan.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import Foundation
import SwiftData

// 데이터 모델의 스키마 마이그레이션을 정의하는 열거형
enum MigrationPlan: SchemaMigrationPlan {
    // 지원되는 모든 스키마 버전의 목록
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }
    
    // 마이그레이션 단계의 정의
    static var stages: [MigrationStage] {
        [
            // SchemaV1에서 SchemaV2로의 경량 마이그레이션 정의
            MigrationStage.lightweight(fromVersion: SchemaV1.self, toVersion: SchemaV2.self)
        ]
    }
}

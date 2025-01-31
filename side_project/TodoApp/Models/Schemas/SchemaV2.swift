//
//  SchemaV2.swift
//  TodoApp
//
//  Created by Jungman Bae on 1/21/25.
//

import Foundation
import SwiftData

enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        [SchemaV2.TodoItem.self, UserList.self]
    }


    
    @Model
    final class TodoItem {
        var id: UUID = UUID()
        var title: String = ""
        var memo: String = ""
        var isCompleted: Bool = false
        var date: Date?
        var time: Date?
        var daterepeat: RepeatFrequency = RepeatFrequency.none
        var repeatEndDate: Date?
        var location: String?
        //var category: Category? = nil
        var createdAt: Date = Date()
        var priority: Priority = Priority.none
        var userlist: UserList?

        init(title: String,
             memo: String,
             isCompleted: Bool = false,
             priority: Priority = Priority.none,
             date: Date? = nil,
             time: Date? = nil,
             daterepeat: RepeatFrequency = RepeatFrequency.none,
             repeatEndDate: Date? = nil,
             location: String? = nil,
             userlist: UserList? = nil,
             //category: Category? = nil,
             createdAt: Date = Date()) {
            self.title = title
            self.memo = memo
            self.isCompleted = isCompleted
            self.priority = priority
            self.date = date
            self.time = time
            self.daterepeat = daterepeat
            self.repeatEndDate = repeatEndDate
            self.location = location
            //self.category = category
            self.userlist = userlist
            self.createdAt = createdAt
        }
    }
}

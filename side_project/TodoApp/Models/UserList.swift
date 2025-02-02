import Foundation
import SwiftData

@Model
final class UserList {
    var id: UUID = UUID()
    var name: String = "미리 알림"
    var color: String = "blue"
    @Relationship(inverse: \TodoItem.userlist)
    var todos: [TodoItem]?
    @Relationship
    var sortOptions: [ListArray]?
    
    
    init(name: String, color: String = "blue", sortOptions: [ListArray]? = nil) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.sortOptions = sortOptions ?? [ListArray(selectedSort: .manual, userList: self)]
    }
    
}


import Foundation
import SwiftData

@Model
final class UserList {
    var id: UUID = UUID()
    var name: String = "미리 알림"
    var color: String = "blue"
    @Relationship(inverse: \TodoItem.userlist)
    var todos: [TodoItem]?
    
    init(name: String, color: String = "blue") {
        self.id = UUID()
        self.name = name
        self.color = color
    }
    
}


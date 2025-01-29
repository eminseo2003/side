import Foundation
import SwiftData

@Model
final class UserList {
    var id: UUID = UUID()
    var name: String = "미리 알림"
    @Relationship(inverse: \TodoItem.userlist)
    var todos: [TodoItem]?
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
}


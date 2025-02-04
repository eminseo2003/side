import Foundation
import SwiftData

@Model
final class ListArray {
    var id: UUID = UUID()
    var selectedSort: SortOption = SortOption.manual
    
    // UserList와의 관계 설정 (연관된 UserList를 가짐)/
    @Relationship(inverse: \UserList.sortOptions)
    var userList: UserList?
    
    init(selectedSort: SortOption = .manual, userList: UserList? = nil) {
        self.id = UUID()
        self.selectedSort = selectedSort
        self.userList = userList
    }
}

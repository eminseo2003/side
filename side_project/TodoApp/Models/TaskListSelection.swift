import SwiftData

@Model
final class TaskListSelection {
    var todaySelected: Bool = true
    var futureSelected: Bool = true
    var fullSelected: Bool = true
    var completeSelected: Bool = true
    
    init(todaySelected: Bool = true, futureSelected: Bool = true, fullSelected: Bool = true, completeSelected: Bool = true) {
        self.todaySelected = todaySelected
        self.futureSelected = futureSelected
        self.fullSelected = fullSelected
        self.completeSelected = completeSelected
    }
}

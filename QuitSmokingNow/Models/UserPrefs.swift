import Foundation
import SwiftData

@Model
final class UserPrefs {

    var id: UUID
    var resultTime: Date
    
    init(id: UUID = UUID(), resultTime: Date = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date()) {
        self.id = id
        self.resultTime = resultTime
    }
    
    func formattedResultTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: resultTime)
    }
}

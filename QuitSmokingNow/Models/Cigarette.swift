import Foundation
import SwiftData

@Model
final class Cigarette{
    
    var id: UUID
    var date: Date
    var count: Int
    
    init(id: UUID = UUID(), date: Date = Date(), count: Int = 0) {
        self.id = id
        self.date = date
        self.count = count
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

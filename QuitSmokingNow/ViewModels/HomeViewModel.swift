import Foundation
import SwiftData
import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var todayCigaretteCount: Int = 0
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadTodayLog()
    }
    
    func loadTodayLog() {

        let calendar = Calendar.current
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        

        let descriptor = FetchDescriptor<Cigarette>()
        
        do {
            let allLogs = try modelContext.fetch(descriptor)
            
            let todayLogs = allLogs.filter { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == todayComponents.year &&
                       logComponents.month == todayComponents.month &&
                       logComponents.day == todayComponents.day
            }
            
            if let todayLog = todayLogs.first {
                todayCigaretteCount = todayLog.count
            } else {
                createNewDayLog()
            }
        } catch {
            print("Error fetching today's log: \(error)")
        }
    }
    
    private func createNewDayLog() {
        let newLog = Cigarette(date: Date(), count: 0)
        modelContext.insert(newLog)
        todayCigaretteCount = 0
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving new day log: \(error)")
        }
    }
    
    func addCigarette() {

        let calendar = Calendar.current
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        let descriptor = FetchDescriptor<Cigarette>()
        
        do {
            let allLogs = try modelContext.fetch(descriptor)
            
            let todayLogs = allLogs.filter { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == todayComponents.year &&
                       logComponents.month == todayComponents.month &&
                       logComponents.day == todayComponents.day
            }
            
            if let todayLog = todayLogs.first {
                todayLog.count += 1
                todayCigaretteCount = todayLog.count
            } else {
                let newLog = Cigarette(date: Date(), count: 1)
                modelContext.insert(newLog)
                todayCigaretteCount = 1
            }
            
            try modelContext.save()
        } catch {
            print("Error adding cigarette: \(error)")
        }
    }
} 

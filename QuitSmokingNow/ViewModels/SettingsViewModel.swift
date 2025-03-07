import Foundation
import SwiftData
import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published var resultTime: Date
    @Published var todayCigaretteCount: Int = 0
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        self.resultTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date()) ?? Date() // default 21:00
        
        loadSettings()
        loadTodayConsumption()
    }
    
    func loadSettings() {
        let descriptor = FetchDescriptor<UserPrefs>()
        
        do {
            let settings = try modelContext.fetch(descriptor)
            if let userSettings = settings.first {
                resultTime = userSettings.resultTime
            } else {
                // Create default settings if none exist
                let defaultSettings = UserPrefs()
                modelContext.insert(defaultSettings)
                resultTime = defaultSettings.resultTime
            }
        } catch {
            print("Error fetching settings: \(error)")
        }
    }
    
    func saveSettings() {
        let descriptor = FetchDescriptor<UserPrefs>()
        
        do {
            let settings = try modelContext.fetch(descriptor)
            if let userSettings = settings.first {
                userSettings.resultTime = resultTime
            }
            
            try modelContext.save()
        } catch {
            print("Error saving settings: \(error)")
        }
    }
    
    func loadTodayConsumption() {
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
            }
        } catch {
            print("Error fetching today's log: \(error)")
        }
    }
    
    func decreaseCigaretteCount() {
        if todayCigaretteCount > 0 {
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
                    todayLog.count -= 1
                    todayCigaretteCount = todayLog.count
                    
                    try modelContext.save()
                }
            } catch {
                print("Error decreasing cigarette count: \(error)")
            }
        }
    }
} 

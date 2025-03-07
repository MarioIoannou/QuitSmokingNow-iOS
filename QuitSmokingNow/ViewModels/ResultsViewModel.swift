import Foundation
import SwiftData
import SwiftUI

class ResultsViewModel: ObservableObject {

    @Published var cigaretteLogs: [Cigarette] = []
    @Published var todayCount: Int = 0
    @Published var yesterdayCount: Int = 0
    @Published var isImprovement: Bool = false
    @Published var feedbackMessage: String = ""
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadCigarettes()
        compareWithYesterday()
    }
    
    func loadCigarettes() {
        let descriptor = FetchDescriptor<Cigarette>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        do {
            cigaretteLogs = try modelContext.fetch(descriptor)
            
            let calendar = Calendar.current
            let today = Date()
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
            
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            let yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
            
            if let todayLog = cigaretteLogs.first(where: { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == todayComponents.year &&
                       logComponents.month == todayComponents.month &&
                       logComponents.day == todayComponents.day
            }) {
                todayCount = todayLog.count
            }
            
            if let yesterdayLog = cigaretteLogs.first(where: { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == yesterdayComponents.year &&
                       logComponents.month == yesterdayComponents.month &&
                       logComponents.day == yesterdayComponents.day
            }) {
                yesterdayCount = yesterdayLog.count
            }
        } catch {
            print("Error fetching logs: \(error)")
        }
    }
    
    func compareWithYesterday() {
        if yesterdayCount == 0 {
            feedbackMessage = "No data from yesterday to compare. Keep tracking your progress!"
            return
        }
        
        if todayCount < yesterdayCount {
            isImprovement = true
            let difference = yesterdayCount - todayCount
            feedbackMessage = "Great job! You've smoked \(difference) fewer cigarettes than yesterday. Keep up the good work!"
        } else if todayCount > yesterdayCount {
            isImprovement = false
            let difference = todayCount - yesterdayCount
            feedbackMessage = "You've smoked \(difference) more cigarettes than yesterday. Remember, each cigarette you don't smoke is a victory for your health. Try to take a deep breath or drink water next time you crave one."
        } else {
            isImprovement = false
            feedbackMessage = "You've smoked the same number of cigarettes as yesterday. Try to reduce by just one tomorrow - small steps lead to big changes!"
        }
    }
    
    func getMotivationalMessage() -> String {
        
        let messages = [
            "Every cigarette not smoked is a victory!",
            "Your lungs are already thanking you for cutting back.",
            "Stay strong! The cravings pass whether you smoke or not.",
            "Think about how much money you're saving by smoking less.",
            "Your sense of taste and smell improve when you cut back on smoking."
        ]
        
        return messages.randomElement() ?? messages[0]
    }
} 

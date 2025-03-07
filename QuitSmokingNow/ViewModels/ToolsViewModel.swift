import Foundation
import SwiftData
import SwiftUI

class ToolsViewModel: ObservableObject {

    @Published var timeRemaining: Int = 4 * 60 // 4min
    @Published var isTimerRunning: Bool = false
    private var timer: Timer?

    @Published var cigarettesNotSmoked: Int = 0
    @Published var cigaretteCost: Double = 0.50 // 50cents
    @Published var totalSavings: Double = 0.0
    @Published var totalSavingsText: String = "0.00"
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        calculateInitialCigarettesNotSmoked()
    }
    
    private func calculateInitialCigarettesNotSmoked() {

        let calendar = Calendar.current
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let yesterdayComponents = calendar.dateComponents([.year, .month, .day], from: yesterday)
        
        let descriptor = FetchDescriptor<Cigarette>()
        
        do {
            let allLogs = try modelContext.fetch(descriptor)
            
            let todayLogs = allLogs.filter { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == todayComponents.year &&
                       logComponents.month == todayComponents.month &&
                       logComponents.day == todayComponents.day
            }
            
            let yesterdayLogs = allLogs.filter { log in
                let logComponents = calendar.dateComponents([.year, .month, .day], from: log.date)
                return logComponents.year == yesterdayComponents.year &&
                       logComponents.month == yesterdayComponents.month &&
                       logComponents.day == yesterdayComponents.day
            }
            
            let todayCount = todayLogs.first?.count ?? 0
            let yesterdayCount = yesterdayLogs.first?.count ?? 0
            
            if todayCount < yesterdayCount {
                cigarettesNotSmoked = yesterdayCount - todayCount
                updateSavingsCalculation(cigarettesNotSmoked: cigarettesNotSmoked)
            } else {
                cigarettesNotSmoked = 0
                totalSavings = 0.0
                totalSavingsText = "0.00"
            }
        } catch {
            print("Error calculating cigarettes not smoked: \(error)")
        }
    }
    
    func startTimer() {
        if !isTimerRunning {
            isTimerRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.stopTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        timeRemaining = 4 * 60
    }
    
    func formattedTimeRemaining() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds) // format mm:ss
    }
    
    func updateCost(_ newCost: Double) {
        cigaretteCost = newCost
        updateSavingsCalculation(cigarettesNotSmoked: cigarettesNotSmoked)
    }
    
    func updateSavingsCalculation(cigarettesNotSmoked: Int) {
        self.cigarettesNotSmoked = cigarettesNotSmoked
        totalSavings = Double(cigarettesNotSmoked) * cigaretteCost
        totalSavingsText = String(format: "%.2f", totalSavings)
    }
} 


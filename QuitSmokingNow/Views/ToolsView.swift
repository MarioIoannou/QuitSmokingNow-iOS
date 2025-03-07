import SwiftUI
import SwiftData

struct ToolsView: View {

    @ObservedObject var viewModel: ToolsViewModel
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack {

                Picker("Tools", selection: $selectedTab) {
                    Text("Timer").tag(0)
                    Text("Calculator").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedTab) {
                    TimerView(viewModel: viewModel)
                        .tag(0)
                    
                    CalculatorView(viewModel: viewModel)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Tools")
        }
    }
}

struct TimerView: View {
    
    @ObservedObject var viewModel: ToolsViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Craving Timer")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Wait 4 minutes for your craving to pass")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ZStack {
                Circle()
                    .stroke(
                        Color.blue.opacity(0.3),
                        lineWidth: 15
                    )
                    .frame(width: 250, height: 250)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.timeRemaining) / (4 * 60))
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 15,
                            lineCap: .round
                        )
                    )
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(-90))
                
                Text(viewModel.formattedTimeRemaining())
                    .font(.system(size: 60, weight: .bold))
            }
            .padding(.vertical, 30)
            
            HStack(spacing: 40) {
                Button(action: {
                    viewModel.resetTimer()
                }) {
                    VStack {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title)
                        Text("Reset")
                            .font(.caption)
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(15)
                }
                
                Button(action: {
                    if viewModel.isTimerRunning {
                        viewModel.stopTimer()
                    } else {
                        viewModel.startTimer()
                    }
                }) {
                    VStack {
                        Image(systemName: viewModel.isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                        Text(viewModel.isTimerRunning ? "Pause" : "Start")
                            .font(.caption)
                    }
                    .frame(width: 80, height: 80)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
            }
            
            Spacer()
            
            Text("Most cravings pass within 4 minutes. Distract yourself during this time.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}

struct CalculatorView: View {
    
    @ObservedObject var viewModel: ToolsViewModel
    
    @State private var costText: String = "0.50"
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("See how much money you save by smoking less")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 20) {

                VStack(alignment: .leading, spacing: 5) {
                    Text("Cigarettes not smoked: \(viewModel.cigarettesNotSmoked)")
                        .fontWeight(.medium)
                    
                    Slider(value: Binding(
                        get: { Double(viewModel.cigarettesNotSmoked) },
                        set: { viewModel.updateSavingsCalculation(cigarettesNotSmoked: Int($0)) }
                    ), in: 0...50, step: 1)
                    .accentColor(.blue)
                }
                
                HStack {
                    Text("Cost per cigarette:")
                        .foregroundColor(.secondary)
                    Spacer()
                    TextField("Cost", text: $costText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60)
                        .onChange(of: costText) { _, newValue in
                            if let cost = Double(newValue) {
                                viewModel.updateCost(cost)
                            }
                        }
                }
                
                Divider()
                
                HStack {
                    Text("Total savings:")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.totalSavingsText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Potential Savings")
                    .font(.headline)
                
                VStack(spacing: 8) {
                    SavingsRowView(period: "Weekly", amount: viewModel.totalSavings * 7)
                    SavingsRowView(period: "Monthly", amount: viewModel.totalSavings * 30)
                    SavingsRowView(period: "Yearly", amount: viewModel.totalSavings * 365)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .onAppear {
            costText = String(format: "%.2f", viewModel.cigaretteCost)
        }
    }
}

struct SavingsRowView: View {
    let period: String
    let amount: Double
    
    var body: some View {
        HStack {
            Text(period)
                .foregroundColor(.secondary)
            Spacer()
            Text(String(format: "%.2f", amount))
                .fontWeight(.semibold)
        }
    }
}

import SwiftUI
import SwiftData
import Charts

struct ResultsView: View {

    @ObservedObject var viewModel: ResultsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Daily Comparison")
                            .font(.headline)
                        
                        HStack(spacing: 30) {
                            VStack {
                                Text("Yesterday")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.yesterdayCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Today")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(viewModel.todayCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Feedback")
                            .font(.headline)
                        
                        Text(viewModel.feedbackMessage)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Motivation")
                            .font(.headline)
                        
                        Text(viewModel.getMotivationalMessage())
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Your Results")
            .onAppear {
                viewModel.loadCigarettes()
                viewModel.compareWithYesterday()
            }
        }
    }
}

import SwiftUI
import SwiftData

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                
                // decrease counter
                Section(header: Text("Cigarette Counter")) {
                    HStack {
                        Text("Today's count")
                        Spacer()
                        Text("\(viewModel.todayCigaretteCount)")
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        viewModel.decreaseCigaretteCount()
                    }) {
                        HStack {
                            Image(systemName: "minus.circle")
                            Text("Decrease Count")
                        }
                    }
                    .disabled(viewModel.todayCigaretteCount <= 0)
                }
                
                // results time
                Section(header: Text("Results Time"), footer: Text("Set the time when you want to see your daily results")) {
                    DatePicker(
                        "Results Time",
                        selection: $viewModel.resultTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: viewModel.resultTime) { _, _ in
                        viewModel.saveSettings()
                    }
                }
            }
        }
    }
}

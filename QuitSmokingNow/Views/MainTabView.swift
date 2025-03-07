import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
    
            HomeView(viewModel: HomeViewModel(modelContext: modelContext))
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ResultsView(viewModel: ResultsViewModel(modelContext: modelContext))
                .tabItem {
                    Label("Results", systemImage: "chart.bar")
                }
            
            ToolsView(viewModel: ToolsViewModel(modelContext: modelContext))
                .tabItem {
                    Label("Tools", systemImage: "wrench.and.screwdriver")
                }
            
            SettingsView(viewModel: SettingsViewModel(modelContext: modelContext))
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

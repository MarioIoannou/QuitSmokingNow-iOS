import SwiftUI
import SwiftData

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Today's Cigarettes")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ZStack { //counter
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Circle()
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 200, height: 200)
                
                Text("\(viewModel.todayCigaretteCount)")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 40)
            
            // button
            Button(action: {
                viewModel.addCigarette()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("Add Cigarette")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            Spacer()
            
        }
        //.padding(.bottom, 200)
        .onAppear {
            viewModel.loadTodayLog()
        }
    }
}

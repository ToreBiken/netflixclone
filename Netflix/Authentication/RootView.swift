import SwiftUI

struct RootView: View {
    @State private var showSignInView: Bool = false
    @State private var selectedTab = 0 // 0 for Home, 1 for Downloads
    
    var body: some View {
        ZStack {
            if showSignInView {
                NavigationStack {
                    AuthenticationView(showSignInView: $showSignInView)
                        .background(Color("NetflixBackground").ignoresSafeArea())
                }
            } else {
                NavigationStack {
                    TabView(selection: $selectedTab) {
                        // HomeView Tab
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                            .tag(0)
                        
                        // Downloads Tab
                        DownloadsView()
                            .tabItem {
                                Label("Downloads", systemImage: "arrow.down.circle.fill")
                            }
                            .tag(1)
                        ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person.crop.circle")
                            }
                            .tag(2)
                        SettingsView(showSignInView: $showSignInView)
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                            .tag(3)
                    }
                    .background(Color("NetflixBackground").ignoresSafeArea())
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
    }
}

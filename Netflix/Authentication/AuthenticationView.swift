import SwiftUI

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    @State private var showSignInButton = false
    @State private var showLoading = true
    
    var body: some View {
        ZStack {
            if showLoading {
                ProgressView("Загрузка...") // Экран загрузки
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
            } else {
                IntroVideoPlayerView(videoName: "intro")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                if showSignInButton {
                    VStack {
                        Spacer()
                        
                        NavigationLink {
                            SignInEmailView(showSignInView: $showSignInView)
                        } label: {
                            Text("Войдите в аккаунт, чтобы продолжить использовать Netflix")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color("NetflixRed")).ignoresSafeArea()
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
            }
        }
        .background(Color("NetflixBackground").ignoresSafeArea())
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 секунды ожидания
                showLoading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // 5 секунд задержки для кнопки
                    withAnimation {
                        showSignInButton = true
                    }
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}

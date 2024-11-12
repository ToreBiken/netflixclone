import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    func signIn(showSignInView: Binding<Bool>) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Пожалуйста, введите и почту, и пароль."
            return
        }
        
        do {
            let _ = try await AuthenticationManager.shared.signIn(email: email, password: password)
            showSignInView.wrappedValue = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp(showSignInView: Binding<Bool>) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Пожалуйста, введите и почту, и пароль."
            return
        }
        
        do {
            let _ = try await AuthenticationManager.shared.createUser(email: email, password: password)
            showSignInView.wrappedValue = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            // Фоновое изображение
            Image("background-login")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Войти")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        TextField("Адрес эл. почты или номер мобильного...", text: $viewModel.email)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Пароль", text: $viewModel.password)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 5)
                    }
                    
                    Button(action: {
                        Task { await viewModel.signIn(showSignInView: $showSignInView) }
                    }) {
                        Text("Войти")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Text("Впервые на Netflix?")
                            .foregroundColor(.white)
                        Button(action: {
                            Task { await viewModel.signUp(showSignInView: $showSignInView) }
                        }) {
                            Text("Зарегистрируйтесь сейчас.")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
                
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}

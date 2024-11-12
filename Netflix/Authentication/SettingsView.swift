import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    // Добавим состояние для переключателя уведомлений и темы
    @Published var isDarkModeEnabled: Bool = false
    @Published var areNotificationsEnabled: Bool = false
    @Published var username: String = "Tore"
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    // Сохранение изменений (например, для имени пользователя)
    func saveUsername(_ name: String) {
        username = name
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                // Изменение имени пользователя
                Section(header: Text("Profile")) {
                    HStack {
                        Text("Username")
                        Spacer()
                        TextField("Enter your name", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing, 8)
                            .onChange(of: viewModel.username) { newValue in
                                viewModel.saveUsername(newValue)  // Сохранить имя при изменении
                            }
                    }
                }
                
                // Настройки уведомлений
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $viewModel.areNotificationsEnabled)
                        .onChange(of: viewModel.areNotificationsEnabled) { value in
                            // Здесь можно добавить логику для включения/выключения уведомлений
                            print("Notifications are now \(value ? "enabled" : "disabled")")
                        }
                }
                
                // Настройки внешнего вида
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $viewModel.isDarkModeEnabled)
                        .onChange(of: viewModel.isDarkModeEnabled) { value in
                            // Примените тему по состоянию
                            if value {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
                            } else {
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
                            }
                        }
                }
                
                // Логирование выхода
                Section {
                    Button("Log out") {
                        Task {
                            do {
                                try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                print("Error signing out: \(error.localizedDescription)")
                            }
                        }
                    }
                    .foregroundColor(.red)
                }
                
                // Информация о приложении
                Section(header: Text("About")) {
                    NavigationLink("Help & Support", destination: Text("Help Page"))
                    NavigationLink("Privacy Policy", destination: Text("Privacy Policy Page"))
                }
            }
            .navigationBarTitle("Settings")
            .listStyle(GroupedListStyle())  // Стиль списка
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}

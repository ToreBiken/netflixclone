import SwiftUI
import GoogleGenerativeAI

struct AiFriendView: View {
    @State private var userPrompt: String = "" // Ввод пользователя
    @State private var aiResponse: String = "" // Ответ от ИИ
    @State private var isLoading: Bool = false // Статус загрузки
    
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "AIzaSyB6OCaRFzEUDD3ZTcD-Nxb89IBD4Ed6J8c")
    
    // Функция для получения ответа от ИИ
    func fetchAIResponse(for prompt: String) async {
        isLoading = true
        let promptText = "Ты виртуальный друг, который может рассказать интересные факты о фильмах и придумать новые истории. Ответь на вопрос: \(prompt)"
        
        do {
            let response = try await model.generateContent(promptText)
            if let text = response.text {
                aiResponse = text
            }
        } catch {
            aiResponse = "Ошибка при получении ответа от ИИ."
        }
        
        isLoading = false
    }
    
    var body: some View {
        VStack {
            Text("Друг ИИ по кино")
                .font(.largeTitle)
                .bold()
                .padding()
            
            ScrollView {
                Text(aiResponse)
                    .font(.body)
                    .padding()
            }
            
            Spacer()
            
            TextField("Задайте вопрос", text: $userPrompt)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await fetchAIResponse(for: userPrompt)
                }
            }) {
                Text("Задать вопрос")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(5)
            }
            .padding(.top, 10)
            
            if isLoading {
                ProgressView("Загружаем ответ...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }
        }
        .padding()
        .navigationBarTitle("Друг ИИ", displayMode: .inline)
    }
}

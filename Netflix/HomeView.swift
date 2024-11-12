import SwiftUI
import GoogleGenerativeAI

struct HomeView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var selectedGenre: Genre?
    @State private var email: String = ""
    @State private var hasSubscription: Bool = false
    @State private var userPrompt: String = ""
    @State private var aiResponse: String = ""
    @State private var isLoading: Bool = false
    
    // Initialize Generative AI model with your API key
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: "AIzaSyB6OCaRFzEUDD3ZTcD-Nxb89IBD4Ed6J8c")
    
    func fetchAIResponse(for prompt: String) async {
        isLoading = true
        let movieSearchPrompt = "Найдите название фильма, связанного или хоть похожего с: \(prompt)"
        
        do {
            let response = try await model.generateContent(movieSearchPrompt)
            if let text = response.text {
                aiResponse = text
            }
        } catch {
            aiResponse = "Ошибка при получении ответа от ИИ."
        }
        
        isLoading = false
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Text("NETFLIX")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.red)
                            
                            Text("Фильмы, сериалы и многое другое без ограничений")
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.center)
                                .foregroundColor(hasSubscription ? .purple : .white)
                                .padding(.horizontal)
                            
                            Text(hasSubscription ? "Подписка активна" : "От 7,99 €. Отменить подписку можно в любое время.")
                                .font(.subheadline)
                                .foregroundColor(hasSubscription ? .red : .white)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                TextField("Адрес электронной почты", text: $email)
                                    .padding()
                                    .background(Color.white)
                                    .foregroundColor(.black) // Text color
                                    .cornerRadius(5)
                                
                                Button(action: {
                                    hasSubscription = true
                                }) {
                                    Text("Начать смотреть")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(5)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Популярные фильмы")
                                .font(.title2)
                                .bold()
                                .padding(.leading, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.popularMovies) { movie in
                                        MovieCardView(movie: movie, hasSubscription: hasSubscription)
                                    }
                                }
                            }
                            
                            Text("Выбрать жанр")
                                .font(.title2)
                                .bold()
                                .padding(.leading, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.genres) { genre in
                                        Button(action: {
                                            viewModel.selectGenre(genre.id)
                                            selectedGenre = genre
                                        }) {
                                            Text(genre.name)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 5)
                                                .background(Color("NetflixRed"))
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                            
                            if let genreName = selectedGenre?.name {
                                Text("Фильмы по жанру: \(genreName)")
                                    .font(.title2)
                                    .bold()
                                    .padding(.leading, 10)
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewModel.moviesByGenre) { movie in
                                        MovieCardView(movie: movie, hasSubscription: hasSubscription)
                                    }
                                }
                            }
                        }

                        // AI Response Section
                        VStack {
                            Text("Поиск по контексту: Задайте момент из фильма")
                                .font(.headline)
                                .padding(.top, 20)
                            
                            TextField("Введите вопрос (например, о фильмах, актерах, жанрах)", text: $userPrompt)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black) // Text color
                                .cornerRadius(5)
                            
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
                            } else if !aiResponse.isEmpty {
                                Text("Ответ от ИИ: \(aiResponse)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding(.horizontal)
                        
                        NavigationLink(destination: AiFriendView()) {
                            Text("Друг ИИ")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(5)
                                .padding(.top, 20)
                        }
                    }
                }
                .padding(.top, 10)
            }
            .onAppear {
                viewModel.fetchPopularMovies()
                viewModel.fetchGenres()
            }
        }
    }
}

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var isShowingTrailerView = false
    @State private var activeAlert: ActiveAlert? = nil // Используем enum для управления alert'ами
    var hasSubscription: Bool
    
    enum ActiveAlert: Identifiable {
        case subscription
        case download
        
        var id: Int {
            switch self {
            case .subscription: return 1
            case .download: return 2
            }
        }
    }

    
    var body: some View {
        let url = Bundle.main.url(forResource: "venom-3", withExtension: "mp4")!
        
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: URL(string: movie.posterURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray.frame(height: 300)
                    }

                    HStack {
                        Text(movie.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            if hasSubscription {
                                downloadTrailer(url: url)
                            } else {
                                activeAlert = .subscription
                            }
                        }) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(hasSubscription ? Color.orange : Color.blue)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)

                    Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .padding(.horizontal)
                    
                    Text("Описание")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    Text(movie.overview)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
                .background(Color.black)
            }
            
            Spacer()
            
            if hasSubscription {
                Button(action: {
                    isShowingTrailerView = true
                }) {
                    Text("Смотреть фильм")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .fullScreenCover(isPresented: $isShowingTrailerView) {
                    TrailerView()
                }
            } else {
                Button(action: {
                    if hasSubscription {
                        downloadTrailer(url: url)
                    } else {
                        activeAlert = .subscription
                    }
                }) {
                    Text("Получить подписку")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.black)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .subscription:
                return Alert(
                    title: Text("Пожалуйста, подключите подписку Netflix"),
                    message: Text("Для использования этой функции необходимо иметь активную подписку."),
                    dismissButton: .default(Text("ОК"))
                )
            case .download:
                return Alert(
                    title: Text("Скачано!"),
                    message: Text("Фильм успешно скачан."),
                    dismissButton: .default(Text("ОК"))
                )
            }
        }
    }
    
    func downloadTrailer(url: URL) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let downloadsDirectory = documentDirectory.appendingPathComponent("Downloads")
        
        if !fileManager.fileExists(atPath: downloadsDirectory.path) {
            try? fileManager.createDirectory(at: downloadsDirectory, withIntermediateDirectories: true)
        }
        
        let destinationURL = downloadsDirectory.appendingPathComponent(url.lastPathComponent)
        
        URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let localURL = localURL {
                do {
                    try fileManager.moveItem(at: localURL, to: destinationURL)
                    print("File downloaded to: \(destinationURL.path)")
                    DispatchQueue.main.async {
                        activeAlert = .download // Показываем Alert после загрузки
                    }
                } catch {
                    print("Error downloading file: \(error)")
                }
            }
        }.resume()
    }
}

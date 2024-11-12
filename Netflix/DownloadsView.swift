import SwiftUI
import AVKit

struct DownloadsView: View {
    @State private var downloadedFiles: [URL] = [] // Массив для хранения загруженных файлов
    
    var body: some View {
        VStack {
            if downloadedFiles.isEmpty {
                Text("Нет загруженных фильмов")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            } else {
                Text("Ваши фильмы")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                List {
                    ForEach(downloadedFiles, id: \.self) { fileURL in
                        VStack {
                            Text(fileURL.lastPathComponent)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // Кнопка для просмотра видео
                            Button("Смотреть") {
                                playVideo(from: fileURL)
                            }
                            .padding()
                            .background(Color("NetflixRed"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.vertical)
                    }
                    .onDelete(perform: deleteFile) // Обработчик удаления
                }
            }
            
            // Кнопка для загрузки нового фильма
            /*
            Button("Загрузить новый фильм") {
                downloadVideo()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top, 20) */
        }
        .onAppear {
            loadDownloadedFiles()
        }
    }
    
    func loadDownloadedFiles() {
        // Загрузка ранее загруженных файлов из директории приложения
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let downloadsDirectory = documentDirectory.appendingPathComponent("Downloads")
        if let files = try? fileManager.contentsOfDirectory(at: downloadsDirectory, includingPropertiesForKeys: nil) {
            downloadedFiles = files.filter { $0.pathExtension == "mp4" }
        }
    }
    
    func downloadVideo() {
        // Пример URL для загрузки видео
        guard let videoURL = URL(string: "trailer.mp4") else { return }
        
        // Получение директории документов
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Создание директории для загрузок, если ее нет
        let downloadsDirectory = documentDirectory.appendingPathComponent("Downloads")
        if !fileManager.fileExists(atPath: downloadsDirectory.path) {
            try? fileManager.createDirectory(at: downloadsDirectory, withIntermediateDirectories: true)
        }
        
        // Установка пути для сохранения файла
        let destinationURL = downloadsDirectory.appendingPathComponent(videoURL.lastPathComponent)
        
        // Загрузка видео
        URLSession.shared.downloadTask(with: videoURL) { localURL, response, error in
            if let localURL = localURL {
                do {
                    // Перемещение файла в директорию приложения
                    try fileManager.moveItem(at: localURL, to: destinationURL)
                    
                    // Обновление UI, загрузка файлов
                    DispatchQueue.main.async {
                        loadDownloadedFiles()
                    }
                } catch {
                    print("Ошибка загрузки файла: \(error)")
                }
            }
        }.resume()
    }
    
    func playVideo(from url: URL) {
        // Воспроизведение загруженного видео с использованием AVPlayer
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        // Показ AVPlayerViewController для воспроизведения видео
        UIApplication.shared.windows.first?.rootViewController?.present(playerViewController, animated: true) {
            player.play()
        }
    }
    
    func deleteFile(at offsets: IndexSet) {
        let fileManager = FileManager.default
        for index in offsets {
            let fileURL = downloadedFiles[index]
            do {
                // Удаление файла
                try fileManager.removeItem(at: fileURL)
                
                // Обновление массива после удаления
                downloadedFiles.remove(at: index)
            } catch {
                print("Ошибка при удалении файла: \(error)")
            }
        }
    }
}

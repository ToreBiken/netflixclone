import SwiftUI
import AVKit

// Представление для отображения локального видео через AVPlayerViewController
struct IntroVideoPlayerView: View {
    let videoName: String
    @State private var playerViewController = AVPlayerViewController()
    
    var body: some View {
        VStack {
            PlayerView(playerViewController: $playerViewController)
                .onAppear {
                    loadVideo()
                }
                .onDisappear {
                    playerViewController.player?.pause() // Останавливаем видео при исчезновении
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func loadVideo() {
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            let player = AVPlayer(url: url)
            playerViewController.player = player
            player.play()
        } else {
            print("Не удалось найти видео в Bundle")
        }
    }
}

// Представление, оборачивающее AVPlayerViewController
struct PlayerView: UIViewControllerRepresentable {
    @Binding var playerViewController: AVPlayerViewController
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}


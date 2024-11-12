import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoName: String
    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
                    player = AVPlayer(url: URL(fileURLWithPath: path))
                    player?.play()
                }
            }
            .onDisappear {
                player?.pause()
            }
    }
}

import AVKit
import SwiftUI

struct TrailerView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        let url = Bundle.main.url(forResource: "venom-3", withExtension: "mp4")!
        
        ZStack(alignment: .topLeading) {
            // Video playback
            VideoPlayer(player: AVPlayer(url: url))
                .onAppear {
                    AVPlayer(url: url).play()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // Close button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
            // Download button
         
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
                } catch {
                    print("Error downloading file: \(error)")
                }
            }
        }.resume()
    }
}

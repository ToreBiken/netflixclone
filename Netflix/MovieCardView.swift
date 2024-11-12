import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let hasSubscription: Bool // New property

    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie, hasSubscription: hasSubscription)) { // Pass hasSubscription to MovieDetailView
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: movie.posterURL)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .clipped()
                } placeholder: {
                    Color.gray.frame(width: 150, height: 200)
                }
                
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text("⭐️ \(movie.voteAverage, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }
            .frame(width: 150)
            .padding(.leading, 10)
        }
    }
}

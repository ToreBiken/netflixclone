// Movie.swift

import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double

    var posterURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, posterPath = "poster_path", overview, voteAverage = "vote_average"
    }
}

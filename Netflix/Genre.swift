// Genre.swift

import Foundation

struct Genre: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct GenreResponse: Decodable {
    let genres: [Genre]
}

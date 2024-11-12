// MovieService.swift

import Foundation
import Combine

class MovieService {
    private var cancellables = Set<AnyCancellable>()

    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(APIConfig.baseURL)/movie/popular?api_key=\(APIConfig.apiKey)&language=ru-RU")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchMoviesByGenre(genreId: Int) -> AnyPublisher<[Movie], Error> {
        let url = URL(string: "\(APIConfig.baseURL)/discover/movie?api_key=\(APIConfig.apiKey)&language=ru-RU&with_genres=\(genreId)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchGenres() -> AnyPublisher<[Genre], Error> {
        let url = URL(string: "\(APIConfig.baseURL)/genre/movie/list?api_key=\(APIConfig.apiKey)&language=ru-RU")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GenreResponse.self, decoder: JSONDecoder())
            .map(\.genres)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

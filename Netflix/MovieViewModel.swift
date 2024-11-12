// MovieViewModel.swift

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var moviesByGenre: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var selectedGenreId: Int?

    private var movieService = MovieService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchPopularMovies()
        fetchGenres()
    }

    func fetchPopularMovies() {
        movieService.fetchPopularMovies()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Ошибка загрузки популярных фильмов: \(error)")
                }
            }, receiveValue: { [weak self] movies in
                self?.popularMovies = movies
            })
            .store(in: &cancellables)
    }

    func fetchGenres() {
        movieService.fetchGenres()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Ошибка загрузки жанров: \(error)")
                }
            }, receiveValue: { [weak self] genres in
                self?.genres = genres
            })
            .store(in: &cancellables)
    }

    func fetchMoviesByGenre(genreId: Int) {
        movieService.fetchMoviesByGenre(genreId: genreId)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Ошибка загрузки фильмов по жанру: \(error)")
                }
            }, receiveValue: { [weak self] movies in
                self?.moviesByGenre = movies
            })
            .store(in: &cancellables)
    }

    func selectGenre(_ genreId: Int?) {
        selectedGenreId = genreId
        if let genreId = genreId {
            fetchMoviesByGenre(genreId: genreId)
        } else {
            moviesByGenre = popularMovies
        }
    }
}

//
//  MovieListViewModel.swift
//  MovieInfo
//
//  Created by Phat Chiem on 4/7/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieListViewModel {
    private let movieService: MovieService
    private let disposeBag = DisposeBag()
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    var numberOfMovies: Int {
        return _movies.value.count
    }
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    init(endpoint: Driver<Endpoint>, movieService: MovieService) {
        self.movieService = movieService
        endpoint.drive(onNext: { [weak self] (endpoint) in
            self?.fetchMovies(endpoint: endpoint)
        }).disposed(by: disposeBag)
    }
    
    func viewModelForMovie(at index: Int) -> MovieViewViewModel? {
        guard index < _movies.value.count else {
            return nil
        }
        
        return MovieViewViewModel(movie: _movies.value[index])
    }
    
    private func fetchMovies(endpoint: Endpoint) {
        _movies.accept([])
        _isFetching.accept(true)
        _error.accept(nil)
        
        movieService.fetchMovies(from: endpoint, params: nil, successHandler: { [weak self] (response) in
            self?._isFetching.accept(false)
            self?._movies.accept(response.results)
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        }
    }
}

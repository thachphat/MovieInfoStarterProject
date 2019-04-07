//
//  MovieSearchViewModel.swift
//  MovieInfo
//
//  Created by Phat Chiem on 4/7/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieSearchViewModel {
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
    var hasError: Driver<Bool> {
        return _error.map { $0 != nil }.asDriver(onErrorJustReturn: false)
    }
    
    init(query: Driver<String?>, movieService: MovieService) {
        self.movieService = movieService
        query
            .throttle(1)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (query) in
                self?.searchMovies(query: query)
        }).disposed(by: disposeBag)
    }
    
    func viewModelForMovie(at index: Int) -> MovieViewViewModel? {
        guard index < numberOfMovies else {
            return nil
        }
        
        return MovieViewViewModel(movie: _movies.value[index])
    }
    
    private func searchMovies(query: String?) {
        _movies.accept([])
        guard let query = query, !query.isEmpty else {
            _error.accept("Start searching your favorite movies")
            return
        }
        
        _isFetching.accept(true)
        _error.accept(nil)
        
        movieService.searchMovie(query: query, params: nil, successHandler: { [weak self] (response) in
            self?._isFetching.accept(false)
            if response.results.count == 0 {
                self?._error.accept("No result for \(query)")
            } else {
                self?._movies.accept(response.results)
            }
        }) { [weak self] (error) in
            self?._isFetching.accept(false)
            self?._error.accept(error.localizedDescription)
        }
    }
}

//
//  MovieViewViewModel.swift
//  MovieInfo
//
//  Created by Phat Chiem on 4/7/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

struct MovieViewViewModel {
    let movie: Movie
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var title: String {
        return movie.title
    }
    
    var overview: String {
        return movie.overview
    }
    
    var posterURL: URL {
        return movie.posterURL
    }
    
    var releaseDate: String {
        return MovieViewViewModel.dateFormatter.string(from: movie.releaseDate)
    }
    
    var rating: String {
        let rating = Int(movie.voteAverage)
        return (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
    }
}

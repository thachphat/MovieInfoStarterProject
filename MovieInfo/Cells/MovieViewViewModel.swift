//
//  MovieViewViewModel.swift
//  MovieInfo
//
//  Created by Phat Chiem on 4/7/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

protocol CellViewModelProtocol {
    var title: String { get }
    var overview: String { get }
    var posterURL: URL { get }
    var releaseDate: String { get }
    var rating: String { get }
}

struct MovieViewViewModel: CellViewModelProtocol {
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

struct TestCellViewModel: CellViewModelProtocol {
    var title: String = "title"
    
    var overview: String = "overview"
    
    var posterURL: URL = URL(string: "https://www.google.com/search?q=random+image&tbm=isch&source=iu&ictx=1&fir=0VlsWP7C5cWnBM%253A%252CeLpSyvMoM8brnM%252C_&vet=1&usg=AI4_-kSO0Mtatvj4KpEBvph4QSvwkvfYEg&sa=X&ved=2ahUKEwie2OzGl8rhAhUJdXAKHZ2vBC4Q9QEwAXoECAYQBg#imgrc=0VlsWP7C5cWnBM:")!
    
    var releaseDate: String = "release date"
    
    var rating: String = "rating"
}

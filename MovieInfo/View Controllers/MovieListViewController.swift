//
//  MovieListViewController.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private var movieListViewModel: MovieListViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let endpoint = segmentedControl.rx.selectedSegmentIndex.map {
            Endpoint(index: $0) ?? .nowPlaying
            }.asDriver(onErrorJustReturn: .nowPlaying)
        movieListViewModel = MovieListViewModel(endpoint: endpoint, movieService: MovieStore.shared)
        
        movieListViewModel?.movies.drive(onNext: { [unowned self] (_) in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        movieListViewModel?.error.drive(onNext: { [unowned self] (error) in
            self.infoLabel.isHidden = error == nil
            self.infoLabel.text = error
        }).disposed(by: disposeBag)
        
        movieListViewModel?.isFetching.drive(onNext: { [unowned self] (isFetching) in
            if isFetching {
                self.activityIndicatorView.startAnimating()
            } else {
                self.activityIndicatorView.stopAnimating()
            }
            self.infoLabel.isHidden = isFetching
        }).disposed(by: disposeBag)
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListViewModel?.numberOfMovies ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        if let viewModel = movieListViewModel?.viewModelForMovie(at: indexPath.row) {
            cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
}

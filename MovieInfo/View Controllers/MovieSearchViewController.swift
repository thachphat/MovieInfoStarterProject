//
//  MovieSearchViewController.swift
//  MovieInfo
//
//  Created by Alfian Losari on 10/03/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var viewModel: MovieSearchViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        let searchBar = navigationItem.searchController!.searchBar
        viewModel = MovieSearchViewModel(query: searchBar.rx.text.asDriver(), movieService: MovieStore.shared)
        
        viewModel?.movies.drive(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel?.error
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.hasError
            .map { !$0 }
            .drive(infoLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel?.isFetching
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak searchBar] in
                searchBar?.resignFirstResponder()
            })
        .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak searchBar] in
                searchBar?.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController?.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfMovies ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        if let viewModel = viewModel?.viewModelForMovie(at: indexPath.row) {
        cell.configure(viewModel: viewModel)
        }
        
        return cell
    }
}

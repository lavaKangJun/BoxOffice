//
//  MovieListTableViewController.swift
//  BoxOffice
//
//  Created by 강준영 on 06/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    private let tableViewCellId = "MovieListTableCell"
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private var tableviewRefreshControl = UIRefreshControl()
    var movieList: [MovieList] = []  {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
    var orderNumber = MovieSorting.sortingReservation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        request()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = self.tableviewRefreshControl
        } else{
            tableView.addSubview(tableviewRefreshControl)
        }
        
        self.tableviewRefreshControl.addTarget(self, action: #selector(refreshMovieData), for: .valueChanged)
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
    }
    
    private func request(usingIndicator: Bool = true) {
        MovieAPI.shared.movieInfoRequest(requestType: RequestType.movieList, value: orderNumber.rawValue) { [weak self](success, error, movieListResult: MovieListResult?) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                (usingIndicator) ? self.activityIndicatorView.stopAnimating() : self.tableviewRefreshControl.endRefreshing()
            }
            if success, let movieListResult = movieListResult {
                self.movieList = movieListResult.movies
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "문제발생", message: "데이터를 가져올 수 없습니다.")
                }
            }
        }
    }
    
    //MARK:- Refresh
    @objc func refreshMovieData() {
        request(usingIndicator: false)
    }
   
    //MARK:- Setup func
    func setupTableView() {
        let nib = UINib(nibName: "MovieListTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableViewCellId)
    }
    
    //MARK:- TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? MovieListTableCell else {
            return UITableViewCell()
        }
        
        cell.movieList = self.movieList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailTableView = MovieDetailTableViewController()
        let movieList = self.movieList[indexPath.row]
        movieDetailTableView.movieId = movieList.id
        movieDetailTableView.movietitle = movieList.title
        navigationController?.pushViewController(movieDetailTableView, animated: true)
    }

}

//
//  MovieListCollectionViewController.swift
//  BoxOffice
//
//  Created by 강준영 on 06/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    //MARK:- Property
    private let collectionViewCellId = "MovieListCollectionCell"
    private let movieListURL = "http://connect-boxoffice.run.goorm.io/movies?order_type="
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private var collectionViewRefreshControl = UIRefreshControl()
    
    // 중복되는 코드를 피하기 위해 didSet에 표시
    var movieList: [MovieList] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    var orderNumber: MovieSorting = MovieSorting.sortingReservation
    
    //MARK:- init
    //init  정의한 이유 -> UICollectionViewFlowLayout가 없으니 collectionView가 보이지 않아서
    //UICollectionViewFlowLayout: A flow layout works with the collection view’s delegate object to determine the size of items, headers, and footers in each section and grid.
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        collectionView.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        setupCollectionView()
        request()
        
        // iOS 10.0 이상 버전인 경우
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = self.collectionViewRefreshControl
        } else{
            collectionView.addSubview(collectionViewRefreshControl)
        }
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()

        self.collectionViewRefreshControl.addTarget(self, action: #selector(refreshMovieData), for: .valueChanged)
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("change collectionview layout")
        coordinator.animate(alongsideTransition: { (_) in
            // 현재의 레이아웃을 무효화 시킨다.
            self.collectionViewLayout.invalidateLayout()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    private func request(usingIndicator: Bool = true) {
        movieInfoRequest(urlString: movieListURL, value: orderNumber.rawValue) { [weak self](success, error, movieListResult: MovieListResult?) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                (usingIndicator) ? self.activityIndicatorView.stopAnimating() : self.collectionViewRefreshControl.endRefreshing()
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
    
    //MARKL:- Refresh
    @objc func refreshMovieData() {
        request(usingIndicator: false)
    }
    
    //MARK:- Setup CollectionView
    func setupCollectionView() {
        let nib:UINib = UINib(nibName: "MovieListCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: collectionViewCellId)
    }
    
    //MARK:- CollectionView
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? MovieListCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.movieList = self.movieList[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWith = UIScreen.main.bounds.width / 2
        return CGSize(width: halfWith - 7, height: 305)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetailTableView = MovieDetailTableViewController()
        let movieList = self.movieList[indexPath.row]
        movieDetailTableView.movieId = movieList.id
        movieDetailTableView.movietitle = movieList.title
        navigationController?.pushViewController(movieDetailTableView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)
    }
    
   

}

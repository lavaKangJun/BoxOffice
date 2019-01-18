//
//  MainTabBarController.swift
//  BoxOffice
//
//  Created by 강준영 on 06/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let movieListURL = "http://connect-boxoffice.run.goorm.io/movies?order_type="
    var tableViewController: MovieListTableViewController?
    var collectionViewController: MovieListCollectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabBar.barTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        setupViewControllers()
    }

    //MARK:- Setup Function
    func setupViewControllers() {
        
        viewControllers = [
            generateNavigationController(for: MovieListTableViewController(), title: "Table", barItemTitle: "예매율순", image: #imageLiteral(resourceName: "ic_list")),
            generateNavigationController(for: MovieListCollectionViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: UICollectionViewFlowLayout()), title: "Collection", barItemTitle: "예매율순", image: #imageLiteral(resourceName: "ic_collection"))
        ]
    }
    
    //MARK:- Helper Function
    func generateNavigationController(for viewcontroller: UIViewController, title: String, barItemTitle: String, image: UIImage) -> UIViewController {
        let settingButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_settings"), style: .plain, target: self, action: #selector(sortingMovieList))
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.title = barItemTitle
        navigationItem.rightBarButtonItem = settingButton
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewcontroller.tabBarItem.title = title
        viewcontroller.tabBarItem.image = image
        
        return viewcontroller
    }
    
    @objc func sortingMovieList () {
        
        guard let tableView = viewControllers?[0] as? MovieListTableViewController else {
            return
        }
        
        guard let collectionViw = viewControllers?[1] as? MovieListCollectionViewController else {
            return
        }
    
        let alertController: UIAlertController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationAction: UIAlertAction = UIAlertAction(title: "예매율", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            movieInfoRequest(urlString: self.movieListURL, value: MovieSorting.sortingReservation.rawValue) { (success, error, movieListResult: MovieListResult?) -> (Void) in
               
                if success {
                    if let movieListResult = movieListResult {
                        let movieList = movieListResult.movies
                        tableView.movieList = movieList
                        collectionViw.movieList = movieList
                        tableView.orderNumber = MovieSorting.sortingReservation
                        collectionViw.orderNumber = MovieSorting.sortingReservation
                        DispatchQueue.main.async {
                            self.navigationItem.title = "예매율순"
                        }
                    }
                } else {
                    showAlert(viewcontroller: self, title: "문제발생", message: "데이터를 읽어올 수 없습니다.")
                }
            }
        }
        
        let curationAction: UIAlertAction = UIAlertAction(title: "큐레이션", style: .default) { [weak self] _ in
             guard let self = self else {
                return
            }
            movieInfoRequest(urlString: self.movieListURL, value: MovieSorting.sortingCuration.rawValue)  { (success, error, movieListResult: MovieListResult?) -> (Void) in
                if success {
                    if let movieListResult = movieListResult {
                        let movieList = movieListResult.movies
                        tableView.movieList = movieList
                        tableView.orderNumber = MovieSorting.sortingCuration
                        collectionViw.orderNumber = MovieSorting.sortingCuration
                        collectionViw.movieList = movieList
                        DispatchQueue.main.async {
                            self.navigationItem.title = "큐레이션"
                        }
                    }
                } else {
                    showAlert(viewcontroller: self, title: "문제발생", message: "데이터를 읽어올 수 없습니다.")
                }
            }
        }
        
        let openDayAction: UIAlertAction = UIAlertAction(title: "개봉일", style: .default) {
            [weak self] _ in
            guard let self = self else {
                return
            }
            movieInfoRequest(urlString: self.movieListURL, value: MovieSorting.sortingOpenDay.rawValue) { (success, error, movieListResult: MovieListResult?) -> (Void) in
                if success {
                    if let movieListResult = movieListResult {
                        let movieList = movieListResult.movies
                        tableView.movieList = movieList
                        collectionViw.movieList = movieList
                        tableView.orderNumber = MovieSorting.sortingOpenDay
                        collectionViw.orderNumber = MovieSorting.sortingOpenDay
                        DispatchQueue.main.async {
                            self.navigationItem.title = "개봉일"
                        }
                    }
                } else {
                    showAlert(viewcontroller: self, title: "문제발생", message: "데이터를 읽어올 수 없습니다.")
                }
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(reservationAction)
        alertController.addAction(curationAction)
        alertController.addAction(openDayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


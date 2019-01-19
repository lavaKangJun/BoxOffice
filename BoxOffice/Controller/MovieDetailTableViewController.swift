//
//  MovieDetailTableViewController.swift
//  BoxOffice
//
//  Created by 강준영 on 13/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieDetailTableViewController: UITableViewController, UITextViewDelegate {

    private let cache: NSCache = NSCache<NSString, UIImage>()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private let movieDetailURL = "http://connect-boxoffice.run.goorm.io/movie?id="
    private let movieCommentURL = "http://connect-boxoffice.run.goorm.io/comments?movie_id="
    var movieId: String?
    var movietitle: String?
    var movieDetail: MovieDetailResult? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicatorView.stopAnimating()
                self?.setupTableViewHeader()
                self?.tableView.reloadData()
            }
        }
    }
    var movieReviewList: [MovieReview] = [] {
        didSet{
            DispatchQueue.main.async { [weak self] in
                 self?.tableView.reloadData()
            }
        }
    }
    var detailView: MovieDetailViewMovieInfo = {
        guard let headerView = Bundle.main.loadNibNamed("MovieDetailViewMovieInfo", owner: self, options: nil)?.first as? MovieDetailViewMovieInfo else {
            return MovieDetailViewMovieInfo()
        }
        return headerView
    }()
    var movieDerectorActorCellId = "movieDirectorActorTableCell"
    var movieStoryCellId = "movieStoryTableCell"
    var movieCommentWithButtonCellId = "movieCommentGoWriteReviewTableCell"
    var movieCommentCellId = "movieCommentOfUserTableCell"
    var bigImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.title = movietitle
        tableView.tableHeaderView = detailView
        
        activityIndicatorView.color = UIColor.gray
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = self.view.frame
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        
        setupTableViewHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let movieId = movieId else {
            return
        }
        
        movieInfoRequest(urlString: movieDetailURL, value: movieId) { [weak self](success, error, movieDetail: MovieDetailResult?) in
            guard let self = self else {
                return
            }
            if success {
                if let movieDetail = movieDetail {
                    self.movieDetail  = movieDetail
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.showErrorAlert()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.showErrorAlert()
                }
            }
        }
        
        movieInfoRequest(urlString: movieCommentURL, value: movieId) { [weak self] (success, error, movieReviewList: MovieReviewList?) in
            guard let self = self else {
                return
            }
            if success {
                if let movieReviewList = movieReviewList {
                    self.movieReviewList = movieReviewList.comments
                } else {
                    DispatchQueue.main.async {
                        self.showErrorAlert()
                    }
                }
            } else{
                DispatchQueue.main.async {
                    self.showErrorAlert()
                }
            }
        }
    }
    
    // MARK: - TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return movieReviewList.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movieDetail = self.movieDetail else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieStoryCellId, for: indexPath) as? MovieStoryTableCell else {
            return UITableViewCell()
            }
            cell.movieStoryTextView.text = movieDetail.synopsis
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieDerectorActorCellId, for: indexPath) as? MovieDirectorActorTableCell else {
                return UITableViewCell()
            }
            cell.directorLabel.text = movieDetail.director
            cell.actorLabel.text = movieDetail.actor
            return cell
        } else if indexPath.section == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieCommentWithButtonCellId, for: indexPath) as? MovieCommentGoWriteReviewTableCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: movieCommentCellId, for: indexPath) as? MovieCommentOfUserTableCell else {
                return UITableViewCell()
            }
            let movieReviewList = self.movieReviewList[indexPath.row]
            cell.movieReviewList = movieReviewList
            return cell
        }
    }
    
    //MARK:- setup TableView
    func setupTableview() {
        self.tableView.register(UINib(nibName: "MovieStoryTableCell", bundle: nil), forCellReuseIdentifier: movieStoryCellId)
         self.tableView.register(UINib(nibName: "MovieDirectorActorTableCell", bundle: nil), forCellReuseIdentifier: movieDerectorActorCellId)
         self.tableView.register(UINib(nibName: "MovieCommentGoWriteReviewTableCell" , bundle: nil), forCellReuseIdentifier: movieCommentWithButtonCellId)
        self.tableView.register(UINib(nibName: "MovieCommentOfUserTableCell", bundle: nil), forCellReuseIdentifier: movieCommentCellId)
    }
    
    
    func setupTableViewHeader() {
        guard let movieDetail = self.movieDetail else {
            return
        }
        let moviePosterTapGesture = UITapGestureRecognizer(target: self, action: #selector(moviePosterTapGesture(gestureRecognizer:)))
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        detailView.moviePosterImageView.isUserInteractionEnabled = true
        detailView.moviePosterImageView.addGestureRecognizer(moviePosterTapGesture)
        
        setupMovieGradeImage(grade: movieDetail.grade)
        setupMoviePosterImage()
        
        detailView.movieTitleLabel.text = movieDetail.title
        detailView.movieGenreLabel.text = movieDetail.genreAndDuration
        detailView.movieOpenDayLabel.text = movieDetail.longOpenDay
        detailView.reservationInfoLabel.text = movieDetail.reservationInfo
        detailView.userRatingLabel.text = movieDetail.userRating.toString
        detailView.audienceLabel.text = numberFormatter.string(from: NSNumber(value: movieDetail.audience))
        
        // tag: View 객체를 식별하는 데 사용된다.
        detailView.userRatingImageView.forEach { //sequence를 따르는 데이터 타입에 사용
            //floor 소숫점 아래 버림
            if $0.tag < Int(floor(Double(movieDetail.userRating) / 2)) {
                $0.image = UIImage(named: "ic_star_large_full")
            //ceil 소숫점아래 다 버리고 정수 1을 더함
            } else if $0.tag < Int(ceil(Double(movieDetail.userRating) / 2)) {
                $0.image = UIImage(named: "ic_star_large_half")
            } else {
                $0.image = UIImage(named: "ic_star_large")
            }
        }
    }
    
    func setupMovieGradeImage(grade: Int) {
        switch grade {
        case 0:
            detailView.gradeImageView.image = UIImage(named: "ic_allages")
        case 12:
            detailView.gradeImageView.image = UIImage(named: "ic_12")
        case 15:
            detailView.gradeImageView.image = UIImage(named: "ic_15")
        case 19:
            detailView.gradeImageView.image = UIImage(named: "ic_19")
        default:
            detailView.gradeImageView.image = UIImage(named: "ic_allages")
        }
    }
    
    func setupMoviePosterImage(){
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            
            guard let movieDetail = self.movieDetail else {
                return
            }
      
            guard let imageURL: URL = URL(string: movieDetail.image ) else {
                return
            }
            
            // caching image
            if let image = self.cache.object(forKey: imageURL.absoluteString as NSString) {
                self.bigImage = image
                DispatchQueue.main.async {
                    self.detailView.moviePosterImageView.image = image
                }
            }else {
                do {
                    let imageData: Data = try Data(contentsOf: imageURL)
                    self.cache.setObject(UIImage(data: imageData) ?? #imageLiteral(resourceName: "img_placeholder"), forKey: imageURL.absoluteString as NSString)
                    self.bigImage = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.detailView.moviePosterImageView.image = UIImage(data: imageData)
                    }
                } catch (let error) {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.showAlert(title: "문제발생", message: "이미지를 가져올 수 없습니다.")
                    }
                }
            }
        }
    }

    @objc func moviePosterTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        let bigPosterViewController = BigPosterViewController()
        bigPosterViewController.imageView.image = bigImage
        //Modal 방식
        self.present(bigPosterViewController, animated: true, completion: nil)
        
    }
}

//
//  MovieListTableCell.swift
//  BoxOffice
//
//  Created by 강준영 on 10/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieListTableCell: UITableViewCell {
    
    //MARK:- UI IBOutlet
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var reservationRatingGradeLabel: UILabel!
    @IBOutlet weak var reservationRatingLabel: UILabel!
    @IBOutlet weak var openDayLabel: UILabel!
    
    let cache: NSCache = NSCache<NSString, UIImage>()
    
    var movieList: MovieList! {
        didSet {
            movieNameLabel.text = movieList.title
            userRatingLabel.text = movieList.userRating.toString
            reservationRatingLabel.text = movieList.reservationRate.toString
            reservationRatingGradeLabel.text = movieList.reservationGrade.toString
            openDayLabel.text = movieList.date
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else {
                    return
                }
                
                guard let imageURL: URL = URL(string: self.movieList.thumb) else {
                    return
                }
                
                // caching image
                if let image = self.cache.object(forKey: imageURL.absoluteString as NSString) {
                    DispatchQueue.main.async {
                        self.moviePosterImageView.image = image
                    }
                }else {
                    do {
                        let imageData: Data = try Data(contentsOf: imageURL)
                        self.cache.setObject(UIImage(data: imageData) ?? #imageLiteral(resourceName: "img_placeholder"), forKey: imageURL.absoluteString as NSString)
                        DispatchQueue.main.async {
                            self.moviePosterImageView.image = UIImage(data: imageData)
                        }
                    } catch (let error) {
                        print(error.localizedDescription)
                    }
                }
            }
            movieGradeImage(grade: movieList.grade)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func movieGradeImage(grade: Int) {
        switch grade {
        case 0:
            self.gradeImageView.image = UIImage(named: "ic_allages")
        case 12:
            self.gradeImageView.image = UIImage(named: "ic_12")
        case 15:
            self.gradeImageView.image = UIImage(named: "ic_15")
        case 19:
            self.gradeImageView.image = UIImage(named: "ic_19")
        default:
            self.gradeImageView.image = UIImage(named: "ic_allages")
        }
    }
}






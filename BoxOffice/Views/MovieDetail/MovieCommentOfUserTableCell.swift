//
//  MovieCommentOfUserTableCell.swift
//  BoxOffice
//
//  Created by 강준영 on 13/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieCommentOfUserTableCell: UITableViewCell {

    
    @IBOutlet weak var commentIdLabel: UILabel!
    @IBOutlet weak var commentDayLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet var userRatingImageView: [UIImageView]!
    
    var movieReviewList: MovieReview! {
        didSet{
            let date = Date(timeIntervalSince1970: movieReviewList.timestamp)
            let formatter = DateFormatter()
            formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = NSLocale.current
            
            let rating = movieReviewList.rating
            commentIdLabel.text = movieReviewList.writer
            commentDayLabel.text = formatter.string(from: date)
            commentTextLabel.text = movieReviewList.contents
            
            userRatingImageView.forEach {
                if $0.tag < Int(floor(Double(rating) / 2)) {
                    $0.image = UIImage(named: "ic_star_large_full")
                } else if $0.tag < Int(ceil(Double(rating) / 2)) {
                    $0.image = UIImage(named: "ic_star_large_half")
                } else {
                    $0.image = UIImage(named: "ic_star_large")
                }
            }
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

}

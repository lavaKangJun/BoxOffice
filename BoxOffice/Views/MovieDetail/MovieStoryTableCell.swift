//
//  MovieStoryTableViewCell.swift
//  BoxOffice
//
//  Created by 강준영 on 13/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import UIKit

class MovieStoryTableCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var movieStoryTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewDidChange(movieStoryTextView)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // 텍스트뷰 사이즈
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            print("textView Constraint: \(constraint)")
            if constraint.firstAttribute == .height {
                constraint.constant = estimateSize.height
            }
        }
    }
}

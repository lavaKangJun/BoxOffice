//
//  MovieInfoModel.swift
//  BoxOffice
//
//  Created by 강준영 on 10/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

struct MovieListResult: Codable {
    let movies: [MovieList]
}

struct MovieList: Codable {
    
    let userRating: Double
    let reservationGrade: Int
    let grade: Int
    let reservationRate: Double
    let title: String
    let date: String
    let thumb: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case grade, title, date, thumb, id
        case userRating = "user_rating"
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
    }
    
    var movieInfo: String  {
        return "\(self.reservationGrade)위(\(self.userRating)) / \(self.reservationRate)%"
    }
}

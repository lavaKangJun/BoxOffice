//
//  MovieDetailModel.swift
//  BoxOffice
//
//  Created by 강준영 on 13/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

struct MovieDetailResult: Codable {
    let audience: Int
    let grade: Int
    let actor: String
    let duration: Int
    let reservationGrade: Int
    let title: String
    let reservationRate:Double
    let userRating: Double
    let date: String
    let director: String
    let id: String
    let image: String
    let synopsis: String
    let genre: String
    
    enum CodingKeys: String, CodingKey {
        case audience, grade, actor, duration, title, date, director, id, image, synopsis, genre
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
    
    var longOpenDay: String {
        return "\(date) 개봉"
    }
    
    var genreAndDuration: String {
        return "\(genre)/\(duration)분"
    }
    
    var reservationInfo: String {
        return "\(reservationGrade)위 \(reservationRate)%"
    }
}


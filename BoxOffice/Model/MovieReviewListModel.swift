//
//  MovieReviewList.swift
//  BoxOffice
//
//  Created by 강준영 on 14/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

struct MovieReviewList: Codable {
    let comments: [MovieReview]
}

struct MovieReview: Codable {
  
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    
    //JSON파일의 타입키와 사용자 정의 프로퍼티 이름이 같지 않은경우
    // 동일하지 않으면 이름을 가져올 수 없기 떄문에 swift에서 네이밍할때 언더바를 사용하지 않기 때문
    //변경하고자 하는 프로퍼티에만 타입키와 동일한 원시값 할당
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }

}

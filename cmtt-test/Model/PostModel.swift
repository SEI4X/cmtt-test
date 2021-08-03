//
//  PostModel.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 27.07.2021.
//
import SwiftyJSON
import UIKit

struct PostData {
    let posts: [Post]
}

struct imgSize {
    let width: Int
    let height: Int
}

struct Post {
    let header: String?
    let description: String?
    let imageId: String?
    let imgWidth: Int?
    let imgHeight: Int?
    let author: String?
    let cathegory: String?
    let cathegoryImgId: String?
    let cathegoryBorderColor: String?
    let date: String?
    let commentsCount: String?
    let likesCount: String?
    
    
    init(json: JSON) {
        self.header = json["title"].stringValue
        self.description = json["blocks"][0]["data"]["text"].stringValue
        self.imageId = json["blocks"][1]["data"]["items"][0]["image"]["data"]["uuid"].stringValue
        self.imgWidth = json["blocks"][1]["data"]["items"][0]["image"]["data"]["width"].intValue
        self.imgHeight = json["blocks"][1]["data"]["items"][0]["image"]["data"]["height"].intValue
        self.author = json["author"]["name"].stringValue
        self.cathegory = json["subsite"]["name"].stringValue
        self.cathegoryImgId = json["subsite"]["avatar"]["data"]["uuid"].stringValue
        self.cathegoryBorderColor = json["subsite"]["avatar"]["data"]["color"].stringValue
        self.date = json["date"].stringValue
        self.commentsCount = json["counters"]["comments"].stringValue
        self.likesCount = json["likes"]["summ"].stringValue
    }
}


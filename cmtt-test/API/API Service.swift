//
//  API Service.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 28.07.2021.
//

import Alamofire
import SwiftyJSON

class PostAPIService {
    private var lastId: String = ""
    private var lastSortingValue: String = ""
    
    func getPosts(completion: @escaping (Result<PostData, Error>) -> Void) {
        var posts = [Post]()
        var url = "https://api.tjournal.ru/v2.0/timeline?allSite=true&sorting=date&subsitesIds=1%2C%202&hashtag=%D0%B8%D0%B3%D1%80%D1%8B"
        
        if lastId != "" {
            url += "&lastId=\(lastId)&lastSortingValue=\(lastSortingValue)"
        }
        
        let _ = AF.request(url).responseJSON(queue: .global(qos: .utility)) { response in
            let json = JSON(response.data!)
            for (_,subJson):(String, JSON) in json["result"]["items"] {
                posts.append(Post(json: subJson["data"]))
            }
            
            self.lastId = json["result"]["lastId"].stringValue
            self.lastSortingValue = json["result"]["lastSortingValue"].stringValue
            
            DispatchQueue.main.async {
                completion(.success(PostData(posts: posts)))
            }
        }
    }
    
    func refresh() {
        lastId = ""
        lastSortingValue = ""
    }
    
//    func addData(_ view: UIView, completion: @escaping (Result<[PostViewModel], Error>) -> ()) {
//        var viewModels = [PostViewModel]()
//        
//        self.getPosts { (result) in
//            switch result {
//            case .success(let listOf):
//                for post in listOf.posts {
//                    let viewModel = PostViewModel()
//                    viewModel.fetchData(view, post: post)
//                    viewModels.append(viewModel)
//                }
//                completion(.success(viewModels))
//                
//            case .failure(let error):
//                print("Error processing json data: \(error)")
//            }
//        }
//    }
}

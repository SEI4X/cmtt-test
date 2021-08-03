//
//  PostViewModel.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 29.07.2021.
//
import UIKit

final class PostViewModel {
    
    // MARK: - Private section
    
    private let postAPIService = PostAPIService()
    private var apiService: PostAPIService!
    private var imgDataTask: URLSessionDataTask!
    private var iconDataTask: URLSessionDataTask!
    private var cellSize = CGSize()
    private var header = String()
    private var description = String()
    private var imageId = String()
    private var imgWidth = Int()
    private var imgHeight = Int()
    private var author = String()
    private var cathegory = String()
    private var cathegoryImgId = String()
    private var cathegoryBorderColor = String()
    private var date = String()
    private var commentsCount = String()
    private var likesCount = String()
    private var image: UIImage? = nil
    private var cathegoryImage: UIImage? = nil
    
    private func calculateCellHeight(_ width: CGFloat, _ post: Post) -> CGSize {
        let allWidth = width - 32
        
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: allWidth, height: CGFloat.greatestFiniteMagnitude))
        titleLable.numberOfLines = 0
        titleLable.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLable.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLable.text = post.header
        titleLable.sizeToFit()
        
        let descriptionLable = UILabel(frame: CGRect(x: 0, y: 0, width: allWidth, height: CGFloat.greatestFiniteMagnitude))
        descriptionLable.numberOfLines = 0
        descriptionLable.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLable.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLable.text = post.description
        descriptionLable.sizeToFit()
   
        var imgCorp: CGFloat = 1
        var imgHeight: CGFloat = 0

        if (post.imgHeight != nil && post.imgWidth != nil
                && post.imgHeight != 0 && post.imgWidth != 0) {
            imgCorp = CGFloat(post.imgWidth!) / CGFloat(post.imgHeight!)
            if imgCorp != 0 { imgHeight = width / imgCorp + 12 }
        }
        
        let fullHeight = 50 + titleLable.frame.height + 8 + descriptionLable.frame.height + imgHeight + 52 + 4
        
        return CGSize(width: width , height: fullHeight)
    }
    
    private func downloadImage(imgId: String, isPostImg: Bool, imgView: UIImageView) {
        let imgUrl = URL(string: "https://leonardo.osnova.io/" + imgId)!
        imgView.image = nil
        
        if isPostImg {
            imgDataTask = URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Empty Data")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        imgView.image = image
                        self.image = image
                    }
                }
            }
            imgDataTask.resume()
            
        } else {
            
            iconDataTask = URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Empty Data")
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        imgView.image = image
                        self.cathegoryImage = image
                    }
                }
            }
            iconDataTask.resume()
        }
    }
    
    //MARK: - Public section
    
    func fetchData(_ frame: CGRect, post: Post, completion: @escaping ()->()) {
        var size = CGSize()
        size = self.calculateCellHeight(frame.width, post)
        self.cellSize = size
        self.header = post.header ?? ""
        self.description = post.description ?? ""
        self.imageId = post.imageId ?? ""
        self.imgWidth = post.imgWidth ?? 0
        self.imgHeight = post.imgHeight ?? 0
        self.author = post.author ?? ""
        self.cathegory = post.cathegory ?? ""
        self.cathegoryImgId = post.cathegoryImgId ?? ""
        self.cathegoryBorderColor = post.cathegoryBorderColor ?? ""
        self.date = post.date ?? ""
        self.commentsCount = post.commentsCount ?? ""
        self.likesCount = post.likesCount ?? ""
        completion()
    }
    
    func getImageWidth(_ index: Int) -> CGFloat {
        return CGFloat(self.imgWidth )
    }
    
    func getImageCorp(_ index: Int) -> CGFloat {
        return CGFloat((self.imgWidth) / (self.imgHeight == 0 ? 1 :self.imgHeight))
    }
    
    func getCellSize() -> CGSize { return cellSize }
    
    func getHeader() -> String { return self.header }
    
    func getDescription() -> String { return self.description }
    
    func getImageId() -> String { return self.imageId }
    
    func getImageWidth() -> Int { return self.imgWidth }
    
    func getImageHeight() -> Int { return self.imgHeight }
    
    func getAuthor() -> String { return self.author }
    
    func getCathegory() -> String { return self.cathegory }
    
    func getCathegoryImgId() -> String { return self.cathegoryImgId }
    
    func getCathegoryBorderColor() -> String { return self.cathegoryBorderColor }
    
    func getDate() -> String { return self.date }
    
    func getCommentsCount() -> String { return self.commentsCount }
    
    func getLikesCount() -> String { return self.likesCount }
    
    func getImage(imgView: UIImageView, imgIdFromCell: String){
        if self.image != nil {
            imgView.image = self.image
        } else if imageId != "" {
            downloadImage(imgId: imageId, isPostImg: true, imgView: imgView)
        }
    }
    
    func getCathegoryImage(imgView: UIImageView, imgIdFromCell: String) {
        if self.cathegoryImage != nil {
            imgView.image = self.cathegoryImage
        } else if (cathegoryImgId != "") {
            downloadImage(imgId: cathegoryImgId, isPostImg: false, imgView: imgView)
        }
    }
    
    func cancleImageLoading() {
        if imgDataTask != nil { self.imgDataTask.cancel() }
        if iconDataTask != nil { self.iconDataTask.cancel() }
    }
}

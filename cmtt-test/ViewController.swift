//
//  ViewController.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 27.07.2021.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout {
    
    private let darkBackground = UIView()
    private let zoomImageView = UIImageView()
    private let bgColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    private var viewModels = [PostViewModel]()
    private var postsAPIService = PostAPIService()
    private var postImageView: UIImageView?
    private var collectionView: UICollectionView!
    private var isLoading: Bool = true
    
    private var refreshControl: UIRefreshControl = {
        let refContrl = UIRefreshControl()
        refContrl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        refContrl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
        return refContrl
    }()
    
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 20
        layout.itemSize.width = UIScreen.main.bounds.width
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadPosts {
            DispatchQueue.main.async {
                self.isLoading = false
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    private func loadPosts(completion: @escaping ()->()) {
        let frame = view.frame
        DispatchQueue.global(qos: .utility).async {
            self.postsAPIService.getPosts { [weak self] (result) in
            
                switch result {
                case .success(let data):
                    for post in data.posts {
                        let viewModel = PostViewModel()
                        viewModel.fetchData(frame, post: post) {
                            self!.viewModels.append(viewModel)
                        }
                    }
                    completion()
                
                case .failure(_):
                    print("Error")
                }
            }
        }
    }
    
    @objc func refreshData() {
        postsAPIService.refresh()
        viewModels.removeAll()
        loadPosts {
            self.isLoading = false
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    @objc func animateImageView(postImageView: UIImageView) {
        self.postImageView = postImageView
        darkBackground.frame = view.frame
        darkBackground.backgroundColor = .black
        darkBackground.alpha = 0
        
        if let startingFrame = postImageView.superview?.convert(postImageView.frame, to: nil) {
            zoomImageView.backgroundColor = .white
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = postImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            postImageView.alpha = 0
            
            view.addSubview(darkBackground)
            view.addSubview(zoomImageView )
            
            UIView.animate(withDuration: 0.3) {
                self.darkBackground.alpha = 0.8
                let finishY = self.view.frame.height / 2 - self.zoomImageView.frame.height / 2
                self.zoomImageView.frame = CGRect(
                    x: 0, y: finishY,
                    width: self.zoomImageView.frame.width,
                    height: self.zoomImageView.frame.height)
            }
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = postImageView!.superview?.convert(postImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.3) {
                self.zoomImageView.frame = startingFrame
                self.darkBackground.alpha = 0
            } completion: { _ in
                self.zoomImageView.removeFromSuperview()
                self.darkBackground.removeFromSuperview()
                self.postImageView?.alpha = 1
            }

        }
    }
    
    // MARK: - Collection view configuration
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = bgColor
        collectionView.refreshControl = refreshControl
        
        collectionView?.register(PostViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(SpinnerCell.self, forCellWithReuseIdentifier: "indicator")
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: "empty")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModels.count > 0) ? (viewModels.count + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModels.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) as! EmptyCell
            return cell
        } else if indexPath.row != viewModels.count {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostViewCell
            cell.viewModel = viewModels[indexPath.item]
            cell.viewController = self
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicator", for: indexPath) as! SpinnerCell
            cell.inidicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == viewModels.count {
            return CGSize(width: view.frame.width, height: 100)
        } else {
            return viewModels[indexPath.item].getCellSize()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let loadPosition = collectionView.contentSize.height - 400 - collectionView.frame.height
        if (offsetY > loadPosition && !isLoading) {
            isLoading = true
            loadPosts {
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        // Delete all image's cahe
    }
}


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
    
    private var viewModels = [PostViewModel]()
    private var postsAPIService = PostAPIService()
    
    private let bgColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    private var collectionView: UICollectionView!
    private var isLoading: Bool = true
    
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
    
    // MARK: - Collection view configuration
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.backgroundColor = bgColor
        collectionView?.register(PostViewCell.self, forCellWithReuseIdentifier: "cellId")
        
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
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PostViewCell
        cell.viewModel = viewModels[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModels[indexPath.item].getCellSize()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let loadPosition = collectionView.contentSize.height - 400 - collectionView.frame.height
        if (offsetY > loadPosition && !isLoading) {
            isLoading = true
            print("YES")
            loadPosts {
                self.isLoading = false
                self.collectionView.reloadData()
            }
        }
    }
    
}


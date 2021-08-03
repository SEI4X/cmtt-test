//
//  CollectionViewCell.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 27.07.2021.
//

import UIKit

class PostViewCell: UICollectionViewCell {
    
    private var imgCorp: CGFloat = 1
    private var imgWidth: CGFloat = 0
    private var imgHeight: CGFloat = 0
    private var imgHeightConstraint: NSLayoutConstraint!
    private var defaultImgHeightConstraint: CGFloat!
    private var imgTopConstraint: NSLayoutConstraint!
    private var defaultImgTopConstraint: CGFloat!
    var viewModel: PostViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.hashtagIcon.image = nil
                self.postImageView.image = nil
                self.viewModel?.getImage(
                    imgView: self.postImageView,
                    imgIdFromCell: self.viewModel?.getImageId() ?? "")
                self.viewModel?.getCathegoryImage(
                    imgView: self.hashtagIcon,
                    imgIdFromCell: self.viewModel?.getCathegoryImgId() ?? "")
            }
            
            self.hashtagLable.text = viewModel?.getCathegory()
            self.authorLable.text = viewModel?.getAuthor()
            self.dateLable.text = viewModel?.getDate()
            self.titleLable.text = viewModel?.getHeader()
            self.postDescriptionLabel.text = viewModel?.getDescription()
            self.likesLabel.text = viewModel?.getLikesCount()
            self.commentLable.text = "\(viewModel?.getCommentsCount() ?? "")"
            self.imgWidth = CGFloat((viewModel?.getImageWidth() ?? 0))
            self.imgHeight = CGFloat(viewModel?.getImageHeight() ?? 1)
            if imgWidth != 0 && imgHeight != 0 {
                self.imgCorp = imgWidth / imgHeight
                let screenWidth = UIScreen.main.bounds.width
                imgHeightConstraint.constant = screenWidth / imgCorp
                imgTopConstraint.constant = 12
                layoutIfNeeded()
            } else {
                defaultImgHeightConstraint = 0
                defaultImgTopConstraint = 0
            }
        }
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private var hashtagIcon: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerCurve = .continuous
        iv.layer.cornerRadius = 6
        return iv
    }()
    private var hashtagLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    private var authorLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return lbl
    }()
    private var dateLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return lbl
    }()
    private var titleLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return lbl
    }()
    private var postDescriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()
    private var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return iv
    }()
    private var commentView: UIView = {
        let view = UIView()
        return view
    }()
    private var commentIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "comment-icon")
        iv.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        return iv
    }()
    private var commentLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    private var likesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(red: 0.00, green: 0.67, blue: 0.07, alpha: 1.00)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View configurations
    private func setupViews() {
        configureHeader()
        configureTitleAndDescription()
        configureImage()
        configureFooter()
        configureCommentView()
        
        if let lastSubview = contentView.subviews.last {
            contentView.bottomAnchor.constraint(equalTo: lastSubview.bottomAnchor).isActive = true
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        }
    }
    
    private func configureHeader() {
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        headerView.addSubview(hashtagIcon)
        hashtagIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hashtagIcon.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 17),
            hashtagIcon.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            hashtagIcon.widthAnchor.constraint(equalToConstant: 22),
            hashtagIcon.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        headerView.addSubview(hashtagLable)
        hashtagLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hashtagLable.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            hashtagLable.leadingAnchor.constraint(equalTo: hashtagIcon.trailingAnchor, constant: 8),
            hashtagLable.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        headerView.addSubview(authorLable)
        authorLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLable.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 17),
            authorLable.leadingAnchor.constraint(equalTo: hashtagLable.trailingAnchor, constant: 12),
            authorLable.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        headerView.addSubview(dateLable)
        dateLable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLable.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 17),
            dateLable.leadingAnchor.constraint(equalTo: authorLable.trailingAnchor, constant: 12),
            dateLable.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func configureTitleAndDescription() {
        contentView.addSubview(titleLable)
        contentView.addSubview(postDescriptionLabel)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            titleLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLable.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),
            
            postDescriptionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 8),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postDescriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),
        ])
    }
    
    private func configureImage() {
        contentView.addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        defaultImgHeightConstraint = 0
        defaultImgTopConstraint = 0
        
        imgTopConstraint = NSLayoutConstraint(
            item: postImageView,attribute: .top,
            relatedBy: .equal,
            toItem: postDescriptionLabel,
            attribute: .bottom,
            multiplier: 1,
            constant: defaultImgTopConstraint
        )
        
        imgHeightConstraint = NSLayoutConstraint(
            item: postImageView,attribute: .height,
            relatedBy: .equal,
            toItem: .none,
            attribute: .height,
            multiplier: 1,
            constant: defaultImgHeightConstraint
        )
        NSLayoutConstraint.activate([
            imgTopConstraint,
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imgHeightConstraint
        ])
    }
    
    private func configureFooter() {
        contentView.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 4),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            footerView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
        footerView.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12),
            commentView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            commentView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16)
        ])
        
        footerView.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12),
            likesLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            likesLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureCommentView() {
        commentView.addSubview(commentIcon)
        commentView.addSubview(commentLable)
        
        commentIcon.translatesAutoresizingMaskIntoConstraints = false
        commentLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentIcon.topAnchor.constraint(equalTo: commentView.topAnchor),
            commentIcon.leadingAnchor.constraint(equalTo: commentView.leadingAnchor),
            commentIcon.widthAnchor.constraint(equalToConstant: 24),
            commentIcon.heightAnchor.constraint(equalToConstant: 24),
            
            commentLable.topAnchor.constraint(equalTo: commentView.topAnchor),
            commentLable.leadingAnchor.constraint(equalTo: commentIcon.trailingAnchor, constant: 4),
            commentLable.trailingAnchor.constraint(equalTo: commentView.trailingAnchor),
            commentLable.bottomAnchor.constraint(equalTo: commentView.bottomAnchor)
        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.viewModel?.cancleImageLoading()
        self.hashtagLable.text = nil
        self.authorLable.text = nil
        self.dateLable.text = nil
        self.titleLable.text = nil
        self.postDescriptionLabel.text = nil
        self.likesLabel.text = nil
        self.commentLable.text = nil
        self.hashtagIcon.image = nil
        self.postImageView.image = nil
        self.imgHeightConstraint.constant = 0
        self.imgTopConstraint.constant = 0
        self.defaultImgTopConstraint = 0
        self.defaultImgHeightConstraint = 0
        self.imgCorp = 1
        self.imgWidth = 0
    }
}

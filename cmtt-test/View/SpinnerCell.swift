//
//  SpinnerCell.swift
//  cmtt-test
//
//  Created by Alexei Mashkov on 03.08.2021.
//

import UIKit

class SpinnerCell: UICollectionViewCell {
    var inidicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(inidicator)
        inidicator.center = self.contentView.center
        inidicator.startAnimating()
    }
}

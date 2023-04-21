//
//  CGClientTestingNudgeSetupView.swift
//  
//
//  Created by Ankit Jain on 21/04/23.
//

import UIKit

class CGClientTestingNudgeSetupView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView! // Hidden by default
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint! // 32px by default
    
    class func instanceFromNib() -> CGClientTestingNudgeSetupView? {
        return UINib(nibName: "CGClientTestingNudgeSetupView", bundle: .module).instantiate(withOwner: nil, options: nil)[0] as? CGClientTestingNudgeSetupView
    }
    
    private func setupTheme() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabelLeadingConstraint.constant = 32
    }
    
    func setupView(withNudgeType nudgeType: CGNudgeSubTask) {
        // Setup Theme
        setupTheme()
        
        titleLabel.text = nudgeType.getTitle()

        switch nudgeType.getStatus() {
        case .header:
            tickImageView.isHidden = true
            titleLabel.isHidden = true
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            tickImageView.image = nil
            
        case .success:
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let greenTickImage = UIImage(named: "greenTick", in: .module, compatibleWith: nil)
            tickImageView.image = greenTickImage
            
        case .failure:
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let redCrossImage = UIImage(named: "redCross", in: .module, compatibleWith: nil)
            tickImageView.image = redCrossImage
                                    
        case .pending:
            tickImageView.isHidden = true
            indicatorView.isHidden = false
            indicatorView.startAnimating()
        }
    }
}

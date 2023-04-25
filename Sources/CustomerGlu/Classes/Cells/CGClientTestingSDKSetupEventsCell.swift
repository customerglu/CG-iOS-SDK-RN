//
//  CGClientTestingSDKSetupEventsCell.swift
//  
//
//  Created by Ankit Jain on 23/02/23.
//

import UIKit

// MARK: - CGClientTestingSDKSetupEventsCellDelegate
protocol CGClientTestingSDKSetupEventsCellDelegate: NSObjectProtocol {
    func didTapRetry(forEvent event: CGClientTestingRowItem)
    func didTapCheckDoc(forEvent event: CGClientTestingRowItem)
}

// MARK: - CGClientTestingSDKSetupEventsCell
public class CGClientTestingSDKSetupEventsCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView! // Hidden by default
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var stackView: UIStackView! // To show sub task inside - for example for Nudge Handling else hidden for all types
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint! // 16px by default
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint! // 16px by default
    
    @IBOutlet weak var checkDocLabel: UILabel! // Hidden by default
    @IBOutlet weak var retryLabel: UILabel! // Hidden by default
    
    private weak var delegate: CGClientTestingSDKSetupEventsCellDelegate?
    private var eventItem: CGClientTestingRowItem?
    
    private func setupTheme() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .blue
    }
    
    func setupCell(forRowItem rowItem: CGClientTestingRowItem, delegate: CGClientTestingSDKSetupEventsCellDelegate?, clientTestingDataModel: CGClientTestingDataModel?) {
        // Setup Theme
        setupTheme()
        self.delegate = delegate
        eventItem = rowItem
        titleLabel.font = .systemFont(ofSize: 12)
        
        checkDocLabel.isHidden = true
        retryLabel.isHidden = true
        checkDocLabel.isUserInteractionEnabled = false
        retryLabel.isUserInteractionEnabled = false
        
        // Theme
        titleLabel.textColor = .black
        checkDocLabel.backgroundColor = .black
        checkDocLabel.textColor = .white
        retryLabel.backgroundColor = .black
        retryLabel.textColor = .white
        checkDocLabel.layer.cornerRadius = 12
        retryLabel.layer.cornerRadius = 12
        
        titleLabel.text = rowItem.getTitle()
        
        // Remove anything if already added in stack view
        for subview in stackView.subviews {
            subview.removeFromSuperview()
        }
        
        // Doing title comparision for nudge handling because the status can be anything like pending, failure, success
        if rowItem.getTitle() == CGClientTestingRowItem.nudgeHandling(status: .success).getTitle(), let clientTestingDataModel {
            // Constraints
            stackViewTopConstraint.constant = 16
            stackViewBottomConstraint.constant = 16
            
            let nudgeSubtaskArray = clientTestingDataModel.getNudgeHandlingSubTypeArray()
            for subtaskType in nudgeSubtaskArray {
                if let view = CGClientTestingNudgeSetupView.instanceFromNib() {
                    view.setupView(withNudgeType: subtaskType)
                    stackView.addArrangedSubview(view)
                }
            }
        } else {
            // Constraints
            stackViewTopConstraint.constant = 16
            stackViewBottomConstraint.constant = 0
        }

        switch rowItem.getStatus() {
        case .header:
            // To reduce the unnessary space for header
            stackViewTopConstraint.constant = 0

            titleLabel.font = .boldSystemFont(ofSize: 14)
            tickImageView.isHidden = false
            indicatorView.isHidden = false
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
                        
            checkDocLabel.text = "Check Doc"
            checkDocLabel.isHidden = false
            
            retryLabel.text = "Retry"
            retryLabel.isHidden = false
            
            checkDocLabel.isUserInteractionEnabled = true
            retryLabel.isUserInteractionEnabled = true
            
            let checkDocGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnCheckDoc))
            checkDocLabel.addGestureRecognizer(checkDocGesture)
            
            let retryGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnRetry))
            retryLabel.addGestureRecognizer(retryGesture)
            
        case .pending:
            tickImageView.isHidden = true
            indicatorView.isHidden = false
            indicatorView.startAnimating()
        }
    }
    
    @objc func didTapOnRetry() {
        if let delegate = delegate, let eventItem = eventItem {
                delegate.didTapRetry(forEvent: eventItem)
        }
    }
    
    @objc func didTapOnCheckDoc() {
        if let delegate = delegate, let eventItem = eventItem {
            delegate.didTapCheckDoc(forEvent: eventItem)
        }
    }
}

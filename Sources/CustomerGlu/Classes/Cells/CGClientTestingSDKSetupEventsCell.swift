//
//  CGClientTestingSDKSetupEventsCell.swift
//  
//
//  Created by Ankit Jain on 23/02/23.
//

import UIKit

// MARK: - CGClientTestingSDKSetupEventsCellDelegate
protocol CGClientTestingSDKSetupEventsCellDelegate: NSObjectProtocol {
    func didTapOnAction(forEvent event: CGClientTestingRowItem)
    func didTapRetry(forEvent event: CGClientTestingRowItem)
}

// MARK: - CGClientTestingSDKSetupEventsCell
public class CGClientTestingSDKSetupEventsCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView! // Hidden by default
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var actionButton: UIButton! // Hidden by default
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint! // 48px by default
    
    private weak var delegate: CGClientTestingSDKSetupEventsCellDelegate?
    private var eventItem: CGClientTestingRowItem?
    private var isRetry: Bool = false
    
    private func setupTheme() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .blue
    }
    
    func setupCell(forRowItem rowItem: CGClientTestingRowItem, delegate: CGClientTestingSDKSetupEventsCellDelegate?) {
        // Setup Theme
        setupTheme()
        self.isRetry = false
        self.delegate = delegate
        eventItem = rowItem
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabelLeadingConstraint.constant = 48
        
        switch rowItem.getStatus() {
        case .header:
            titleLabel.font = .boldSystemFont(ofSize: 14)
            titleLabelLeadingConstraint.constant = 16
            tickImageView.isHidden = false
            indicatorView.isHidden = false
            indicatorView.stopAnimating()
            tickImageView.image = nil
            
            titleLabel.textColor = .black
            actionButton.isHidden = true
            
        case .success:
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let greenTickImage = UIImage(named: "greenTick", in: .module, compatibleWith: nil)
            tickImageView.image = greenTickImage
            
            titleLabel.textColor = .black
            actionButton.isHidden = true
            
        case .failure:
            self.isRetry = true

            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let redCrossImage = UIImage(named: "redCross", in: .module, compatibleWith: nil)
            tickImageView.image = redCrossImage
            
            titleLabel.textColor = .black
            
            actionButton.setTitle("Retry", for: .normal)
            actionButton.setTitle("Retry", for: .selected)
            actionButton.titleLabel?.font = .systemFont(ofSize: 6, weight: .regular)
            actionButton.isHidden = false
        case .pending:
            tickImageView.isHidden = true
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            
            titleLabel.textColor = .black
            actionButton.isHidden = true
        }
        
        // Setting up the button
        switch rowItem {
        case .entryPointSetup:
//            actionButton.setTitle("Check Doc", for: .normal)
//            actionButton.setTitle("Check Doc", for: .selected)
//            actionButton.titleLabel?.font = .systemFont(ofSize: 8, weight: .regular)
            actionButton.isHidden = true
        default:
            if !isRetry {
                actionButton.isHidden = true
            }
        }
        
        titleLabel.text = rowItem.getTitle()
    }
    
    @IBAction func didTapOnAction() {
        if let delegate = delegate {
            if isRetry, let eventItem = eventItem {
                delegate.didTapRetry(forEvent: eventItem)
            } else if let eventItem = eventItem {
                delegate.didTapOnAction(forEvent: eventItem)
            }
        }
    }
}

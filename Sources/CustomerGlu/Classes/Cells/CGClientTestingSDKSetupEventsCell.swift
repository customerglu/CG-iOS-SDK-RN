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
        
        switch rowItem.getStatus() {
        case .success:
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let greenTickImage = UIImage(named: "greenTick", in: .module, compatibleWith: nil)
            tickImageView.image = greenTickImage
            
            titleLabel.textColor = .green
            actionButton.isHidden = true
            
        case .failure:
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let redCrossImage = UIImage(named: "redCross", in: .module, compatibleWith: nil)
            tickImageView.image = redCrossImage
            
            titleLabel.textColor = .red
            actionButton.isHidden = true
            
        case .pending:
            tickImageView.isHidden = true
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            
            titleLabel.textColor = .blue
            actionButton.isHidden = true
            
        case .retry:
            self.isRetry = true
            
            tickImageView.isHidden = false
            indicatorView.isHidden = true
            indicatorView.stopAnimating()
            let redCrossImage = UIImage(named: "redCross", in: .module, compatibleWith: nil)
            tickImageView.image = redCrossImage
            
            titleLabel.textColor = .red
            
            actionButton.setTitle("Retry", for: .normal)
            actionButton.setTitle("Retry", for: .selected)
            actionButton.titleLabel?.font = .systemFont(ofSize: 8, weight: .medium)
            actionButton.isHidden = false
        }
        
        // Setting up the button
        switch rowItem {
        case .entryPointSetup:
            actionButton.setTitle("Check Doc", for: .normal)
            actionButton.setTitle("Check Doc", for: .selected)
            actionButton.titleLabel?.font = .systemFont(ofSize: 8, weight: .medium)
            actionButton.isHidden = false
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

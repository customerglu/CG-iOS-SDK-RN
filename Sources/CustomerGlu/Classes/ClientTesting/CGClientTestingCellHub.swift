//
//  CGClientTestingCellHub.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit

// MARK: - CGClientTestingCellHubFactory
class CGClientTestingCellHubFactory <T: UIView> {
    class func grabFromHub() -> T {
        if let cellArray = Bundle.main.loadNibNamed("CGClientTestingCellHub", owner: CGClientTestingCellHub(), options: nil) {
            for loadedView in cellArray {
                if let loadedView = loadedView as? T {
                    return loadedView
                }
            }
        }
        
        return T()
    }
}

// MARK: - CGClientTestingCellHub
class CGClientTestingCellHub: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - CGClientTestingSDKSetupEventsCell
class CGClientTestingSDKSetupEventsCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private func setupTheme() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .blue
    }
    
    func setupCell(forRowItem rowItem: CGClientTestingRowItem) {
        // Setup Theme
        setupTheme()
        
        titleLabel.text = rowItem.rawValue
    }
}

// MARK: - CGClientTestingButtonCell
class CGClientTestingButtonCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    private func setupTheme() {
        actionButton.backgroundColor = .orange
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setTitleColor(.white, for: .selected)
        actionButton.titleLabel?.font = .systemFont(ofSize: 14)
    }
    
    func setupCell(forRowItem rowItem: CGClientTestingRowItem) {
        // Setup Theme
        setupTheme()
        
        actionButton.setTitle(rowItem.rawValue, for: .normal)
        actionButton.setTitle(rowItem.rawValue, for: .selected)
    }
}

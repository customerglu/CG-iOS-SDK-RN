//
//  CGClientTestingButtonCell.swift
//  
//
//  Created by Ankit Jain on 23/02/23.
//

import UIKit

// MARK: - CGClientTestingButtonCell
public class CGClientTestingButtonCell: UITableViewCell {
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
        
        actionButton.setTitle(rowItem.getTitle(), for: .normal)
        actionButton.setTitle(rowItem.getTitle(), for: .selected)
    }
}

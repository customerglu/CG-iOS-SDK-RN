//
//  CGClientTestingViewController.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit

// MARK: - CGClientTestingViewController
class CGClientTestingViewController: UIViewController {

    // Variables
    var presenter: CGClientTestingPresenter = CGClientTestingPresenter()
    
    // UI Elements
    private var tableView: UITableView?
    
    // View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CGClientTestingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCells(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return getCGClientTestingSDKSetupEventsCell(with: tableView, indexPath: indexPath)
        } else {
            return getCGClientTestingButtonCell(with: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        
    }
    
    func getCGClientTestingSDKSetupEventsCell(with tableView: UITableView, indexPath: IndexPath) -> CGClientTestingSDKSetupEventsCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingSDKSetupEventsCell.reuseIdentifier) as? CGClientTestingSDKSetupEventsCell
        if nullableCell == nil {
            nullableCell = CGClientTestingCellHubFactory<CGClientTestingSDKSetupEventsCell>.grabFromHub()
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return CGClientTestingSDKSetupEventsCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        // Setup Cell
        let rowItem = presenter.getRowItemForEventsSection(withIndexPath: indexPath)
        cell.setupCell(forRowItem: rowItem)
        
        return cell
    }
    
    func getCGClientTestingButtonCell(with tableView: UITableView, indexPath: IndexPath) -> CGClientTestingButtonCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingButtonCell.reuseIdentifier) as? CGClientTestingButtonCell
        if nullableCell == nil {
            nullableCell = CGClientTestingCellHubFactory<CGClientTestingButtonCell>.grabFromHub()
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return CGClientTestingButtonCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        // Setup Cell
        let rowItem = presenter.getRowItemForActionsSection(withIndexPath: indexPath)
        cell.setupCell(forRowItem: rowItem)
        
        return cell
    }
}

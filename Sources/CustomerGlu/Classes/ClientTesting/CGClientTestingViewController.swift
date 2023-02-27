//
//  CGClientTestingViewController.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit

// MARK: - CGClientTestingViewController
public class CGClientTestingViewController: UIViewController {

    // Variables
    var viewModel: CGClientTestingViewModel = CGClientTestingViewModel()
    public static let storyboardVC = StoryboardType.main.instantiate(vcType: LoadAllCampaignsViewController.self)

    // UI Elements
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topSafeArea: UIView!
    @IBOutlet weak var bottomSafeArea: UIView!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!

    // View Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.configureSafeAreaForDevices()
    }
    
    public func configureSafeAreaForDevices() {
        let window = UIApplication.shared.keyWindow
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        
        if topPadding <= 20 || bottomPadding < 20 {
            CustomerGlu.topSafeAreaHeight = 20
            CustomerGlu.bottomSafeAreaHeight = 0
            CustomerGlu.topSafeAreaColor = UIColor.clear
        }
        
        topHeight.constant = CGFloat(CustomerGlu.topSafeAreaHeight)
        bottomHeight.constant = CGFloat(CustomerGlu.bottomSafeAreaHeight)
        
        if CustomerGlu.getInstance.isDarkModeEnabled(){
            topSafeArea.backgroundColor = CustomerGlu.topSafeAreaColorDark
            bottomSafeArea.backgroundColor = CustomerGlu.bottomSafeAreaColorDark
        } else {
            topSafeArea.backgroundColor = CustomerGlu.topSafeAreaColorLight
            bottomSafeArea.backgroundColor = CustomerGlu.bottomSafeAreaColorLight
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.closePage(animated: true)
    }
    
    private func closePage(animated: Bool){
        self.dismiss(animated: animated) {
            CustomerGlu.getInstance.showFloatingButtons()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CGClientTestingViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return getCGClientTestingSDKSetupEventsCell(with: tableView, indexPath: indexPath)
        } else {
            return getCGClientTestingButtonCell(with: tableView, indexPath: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        
    }
    
    public func getCGClientTestingSDKSetupEventsCell(with tableView: UITableView, indexPath: IndexPath) -> CGClientTestingSDKSetupEventsCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingSDKSetupEventsCell.reuseIdentifier) as? CGClientTestingSDKSetupEventsCell
        
        if nullableCell == nil {
            tableView.register(UINib(nibName: CGClientTestingSDKSetupEventsCell.nibName, bundle: .module), forCellReuseIdentifier: CGClientTestingSDKSetupEventsCell.reuseIdentifier)
            
            nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingSDKSetupEventsCell.reuseIdentifier, for: indexPath)  as? CGClientTestingSDKSetupEventsCell
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return CGClientTestingSDKSetupEventsCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        // Setup Cell
        let rowItem = viewModel.getRowItemForEventsSection(withIndexPath: indexPath)
        cell.setupCell(forRowItem: rowItem)
        
        return cell
    }
    
    public func getCGClientTestingButtonCell(with tableView: UITableView, indexPath: IndexPath) -> CGClientTestingButtonCell {
        var nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingButtonCell.reuseIdentifier) as? CGClientTestingButtonCell
        
        if nullableCell == nil {
            tableView.register(UINib(nibName: CGClientTestingButtonCell.nibName, bundle: .module), forCellReuseIdentifier: CGClientTestingButtonCell.reuseIdentifier)
            
            nullableCell = tableView.dequeueReusableCell(withIdentifier: CGClientTestingButtonCell.reuseIdentifier, for: indexPath)  as? CGClientTestingButtonCell
        }
        
        guard let cell = nullableCell else {
            assert(true)
            return CGClientTestingButtonCell()
        }
        
        // Selection type
        cell.selectionStyle = .none
        cell.accessoryType = .none
        
        // Setup Cell
        let rowItem = viewModel.getRowItemForActionsSection(withIndexPath: indexPath)
        cell.setupCell(forRowItem: rowItem)
        
        return cell
    }
}

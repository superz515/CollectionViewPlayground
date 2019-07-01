//
//  MasterViewController.swift
//  CollectionViewPlayground
//
//  Created by Zhang, Yiliang on 2/28/19.
//  Copyright © 2019 Zhang, Yiliang. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil

    // MARK: - layouts model
    private lazy var layoutsModel = LayoutsModel()

    // MARK: - override methods and private methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        title = "Layouts"

        // find detail view controller
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        // set detail view controller as delegate of model to receive events
        detailViewController?.layoutsModel = layoutsModel
        layoutsModel.delegate = detailViewController

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }

    private func setupTableView() {
        // remove extra separators
        let footer = UIView()
        tableView.tableFooterView = footer

        // disable self sizing
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
}

// MARK: - table view data source and delegate
extension MasterViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutsModel.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let layout = layoutsModel.style(at: indexPath.row)
        cell.textLabel?.text = layout.description()

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        layoutsModel.didSelect(indexPath.row)
    }
}

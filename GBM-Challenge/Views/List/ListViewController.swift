//
//  ListViewController.swift
//  GBM-Challenge
//
//  Created by Joaquín González Cervantes on 08/05/22.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func ListViewControllerBackButtonDidTapped()
}

class ListViewController: UIViewController {
    let viewModel = ListViewControllerViewModel()
    
    weak var delegate: ListViewControllerDelegate?
            
    let tableView = UITableView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
        
    override func viewDidLoad() {
        loadingIndicator.startAnimating()
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshList), userInfo: nil, repeats: true)
    
        viewModel.loadData()
        viewModel.refreshData = { () in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.loadingIndicator.stopAnimating()
                self?.tableView.alpha = 1
            }
        }
        tableViewSetup()
    }
    
    @objc private func refreshList() {
        tableView.alpha = 0.1
        loadingIndicator.startAnimating()
        viewModel.loadData()
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loadingIndicator.center = view.center
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
    }

}

extension ListViewController {
    @objc func backButtonTapped() {
        delegate?.ListViewControllerBackButtonDidTapped()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ipcArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.update(with: viewModel.ipcArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

//
//  MainViewController.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit
import SnapKit
import KRProgressHUD

class MainViewController: UIViewController {
    
    private let searchController = SearchVC()
    private let viewModel = MainViewModel()
    private var model: Repositorie = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RepoTableCell.self, forCellReuseIdentifier: "repoCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Public Repo"
        view.backgroundColor = .white
        view.addSubview(tableView)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.placeholder = "ex: repoName `+` Swift"
        navigationItem.setHidesBackButton(true, animated: true)
        
        viewModel.getAllRepo()
        
        binds()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
    }
    
    private func binds() {
        viewModel.isLoading.bind { [weak self] isLoadingFromServer in
            DispatchQueue.main.async {
                if isLoadingFromServer {
                    KRProgressHUD.show()
                } else {
                    KRProgressHUD.dismiss()
                }
            }
        }
        
        viewModel.errorStuck.errors.bind { [weak self] errors in
            guard !errors.isEmpty else {
                return
            }
            
            self?.showAlert(with: errors.first!)
        }
        
        viewModel.model.bind { [weak self] model in
            DispatchQueue.main.async {
                self?.model = model
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoTableCell
        cell.configuration(by: self.model[indexPath.row])
        
        if indexPath.row == model.count - 1 {
            viewModel.getAllRepo(lastID: model.last?.id ?? 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if
            let urlStr = model[indexPath.row].htmlURL,
            let url = URL(string: urlStr) {
            UIApplication.shared.open(url)
        } else {
            self.showAlert(with: RestError.custom(message: "Sorry some problem with Repo!"))
        }
    }
}

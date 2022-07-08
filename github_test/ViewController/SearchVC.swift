//
//  WhatViewController.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit
import KRProgressHUD
import SnapKit

class SearchVC: UISearchController {
    
    private let viewModel = SearchViewModel()
    private var model: RepoItems = []
    
    var searchQueryWork: DispatchWorkItem?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        tableView.register(RepoTableCell.self, forCellReuseIdentifier: "searchCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(tableView)
        self.searchBar.delegate = self
        self.searchBar.placeholder = "ex: repoName `+` Swift"
        
        self.binds()
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
        
        viewModel.model.bind { [weak self] model in
            DispatchQueue.main.async {
                self?.model = model
                self?.tableView.reloadData()
            }
        }
        
        viewModel.errors.messages.bind { [weak self] errorMes in
            guard
                let self = self,
                !errorMes.isEmpty
            else {
                return
            }
            
            self.showAlert(with: RestError.custom(message: errorMes.first!))
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.resetValues()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.viewModel.resetValues()
        self.viewModel.getResult(text: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.resetValues()
    }
    
    
}

//MARK: - UITableViewDelegate && UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! RepoTableCell
        
        cell.configurationSearch(by: model[indexPath.row])
        
        if indexPath.row == model.count - 1 {
            viewModel.getResult(text: self.searchBar.text ?? "")
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

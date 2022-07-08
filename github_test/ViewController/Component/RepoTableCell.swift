//
//  RepoTableCell.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit
import SnapKit

class RepoTableCell: TableViewCell {

    private let containerView = UIView()
    private let provider = APIProvider.shared
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .red
        return image
    }()
    
    private let repoName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.text = "Repo Full Name Repo Full Name Repo Full Name Repo Full Name Repo Full Name "
        
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "#C, #swift"
        label.numberOfLines = 1
        return label
    }()
    
    override func makeHierarchy() {
        super.makeHierarchy()
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImage)
        containerView.addSubview(repoName)
        containerView.addSubview(languageLabel)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        avatarImage.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.margins.equalTo(20)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        repoName.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(20)
            make.left.equalTo(avatarImage.snp.right).inset(-15)
        }
        
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .green.withAlphaComponent(0.2)
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 8
    }

    func configuration(by model: RepositorieElement) {
        if
            let urlstr = model.owner?.avatarURL,
            let url = URL(string: urlstr) {
            
            avatarImage.loadThumbnail(urlSting: urlstr)
        } else {
            avatarImage.image = UIImage(systemName: "person")
        }
        
        self.repoName.text = model.repositorieDescription ?? "Here About Repo"
        self.languageLabel.text = model.fullName ?? ""
    }
    
    func configurationSearch(by model: Item) {
        if
            let urlstr = model.owner?.avatarURL,
            let url = URL(string: urlstr) {
            
            avatarImage.loadThumbnail(urlSting: urlstr)
        } else {
            avatarImage.image = UIImage(systemName: "person")
        }
        
        self.repoName.text = model.fullName ?? ""
        self.languageLabel.text = model.language ?? "null"
    }
    
    private func getLanText(urlstr: String?) {
        guard let urlstr = urlstr else {
            self.languageLabel.text = "No Language"
            return
        }

        provider.getLanguage(byUrlStr: urlstr) { result in
            switch result {
            case .success(let model):
                guard !model.isEmpty else {
                    DispatchQueue.main.async {
                        self.languageLabel.text = "No Language"
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.languageLabel.text = model.first?.first?.key
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.languageLabel.text = "No Language"
                }
            }
        }
    }
}


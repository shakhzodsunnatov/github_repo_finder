//
//  Design.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        makeHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeConstraints()
    }
    
    func makeHierarchy() {}
    
    func makeConstraints() {}
    
}

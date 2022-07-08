//
//  SearchViewModel.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

class SearchViewModel {
    
    var model: Box<RepoItems> = Box([])
    var errors = Stacks()
    var isLoading = Box(false)
    private var provider = APIProvider.shared
    private var pageIndex = 1
    
    func getResult(text: String) {
        self.isLoading.value = true
        provider.searchRepo(by: text, pageIndex: pageIndex) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                print("HEY \(self.pageIndex)")
                self.isLoading.value = false
                if
                    self.pageIndex != 1,
                    !model.isEmpty
                {
                    self.model.value += model
                    self.pageIndex += 1
                } else if !model.isEmpty {
                    self.model.value = model
                    self.pageIndex = 2
                }
            case .failure(let error):
                self.isLoading.value = false
                self.errors.messages.value.append(error.localizedDescription)
            }
        }
    }
    
    func resetValues() {
        self.model.value = []
        self.pageIndex = 1
    }
}

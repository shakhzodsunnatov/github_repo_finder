//
//  MainViewModel.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

class MainViewModel {
    
    var isLoading = Box(true)
    var errorStuck = Stacks()
    
    var model: Box<Repositorie> = Box([])
    
    private let provider = APIProvider.shared
    
    func getAllRepo(lastID: Int = 0) {
        provider.getAllRepo(lastID: lastID) { result in
            switch result {
            case .success(let model):
                self.isLoading.value = false
                if
                    lastID != 0 &&
                    !model.isEmpty
                {
                    self.model.value += model
                } else {
                    self.model.value = model
                }
            case .failure(let error):
                self.isLoading.value = false
                self.errorStuck.errors.value.append(error)
            }
        }
    }

}

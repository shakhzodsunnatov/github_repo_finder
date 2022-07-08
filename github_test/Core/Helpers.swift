//
//  Helpers.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit

extension UIViewController {
    func showAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

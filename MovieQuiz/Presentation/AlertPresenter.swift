//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 13.02.2024.
//

import Foundation
import UIKit


// Логика реализации алертов
final class AlertPresenter: AlertDelegate {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }

        alert.addAction(action)

        viewController?.present(alert, animated: true, completion: nil)
    }
}

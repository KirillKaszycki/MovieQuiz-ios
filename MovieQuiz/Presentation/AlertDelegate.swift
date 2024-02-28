//
//  AlertDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 13.02.2024.
//

import Foundation
import UIKit


// Делегат для алертов
protocol AlertDelegate: AnyObject {
    func presentAlert(with model: AlertModel)
}

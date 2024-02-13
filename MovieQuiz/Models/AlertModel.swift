//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 13.02.2024.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

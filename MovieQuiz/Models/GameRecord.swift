//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 19.02.2024.
//

import UIKit

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

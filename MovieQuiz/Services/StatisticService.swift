//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 19.02.2024.
//

import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}


final class StatisticServiceImplementation: StatisticService {
    
    // MARK: - StaticService переменные
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
        
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            saveBestGame(newValue)
        }
    }
    
    // MARK: - StaticService метод
    func store(correct count: Int, total amount: Int) {
        updateBestGame(correctCount: count, totalCount: amount)
        updateGamesCountAndTotals(correctCount: count, totalCount: amount)
        updateTotalAccuracy()
    }
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case totalAccuracy, gamesCount, bestGame, correct, total
    }

    // MARK: - Методы класса
    // Обновить рекорд
    private func updateBestGame(correctCount: Int, totalCount: Int) {
        var currentBestGame = bestGame
        
        let newRecord = GameRecord(correct: correctCount,
                                   total: totalCount,
                                   date: Date())
        if newRecord.correct > currentBestGame.correct {
            currentBestGame = newRecord
            saveBestGame(currentBestGame)
        }
    }
    
    // Сохранить рекорд
    private func saveBestGame(_ gameRecord: GameRecord) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(gameRecord)
            userDefaults.set(encoded, forKey: Keys.bestGame.rawValue)
        } catch {
            print("Невозможно сохранить результат: \(error)")

        }
    }
    
    private func updateGamesCountAndTotals(correctCount: Int, totalCount: Int) {
        var totalGames = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        totalGames += 1
        userDefaults.set(totalGames, forKey: Keys.gamesCount.rawValue)
        
        var corrects = userDefaults.integer(forKey: Keys.correct.rawValue)
        corrects += correctCount
        userDefaults.set(corrects, forKey: Keys.correct.rawValue)
        
        var total = userDefaults.integer(forKey: Keys.total.rawValue)
        total += totalCount
        userDefaults.set(total, forKey: Keys.total.rawValue)
    }
    
    private func updateTotalAccuracy() {
        let corrects = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        totalAccuracy = Double(corrects) / Double(total) * 100
    }
}

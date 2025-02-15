//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 11.02.2024.
//

import Foundation


final class QuestionFactory: QuestionFactoryProtocol {
    
    
    
    private let moviesLoader: MoviesLoading
    var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomRating = Float.random(in: 5...9).rounded()
            
            // Логика смены вариации вопросов: Больше/меньше
            let more: String = "больше"
            let less: String = "меньше"
            let comparison = [more, less].randomElement()
            
            let text: String
            let correctAnswer: Bool
            
            if let comparisonType = comparison {
                if comparisonType == more {
                    text = "Рейтинг этого фильма \(comparisonType) чем \(randomRating)?"
                    correctAnswer = rating > randomRating
                } else {
                    text = "Рейтинг этого фильма \(comparisonType) чем \(randomRating)?"
                    correctAnswer = rating < randomRating
                }
            } else {
                text = "Рейтинг этого фильма равен \(randomRating)?"
                correctAnswer = rating == randomRating
            }
            //
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}







//private let questions: [QuizQuestion] = [
//    QuizQuestion(
//        image: "The Godfather",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Dark Knight",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Kill Bill",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Avengers",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Deadpool",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "The Green Knight",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: true),
//    QuizQuestion(
//        image: "Old",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//    QuizQuestion(
//        image: "The Ice Age Adventures of Buck Wild",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//    QuizQuestion(
//        image: "Tesla",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false),
//    QuizQuestion(
//        image: "Vivarium",
//        text: "Рейтинг этого фильма больше чем 6?",
//        correctAnswer: false)
//]

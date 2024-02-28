//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 12.02.2024.
//

import UIKit


protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}

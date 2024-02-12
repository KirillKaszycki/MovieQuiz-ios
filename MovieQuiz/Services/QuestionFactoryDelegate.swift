//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Кирилл Кашицкий on 12.02.2024.
//

import UIKit


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion (question: QuizQuestion?)
}

import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertDelegate {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter!
    private var statisticService: StatisticService?
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        
        alertPresenter = AlertPresenter(viewController: self)
        
        statisticService = StatisticServiceImplementation()
        
        // let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // print(documentsURL)
    }
    
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {
            [weak self] in self?.show(quiz: viewModel)
        }
    }
    
    
    // MARK: - AlertDelegate
    func presentAlert(with model: AlertModel) {
        alertPresenter.presentAlert(with: model)
    }
    
    // MARK: - Private functions
    // Метод логики кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // Метод логики кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // Метод конвертации
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    // Метод показа картинки и вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Метод отображения рамки
    private func showAnswerResult (isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    // Метод логики смены вопросов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let statisticService = statisticService else {
                // Handle missing statistic service
                return
            }
            let totalGames = statisticService.gamesCount
            let record = statisticService.bestGame
            let accuracy = statisticService.totalAccuracy
            
            let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(totalGames)
            Рекорд: \(record.correct)/\(record.total) (\(record.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", accuracy))%
            """
            
            let alertModel = AlertModel(title: "Игра закончена!", message: message, buttonText: "Сыграть еще раз") { [weak self] in
                self?.restartQuiz()
            }
            
            alertPresenter?.presentAlert(with: alertModel)
        } else {
            currentQuestionIndex += 1
            resetImageBorder()
            self.questionFactory.requestNextQuestion()
        }
    }
    
    // Метод для перезапуска игры
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
        resetImageBorder()
    }

    
    // Мметод отображения результатов
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) {
            [ weak self ] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        }
        
        presentAlert(with: alertModel)
    }
    
    // Метод сброса рамки при смене вопроса
    private func resetImageBorder (){
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */

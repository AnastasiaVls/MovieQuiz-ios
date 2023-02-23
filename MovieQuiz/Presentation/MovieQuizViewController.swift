import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let currentQuestion = questions[currentQuestionIndex]
        let currentQuestionView = convert(currentQuestion, currentQuestionIndex)
        show(quiz:currentQuestionView)
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }
   
    private func convert(_ model: QuizQuestion,_ questionIndex: Int ) -> QuizStepViewModel{
        // Попробуйте написать код конвертации сами
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(questionIndex + 1)"
        ) // высчитываем номер вопроса
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text =  "\(step.questionNumber)/\(questions.count)"
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
                correctAnswers += 1 // my: увеличиваем счетчик правильных ответов, если ответ верный
            }
        // попробуйте написать код, который будет показывать красную или зелёную рамку
        // исходя из правильности ответа, то есть переменной `isCorrect`.
           imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
           // показать результат квиза
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
            show(viewModel)
            
         } else {
           currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
           // показать следующий вопрос
             let nextQuestion = questions[currentQuestionIndex]
             let nextQuestionView = convert(nextQuestion, currentQuestionIndex)
             show(quiz: nextQuestionView)
         }
        
    }
    
    private func show(_ result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
       
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert (center) или .actionSheet (bottom)
       

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in // уточнить ошибку без "_in"
          print("OK button is clicked!")
            // вот этот код с переключением индекса и показом первого вопроса надо будет написать тут
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0 // my:обнуляем счетчик правильных ответов
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(firstQuestion, self.currentQuestionIndex)
            self.show(quiz: viewModel)
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let currentQuestion = questions[currentQuestionIndex]
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    // для состояния "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
        
        init(
            image: String,
            text: String,
            correctAnswer: Bool
        ) {
            self.image = image;
            self.text = text;
            self.correctAnswer = correctAnswer
        }
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion ( image: "The Godfather",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "The Dark Knight",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "Kill Bill",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "The Avengers",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "Deadpool",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "The Green Knight",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: true),
        QuizQuestion ( image: "Old",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: false),
        QuizQuestion ( image: "The Ice Age Adventures of Buck Wild",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: false),
        QuizQuestion ( image: "Tesla",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: false),
        QuizQuestion ( image: "Vivarium",
                       text: "Рейтинг этого фильма больше чем 6?",
                       correctAnswer: false)
    ]
    
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

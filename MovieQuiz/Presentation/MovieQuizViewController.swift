import UIKit

private let questionIsRatingGreaterThan6:String = "Рейтинг этого фильма больше чем 6?"

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentQuestion = questions[currentQuestionIndex]
        let currentQuestionView = convert(currentQuestion, currentQuestionIndex)
        show(quiz:currentQuestionView)
        
        imageView.layer.masksToBounds = true // разрешение на рисование рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
    }
   
    private func convert(_ model: QuizQuestion,_ questionIndex: Int ) -> QuizStepViewModel{
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковка картинки
            question: model.text, //текст вопроса
            questionNumber: "\(questionIndex + 1)" // высчитывается номер вопроса
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь заполняется картинка, текст и счётчик данными
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text =  "\(step.questionNumber)/\(questions.count)"
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1 // my: увеличивается счетчик правильных ответов, если ответ верный
        }
        // код, который показывает красную или зелёную рамку, исходя из правильности ответа, то есть переменной `isCorrect`.
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // зеленая или красная рамка

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // задача запускается через 1 секунду
            self.showNextQuestionOrResults() // код, который будет запущен через 1 секунду
        }
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        
        if currentQuestionIndex == questions.count - 1 {
           // показать результат квиза
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(viewModel)
         } else {
            currentQuestionIndex += 1 // увеличивается индекс текущего вопроса на 1, чтобы получить следующий вопрос
           // показать следующий вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let nextQuestionView = convert(nextQuestion, currentQuestionIndex)
            show(quiz: nextQuestionView)
         }
    }
    
    private func show(_ result: QuizResultsViewModel) {
        // результат прохождения квиза, создаются объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплывающем окне
            preferredStyle: .alert // preferredStyle может быть .alert (center) или .actionSheet (bottom)
        )

        // создаются кнопки с действиями
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
        print("OK button is clicked!")
        // код с переключением индекса и показом первого вопроса
        self.currentQuestionIndex = 0 // my:обнуляется индекс вопроса
        self.correctAnswers = 0 // my:обнуляется счетчик правильных ответов
        // заново показывается первый вопрос
        let firstQuestion = self.questions[self.currentQuestionIndex]
        let viewModel = self.convert(firstQuestion, self.currentQuestionIndex)
        self.show(quiz: viewModel)
        }

        // добавляется кнопка в алерт
        alert.addAction(action)

        // показывается всплывающее окно
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
    // структура вопроса
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
        QuizQuestion (image: "The Godfather", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "The Dark Knight", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "Kill Bill", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "The Avengers", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "Deadpool", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "The Green Knight", text: questionIsRatingGreaterThan6, correctAnswer: true),
        QuizQuestion (image: "Old", text: questionIsRatingGreaterThan6, correctAnswer: false),
        QuizQuestion (image: "The Ice Age Adventures of Buck Wild", text: questionIsRatingGreaterThan6, correctAnswer: false),
        QuizQuestion (image: "Tesla", text: questionIsRatingGreaterThan6, correctAnswer: false),
        QuizQuestion (image: "Vivarium", text: questionIsRatingGreaterThan6, correctAnswer: false)
    ]
}


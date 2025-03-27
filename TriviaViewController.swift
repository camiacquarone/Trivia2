//
//  TriviaViewController.swift
//  Trivia
//
//  Created by Camila Acquarone on 3/7/25.
//

import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var questionTrackerLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var choice1Label: UIButton!
    @IBOutlet weak var choice2Label: UIButton!
    @IBOutlet weak var choice3Label: UIButton!
    @IBOutlet weak var choice4Label: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    lazy var triviaElements: [UIView] = {
        return [questionTrackerLabel, themeLabel, questionLabel,
                choice1Label, choice2Label, choice3Label, choice4Label]
    }()
    
    var questions: [TriviaQuestion] = []
    var currentQuestionIndex = 0
    var score: Int = 0
    let service = TriviaQuestions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        triviaElements.forEach { $0.isHidden = true }
        loadQuestions()
    }

    private func loadQuestions() {
        service.fetchQuestions { [weak self] fetchedQuestions in
            DispatchQueue.main.async {
                guard let self = self, let fetchedQuestions = fetchedQuestions else { return }
                self.questions = fetchedQuestions
                self.currentQuestionIndex = 0
                self.score = 0
                self.displayCurrentQuestion()
                self.triviaElements.forEach { $0.isHidden = false }
            }
        }
    }

    private func displayCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            showGameOver()
            return
        }

        let current = questions[currentQuestionIndex]
        questionTrackerLabel.text = "Question \(currentQuestionIndex + 1)/\(questions.count)"
        themeLabel.text = current.category
        questionLabel.text = current.question
        
        let options = current.options
        choice1Label.setTitle(options[0], for: .normal)
        choice2Label.setTitle(options[1], for: .normal)
        
        if options.count > 2 {
            choice3Label.isHidden = false
            choice4Label.isHidden = false
            choice3Label.setTitle(options[2], for: .normal)
            choice4Label.setTitle(options[3], for: .normal)
        } else {
            choice3Label.isHidden = true
            choice4Label.isHidden = true
        }
    }

    private func setupButtonActions() {
        choice1Label.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        choice2Label.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        choice3Label.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        choice4Label.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
    }

    @objc private func answerButtonTapped(_ sender: UIButton) {
        let selectedAnswer = sender.titleLabel?.text ?? ""
        if selectedAnswer == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }

        currentQuestionIndex += 1
        displayCurrentQuestion()
    }

    private func showGameOver() {
        let alert = UIAlertController(
            title: "Game Over",
            message: "Your score: \(score)/\(questions.count)",
            preferredStyle: .alert
        )

        let restartAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.restartGame()
        }

        alert.addAction(restartAction)
        present(alert, animated: true)
    }

    private func restartGame() {
        loadQuestions()
    }
}

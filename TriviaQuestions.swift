//
//  TriviaQuestions.swift
//  Trivia
//
//  Created by Camila Acquarone on 3/26/25.
//

import Foundation

struct TriviaQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
    let category: String
}

class TriviaQuestions {
    func fetchQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]] else {
                completion(nil)
                return
            }

            let questions: [TriviaQuestion] = results.compactMap { dict -> TriviaQuestion? in
                guard let question = dict["question"] as? String,
                      let correct = dict["correct_answer"] as? String,
                      let incorrect = dict["incorrect_answers"] as? [String],
                      let category = dict["category"] as? String else {
                    return nil
                }

                var allAnswers = incorrect + [correct]
                allAnswers.shuffle()

                return TriviaQuestion(
                    question: self.htmlUnescape(question),
                    options: allAnswers.map { self.htmlUnescape($0) },
                    correctAnswer: self.htmlUnescape(correct),
                    category: self.htmlUnescape(category)
                )
            }

            completion(questions)
        }

        task.resume()
    }

    private func htmlUnescape(_ text: String) -> String {
        let data = Data(text.utf8)
        return (try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ).string) ?? text
    }
}

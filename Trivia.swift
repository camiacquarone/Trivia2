//
//  Trivia.swift
//  Trivia
//
//  Created by Camila Acquarone on 3/10/25.
//


import Foundation

struct Trivia {
    let questions: String
    let theme: String
    let triviaCode: triviaCode
}

enum triviaCode {
    case question1
    case question2
    case question3

    var description: String {
        switch self {
        case .question1:
            return "Question 1/3"
        case .question2:
            return "Question 2/3"
        case .question3:
            return "Question 3/3"
        }
    }

    var questionText: String {
        switch self {
        case .question1:
            return "What was the first weapon pack for 'PAYDAY'?"
        case .question2:
            return "Which of these founding fathers of the United States of America later became president?"
        case .question3:
            return "What is the last song on the first Panic! At the Disco album?"
        }
    }

    var options: [String] {
        switch self {
        case .question1:
            return ["The Gage Weapon Pack #1", "The Overkill Pack", "The Gage Chivalry Pack", "The Gage Historical Pack"]
        case .question2:
            return ["Roger Sherman", "James Monroe", "Samuel Adams", "Alexander Hamilton"]
        case .question3:
            return ["I Write Sins Not Tragedies", "Lying is The Most Fun A Girl Can Have Without Taking Her Clothes Off", "Nails for Breakfast, Tacks for Snacks", "Build God, Then We'll Talk"]
        }
    }

    var correctAnswer: String {
        switch self {
        case .question1:
            return "The Gage Weapon Pack #1"
        case .question2:
            return "James Monroe"
        case .question3:
            return "Build God, Then We'll Talk"
        }
    }
}

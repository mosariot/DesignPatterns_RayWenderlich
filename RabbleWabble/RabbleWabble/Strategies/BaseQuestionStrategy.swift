//
//  BaseQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Александр Воробьев on 05.07.2021.
//

import Foundation

// strategy
public class BaseQuestionStrategy: QuestionStrategy {
    
    // MARK: - Properties
    
    public var correctCount: Int {
        get { questionGroup.score.correctCount }
        set { questionGroup.score.correctCount = newValue }
    }
    public var incorrectCount: Int  {
        get { questionGroup.score.incorrectCount }
        set { questionGroup.score.incorrectCount = newValue }
    }
    private var questionGroupCareTaker: QuestionGroupCaretaker
    private var questionGroup: QuestionGroup {
        questionGroupCareTaker.selectedQuestionGroup
    }
    private var questionIndex = 0
    private let questions: [Question]
    
    // MARK: - Object Lifecycle
    
    public init(questionGroupCaretaker: QuestionGroupCaretaker, questions: [Question]) {
        self.questionGroupCareTaker = questionGroupCaretaker
        self.questions = questions
        self.questionGroupCareTaker.selectedQuestionGroup.score.reset()
    }
    
    // MARK: - QuestionStrategy
    
    public var title: String {
        questionGroup.title
    }
    
    public func advanceToNextQuestion() -> Bool {
        try? questionGroupCareTaker.save()
        guard questionIndex + 1 < questions.count else { return false }
        questionIndex += 1
        return true
    }
    
    public func currentQuestion() -> Question {
        questions[questionIndex]
    }
    
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    
    public func markQuestionIncorrent(_ question: Question) {
        incorrectCount += 1
    }
    
    public func questionIndexTitle() -> String {
        "\(questionIndex + 1) / " + "\(questions.count)"
    }
}

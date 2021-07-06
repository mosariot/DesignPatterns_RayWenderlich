//
//  QuestionStrategy.swift
//  RabbleWabble
//
//  Created by Александр Воробьев on 30.06.2021.
//

import Foundation

// strategy protocol
public protocol QuestionStrategy: AnyObject {
    
    var title: String { get }
    
    var correctCount: Int { get }
    var incorrectCount: Int { get }
    
    func advanceToNextQuestion() -> Bool
    
    func currentQuestion() -> Question
    
    func markQuestionCorrect(_ question: Question)
    func markQuestionIncorrent(_ question: Question)
    
    func questionIndexTitle() -> String
}

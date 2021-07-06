//
//  SequentialQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Александр Воробьев on 30.06.2021.
//

import Foundation

// strategy
public class SequentialQuestionStrategy: BaseQuestionStrategy {
    
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let questions = questionGroup.questions
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
}

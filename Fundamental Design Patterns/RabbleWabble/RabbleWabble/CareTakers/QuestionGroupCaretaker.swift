//
//  QuestionGroupCaretaker.swift
//  RabbleWabble
//
//  Created by Александр Воробьев on 02.07.2021.
//

import Foundation

// caretaker
public final class QuestionGroupCaretaker {
    
    // MARK: - Properties
    
    private let fileName = "QuestionGroupData"
    public var questionGroups: [QuestionGroup] = []
    public var selectedQuestionGroup: QuestionGroup!
    
    // MARK: - Object Lifecycle
    
    public init() {
        loadQuestionGroups()
    }
    
    private func loadQuestionGroups() {
        if let questionGroups = try? DiskCaretaker.retrieve([QuestionGroup].self, from: fileName) {
            self.questionGroups = questionGroups
        } else {
            let bundle = Bundle.main
            let url = bundle.url(forResource: fileName, withExtension: "json")!
            self.questionGroups = try! DiskCaretaker.retrieve([QuestionGroup].self, from: url)
            try! save()
        }
    }
    
    // MARK: - Instance Methods
    
    public func save() throws {
        try DiskCaretaker.save(questionGroups, to: fileName)
    }
}

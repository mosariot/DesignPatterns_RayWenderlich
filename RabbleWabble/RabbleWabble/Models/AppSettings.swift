//
//  AppSettings.swift
//  RabbleWabble
//
//  Created by Александр Воробьев on 30.06.2021.
//

import Foundation

public class AppSettings {
    
    // MARK: - Keys
    
    private struct Keys {
        static let questionStrategy = "questionStrategy"
    }
    
    // MARK: - Static Properties
    
    public static let shared = AppSettings()
    
    // MARK: - Instance Properties
    
    public var questionStrategyType: QuestionStrategyType {
        get {
            let rawValue = userDefaults.integer(forKey: Keys.questionStrategy)
            return QuestionStrategyType(rawValue: rawValue)!
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.questionStrategy)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Object Lifecycle
    
    private init() {}
    
    // MARK: - Instance Methods
    
    public func questionStrategy(for questionGroup: QuestionGroup) -> QuestionStrategy {
        questionStrategyType.questionStrategy(for: questionGroup)
    }
}

// MARK: - QuestionStrategyType

public enum QuestionStrategyType: Int, CaseIterable {
    
    case random
    case sequential
    
    // MARK: - Instance Methods
    
    public func title() -> String {
        switch self {
        case .random:
            return "Random"
        case .sequential:
            return "Sequential"
        }
    }
    
    public func questionStrategy(for questionGroup: QuestionGroup) -> QuestionStrategy {
        switch self {
        case .random:
            return RandomQuestionStrategy(questionGroup: questionGroup)
        case .sequential:
            return SequentialQuestionStrategy(questionGroup: questionGroup)
        }
    }
}

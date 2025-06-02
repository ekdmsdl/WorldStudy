//
//  QuestionViewModel.swift
//  Login1
//
//  Created by 이다은 on 6/2/25.
//

import Foundation

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var errorMessage: String?

    func loadUserQuestions() {
        Task {
            do {
                let result = try await APIService.shared.fetchUserQuestions()
                await MainActor.run {
                    self.questions = result
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "질문을 불러올 수 없습니다."
                }
            }
        }
    }
}

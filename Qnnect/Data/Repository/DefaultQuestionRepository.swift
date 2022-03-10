//
//  DefaultQuestionRepository.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import RxSwift

final class DefaultQuestionRepository: QuestionRepository {
    
    private let scrapNetworkService: ScrapNetworkService
    
    init(
        scrapNetworkService: ScrapNetworkService
    ) {
        self.scrapNetworkService = scrapNetworkService
    }
    
    func scrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        let request = ScrapRequestDTO(cafeQuestionId: questionId)
        
        return self.scrapNetworkService.scrap(request: request)
    }
    
    func cancleScrap(_ questionId: Int) -> Observable<Result<Void,Error>> {
        let request = ScrapRequestDTO(cafeQuestionId: questionId)
        
        return self.scrapNetworkService.cancleScrap(request: request)
    }
}

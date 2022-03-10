//
//  ScrapNetworkService.swift
//  Qnnect
//
//  Created by 재영신 on 2022/03/10.
//

import Foundation
import Moya
import RxSwift

final class ScrapNetworkService: BaseNetworkService<ScrapAPI> {
    
    func scrap(request: ScrapRequestDTO) -> Observable<Void> {
        return self.request(.scrap(request: request))
            .filter(statusCode: 200)
            .asObservable()
            .mapToVoid()
    }
    
    func cancleScrap(request: ScrapRequestDTO) -> Observable<Void> {
        return self.request(.cancleScrap(request: request))
            .filter(statusCodes: 200...300)
            .asObservable()
            .mapToVoid()
    }
}

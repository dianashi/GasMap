import Moya
import PromiseKit

extension MoyaProvider {
    func request(_ target: Target) -> Promise<Response> {
        return Promise { seal in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

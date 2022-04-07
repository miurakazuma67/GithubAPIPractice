//
//  GithubApiModel.swift
//  GithubAPIPractice
//
//  Created by 三浦　一真 on 2022/02/18.
//

import Foundation
import RxSwift

final class GithubApiModel {
    
    //シングルトンにする
    //テスタブルじゃなくなってしまうから、避けた方がいい
    static let shared = GithubApiModel()
    private init () {}
    
    ///リクエスト
    func request(completion: @escaping(Result<[Issue], Error>)->Void) {
        
        guard let url = URL(string: "https://api.github.com/repos/rails/rails/issues") else { return }
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do{
                let repository: Repository = try JSONDecoder().decode(Repository.self, from: data)
                
                let items = repository.items
                completion(.success(items))
                
            } catch {
                completion(.failure(error))
                //error時の処理
                //UIの処理はメインスレッドで書かなければならないので、Viewで行う
                //画面遷移し、エラーメッセージとリトライボタンをつける
            }
        }
        task.resume()
    }
}

//error時の処理を書く方法

extension GithubApiModel: ReactiveCompatible{}
//Reactive Programmingを行うための拡張
extension Reactive where Base: GithubApiModel {
    func request() -> Observable<[Issue]> {
        return Observable.create { observer in
            GithubApiModel.shared.request() { result in
                switch result {
                case .success(let repository):
                    observer.onNext(repository)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
}



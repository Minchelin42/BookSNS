//
//  ViewModelType.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/13.
//


import Foundation
import RxSwift

protocol ViewModelType {
    
    var disposeBag: DisposeBag { get set }

    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

//
//  BaseViewModel.swift
//  PinkBook
//
//  Created by mac on 2023/4/21.
//

import UIKit
import Combine

class BaseViewModel {
    
    let isLoading = CurrentValueSubject<Bool, Never>(false)
    let isSubmitting = CurrentValueSubject<Bool, Never>(false)
    let onMessage = PassthroughSubject<String, Never>()
    let onError = PassthroughSubject<Error, Never>()
    let onFinished = PassthroughSubject<Void, Never>()
    var subscriptions = Set<AnyCancellable>()
    
}

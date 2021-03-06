//
//  NewPostViewModelTest.swift
//  MyTweetsTests
//
//  Created by Nicolas Manograsso on 02/08/2021.
//

import XCTest
@testable import MyTweets

class NewPostViewModelTest: XCTestCase {
    let postData = PostRequest(text: "", imageUrl: nil, videoUrl: nil, location: nil)
    
    func testSavePostWithError() {
        let sut = NewPostViewModel(repository: PostRepositoryErrorMock())
        var onError = false
        var onSaved = false
        
        sut.savePost(postData) { result in
            switch result {
            case .failure(_):
                onError = true
            case .success(_):
                onSaved = true
            }
        }
        
        XCTAssertFalse(onSaved)
        XCTAssertTrue(onError)
    }
    
    func testSavePostSuccesfull() {
        let sut = NewPostViewModel(repository: PostRepositorySuccesfulMock())
        var onError = false
        var onSaved = false
        
        sut.savePost(postData) { result in
            switch result {
            case .failure(_):
                onError = true
            case .success(_):
                onSaved = true
            }
        }
       
        XCTAssertTrue(onSaved)
        XCTAssertFalse(onError)
    }
}

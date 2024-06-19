//
//  HomeViewModel.swift
//  ArtBridge
//
//  Created by 김창규 on 4/25/24.
//


import UIKit
import RxSwift

final class HomeViewModel {
    //MARK: - properties
    private var disposeBag = DisposeBag()
    var inputs = Input()
    var outputs = Output()
    var routeInputs = RouteInput()
    var routes = Route()
    
    init(
        homeAPIService: HomeAPIService = HomeAPIService()
    ) {
        homeAPIService.fetchHomeData()
            .subscribe(onNext: { homeData in
                self.outputs.homeData.onNext(homeData)
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
        
        inputs.showAlarm
            .bind(to: routes.alarm)
            .disposed(by: disposeBag)
        
        inputs.showPopularPostList
            .bind(to: routes.popularPostList)
            .disposed(by: disposeBag)
        
        inputs.showDetailPost
            .bind(to: routes.detailPost)
            .disposed(by: disposeBag)
        
        inputs.showDetailTutor
            .bind(to: routes.detailTutor)
            .disposed(by: disposeBag)
        
        inputs.showDetailNews
            .bind(to: routes.detailNews)
            .disposed(by: disposeBag)
        
        inputs.showDetailInstrument
            .bind(to: routes.detailInstrument)
            .disposed(by: disposeBag)
    }
    
    struct RouteInput {
        var needUpdate = PublishSubject<Bool>()
    }
    
    struct Input {
        //Navbar
        var showAlarm = PublishSubject<Void>()
        
        var showDetailInstrument = PublishSubject<Void>()
        var showPopularPostList = PublishSubject<Void>()
        var showDetailPost = PublishSubject<Void>()
        var showDetailTutor = PublishSubject<Void>()
        var showDetailNews = PublishSubject<Void>()
    }
    
    struct Output {
        var homeData = PublishSubject<HomeDataModel>()
    }
    
    struct Route {
        //Navbar
        var alarm = PublishSubject<Void>()
        
        var detailInstrument = PublishSubject<Void>()
        var popularPostList = PublishSubject<Void>()
        var detailPost = PublishSubject<Void>()
        var detailTutor = PublishSubject<Void>()
        var detailNews = PublishSubject<Void>()
    }
}

//
//  HomeCoordinator.swift
//  ArtBridge
//
//  Created by 김창규 on 4/26/24.
//

import UIKit

final class HomeCoordinator: BaseCoordinator<Void> {
    //MARK: - Properties
    var component: HomeComponent
    
    //MARK: - Init
    init(
        component: HomeComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }
    
    override func start(animated _: Bool = true) {
        let scene = component.scene
        
        scene.VM.routes.alarm
            .map { scene.VM }
            .bind { [weak self] vm in
                self?.pushAlarmScene(vm: vm, animated: true)
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailInstrument
            .map { scene.VM }
            .bind { [weak self] vm in
                self?.pushDetailInstrumentScene(vm: vm, animated: true)
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.popularPostList
            .map { (vm: scene.VM, listType: $0) }
            .bind { [weak self] inputs in
                self?.pushPopularPostListScene(vm: inputs.vm, listType: inputs.listType, animated: true)
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailPost
            .map { (vm: scene.VM, postId: $0) }
            .bind { [weak self] inputs in
                self?.pushDetailPostScene(
                    vm: inputs.vm,
                    postID: inputs.postId,
                    animated: true
                )
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailTutor
            .map { (vm: scene.VM, tutorID: $0) }
            .bind { [weak self] inputs in
                self?.pushDetailTutorScene(
                    vm: inputs.vm,
                    tutorID: inputs.tutorID,
                    animated: true)
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailNews
            .map { (vm: scene.VM, newsID: $0) }
            .bind { [weak self] inputs in
                self?.pushDetailNewsScene(
                    vm: inputs.vm,
                    newsID: inputs.newsID,
                    animated: true)
            }.disposed(by: sceneDisposeBag)
    }
    
    private func pushAlarmScene(vm: HomeViewModel, animated: Bool) {
        let comp = component.alarmComponent
        let coord = AlarmCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }
    
    private func pushDetailInstrumentScene(vm: HomeViewModel, animated: Bool) {
        let comp = component.detailInstrumentComponent
        let coord = DetailInstrumentCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }
    
    private func pushPopularPostListScene(
        vm: HomeViewModel,
        listType: HeaderType,
        animated: Bool
    ) {
        let comp = component.popularPostListComponent(listType: listType)
        let coord = ContentListCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }
    
    private func pushDetailPostScene(vm: HomeViewModel, postID: Int, animated: Bool) {
        let comp = component.detailPostComponent(postID: postID)
        let coord = DetailPostCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
            
        }
    }
    
    private func pushDetailTutorScene(vm: HomeViewModel, tutorID: Int, animated: Bool) {
        let comp = component.detailTutorComponent(tutorId: tutorID)
        let coord = DetailTutorCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }
    
    private func pushDetailNewsScene(vm: HomeViewModel, newsID: Int, animated: Bool) {
        let comp = component.detailNewsComponent(newsID: newsID)
        let coord = DetailNewsCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
        }
    }
    
}

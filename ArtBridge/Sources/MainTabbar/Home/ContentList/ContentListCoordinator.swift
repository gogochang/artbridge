//
//  ContentListCoordinator.swift
//  ArtBridge
//
//  Created by 김창규 on 5/10/24.
//

import UIKit
enum PopularPostListResult {
    case backward
}

final class ContentListCoordinator: BaseCoordinator<PopularPostListResult> {
    var component: ContentListComponent
    
    //MARK: - Init
    init(
        component: ContentListComponent,
        navController: UINavigationController
    ) {
        self.component = component
        super.init(navController: navController)
    }
    
    override func start(animated: Bool) {
        let scene = component.scene
        navigationController.pushViewController(scene.VC, animated: animated)
        
        closeSignal
            .debug()
            .bind { [weak self] result in
                switch result {
                case .backward:
                    self?.navigationController.popViewController(animated: true)
                }
                
            }.disposed(by: sceneDisposeBag)
        
        scene.VM.routes.backward
            .debug()
            .map { PopularPostListResult.backward }
            .bind(to: closeSignal)
            .disposed(by: sceneDisposeBag)
        
        scene.VM.routes.detailPost
            .debug()
            .map { scene.VM }
            .bind { [weak self] vm in
                self?.pushDetailPostScene(vm: vm, animated: true)
            }.disposed(by: sceneDisposeBag)
    }
    
    private func pushDetailPostScene(vm: ContentListViewModel, animated: Bool) {
        let comp = component.detailPostComponent(postID: 0)//FIXME: 임시로0처리
        let coord = DetailPostCoordinator(component: comp, navController: navigationController)
        
        coordinate(coordinator: coord, animated: animated) { coordResult in
            switch coordResult {
            case .backward:
                vm.routeInputs.needUpdate.onNext(false)
            }
            
        }
    }
}

//
//  MainTabController.swift
//  ArtBridge
//
//  Created by 김창규 on 4/20/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MainTabController: UIViewController {
    override func viewDidLoad() {
        setupViews()
        initLayout()
        
        viewModelInput()
        viewModelOutput()
    }
    
    init(viewModel: MainTabViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    private var disposeBag = DisposeBag()
    private let viewModel: MainTabViewModel
    
    private func viewModelInput() {
        homeBtn.rx.tap
            .bind(to: viewModel.inputs.homeSelected)
            .disposed(by: disposeBag)
        
        communityBtn.rx.tap
            .bind(to: viewModel.inputs.communitySelected)
            .disposed(by: disposeBag)
        
        messageBtn.rx.tap
            .bind(to: viewModel.inputs.messageSelected)
            .disposed(by: disposeBag)
        
        myPageBtn.rx.tap
            .bind(to: viewModel.inputs.myPageSelected)
            .disposed(by: disposeBag)
    }
    
    private func viewModelOutput() {
        viewModel.outputs.selectScene
            .subscribe(onNext: { [weak self] index in
                self?.tabSelected(at: index)
                self?.showSelectedVC(at: index)
                
            }).disposed(by: disposeBag)
    }
    
    private func showSelectedVC(at index: Int) {
        for (idx, viewController) in viewControllers.enumerated() {
            viewController.view.isHidden = !(idx == index)
        }
        
        if !mainContentView.subviews.contains(where: {$0 == viewControllers[index].view }) {
            mainContentView.addSubview(viewControllers[index].view)
            viewControllers[index].view.snp.makeConstraints { make in
                make.top.equalTo(mainContentView.snp.top)
                make.leading.equalTo(mainContentView.snp.leading)
                make.trailing.equalTo(mainContentView.snp.trailing)
                make.bottom.equalTo(mainContentView.snp.bottom)
            }
        }
    }
    
    private func tabSelected(at index: Int) {
        guard index < 4 else { return }

        homeBtn.isSelected = false
        communityBtn.isSelected = false
        messageBtn.isSelected = false
        myPageBtn.isSelected = false

        switch index {
        case 0:
            homeBtn.isSelected = true
        case 1:
            communityBtn.isSelected = true
        case 2:
            messageBtn.isSelected = true
        case 3:
            myPageBtn.isSelected = true
        default:
            break
        }
    }

    
    var viewControllers: [UIViewController] = []
    
    //MARK: - UI
    private var mainContentView = UIView().then { view in
        view.backgroundColor = .clear
    }
    
    private var bottomView = UIView().then { view in
        view.backgroundColor = .systemGray6
    }
    
    private var homeBtn = UIButton().then { button in
        button.setTitle("홈", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    private var communityBtn = UIButton().then { button in
        button.setTitle("커", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    private var messageBtn = UIButton().then { button in
        button.setTitle("메", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    private var myPageBtn = UIButton().then { button in
        button.setTitle("내", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    private lazy var bottomContentHStack = UIStackView.make(
        with: [homeBtn,communityBtn, messageBtn, myPageBtn],
        axis: .horizontal,
        alignment: .center,
        distribution: .equalCentering,
        spacing: 0
    )
}

//MARK: - Layout
extension MainTabController {
    private func setupViews() {
        view.addSubviews([
            mainContentView,
            bottomView,
        ])
        
        bottomView.addSubviews([bottomContentHStack])
    }
    
    private func initLayout() {
        mainContentView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.left.right.equalTo(view)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(mainContentView.snp.bottom)
            $0.left.right.equalTo(mainContentView)
            $0.bottom.equalTo(view.snp.bottom)
            $0.height.equalTo(100)//FIXME: 임시로 처리
        }
        
        bottomContentHStack.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.top).offset(14)
            make.leading.equalTo(bottomView.snp.leading).offset(36)
            make.trailing.equalTo(bottomView.snp.trailing).offset(-36)
        }
    }
}

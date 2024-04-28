//
//  HomeViewController.swift
//  ArtBridge
//
//  Created by 김창규 on 4/25/24.
//

import UIKit
import RxSwift

fileprivate enum Section: Hashable {
    case banner
    case quickHorizontal(String)
    case PopularPost(String)
}

fileprivate enum Item: Hashable {
    case normal(Int)
    case quickBtn(Int)
    case popularPost(Int) //TODO: 인기글 데이터 Model로 변경
}

class HomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        
        collectionView.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.id
        )
        
        collectionView.register(
            QuickBtnCollectionViewCell.self,
            forCellWithReuseIdentifier: QuickBtnCollectionViewCell.id
        )
        
        collectionView.register(
            PreviewCollectionViewCell.self,
            forCellWithReuseIdentifier: PreviewCollectionViewCell.id
        )
        
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.id
        )
        
        return collectionView
    }()
    
    private var navBar = ArtBridgeNavBar().then {
        $0.leftBtnItem.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        $0.rightBtnItem.setImage(UIImage(systemName: "bell"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initialLayout()
        setDatasource()
        
        createSnapshot()
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
        let items = [Item.normal(1),Item.normal(2),Item.normal(3),Item.normal(4)]
        let bannerSection = Section.banner
        snapshot.appendSections([bannerSection])
        snapshot.appendItems(items, toSection: bannerSection)
        
        let horizontalSection = Section.quickHorizontal("빠른 버튼")
        let quickItems = [Item.quickBtn(1),Item.quickBtn(2),Item.quickBtn(3),Item.quickBtn(4)]
        snapshot.appendSections([horizontalSection])
        snapshot.appendItems(quickItems, toSection: horizontalSection)
        
        let popularPostSection = Section.PopularPost("지금 인기있는 글")
        let popularPostItems = [Item.popularPost(1),Item.popularPost(2),Item.popularPost(3),Item.popularPost(4)]
        snapshot.appendSections([popularPostSection])
        snapshot.appendItems(popularPostItems, toSection: popularPostSection)
        
        dataSource?.apply(snapshot)
    }
}

//MARK: - Layout
extension HomeViewController {
    private func setupViews() {
        view.addSubviews([
            navBar,
            collectionView
        ])
    }
    
    private func initialLayout() {
        view.backgroundColor = .white
        
        navBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
//MARK: - CompositionalLayout
extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .quickHorizontal:
                return self?.createQuickBtnSection()
            case .PopularPost:
                return self?.createPopularHorizontalSection()
            default:
                return self?.createBannerSection()
            }
            
        },configuration: config)
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private func createQuickBtnSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)  // 아이템 간 간격 조정

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createPopularHorizontalSection() -> NSCollectionLayoutSection {
        //Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)  // 아이템 간 간격 조정
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [header]
        return section
    }
}

//MARK: - Datasource
extension HomeViewController {
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                
                switch item {
                case .normal:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerCollectionViewCell.id,
                        for: indexPath
                    ) as? BannerCollectionViewCell
                    return cell
                    
                case .quickBtn:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: QuickBtnCollectionViewCell.id,
                        for: indexPath
                    ) as? QuickBtnCollectionViewCell
                    
                    cell?.configure(
                        icon: UIImage(systemName: "doc.text.magnifyingglass"),
                        title: "버튼이름"
                    )
                    return cell
                case .popularPost(let title):
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PreviewCollectionViewCell.id,
                        for: indexPath
                    ) as? PreviewCollectionViewCell
                    
                    cell?.configure(
                        previewImage: UIImage(),
                        title: "Title",
                        subTitle: "Sub Title"
                    )
                    
                    return cell
                }
            })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderView.id,
                for: indexPath
            )
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .quickHorizontal(let title):
                (header as? HeaderView)?.configure(title: title)
            case .PopularPost(let title):
                (header as? HeaderView)?.configure(title: title)
            default:
                print("Default")
            }
            
            return header
        }
    }
}

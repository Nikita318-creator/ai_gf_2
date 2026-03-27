import UIKit
import SnapKit
import MessageUI

enum GameType: String {
    case checkers = "1"
    case jigsaw = "2"
    case merge2048 = "3"
    case tictactoe = "4"
    case rockPaperScissors = "5"
    case reversi = "6"

    var controller: UIViewController {
        switch self {
        case .checkers:  return CheckersGameVC()
        case .jigsaw:    return JigsawGameVC()
        case .merge2048: return Merge2048GameVC()
        case .tictactoe: return TicTacToeGameVC()
        case .rockPaperScissors: return RockPaperScissorsGameVC()
        case .reversi: return ReversiGameVC()
        }
    }
}

enum GamesSection: Int, CaseIterable {
    case banner
    case games
    case storylines
    
    var title: String? {
        switch self {
        case .games: return "QuickPlays".localize()
        case .storylines: return "VisualNovels".localize()
        default: return nil
        }
    }
    
    static func getSections(isTestB: Bool) -> [GamesSection] {
        return isTestB ? [.banner, .games, .storylines] : [.storylines]
    }
}

class GamesViewController: UIViewController {
    
    private struct TelegramColors {
        static let background = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        static let cardBackground = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
    }

    private var collectionView: UICollectionView!
    
    private let games: [GameModel] = [
        GameModel(id: "1", title: "gameName1".localize(), imageName: "game_checkers"),
        GameModel(id: "2", title: "gameName2".localize(), imageName: "game_jigsaw"),
        GameModel(id: "3", title: "gameName3".localize(), imageName: "game_2048"),
        GameModel(id: "4", title: "gameName4".localize(), imageName: "game_tictactoe"),
        GameModel(id: "5", title: "gameName5".localize(), imageName: "game_rockPaperScissors"),
        GameModel(id: "6", title: "gameName6".localize(), imageName: "game_reversi")
    ]
    
    private let storylines: [StorylineModel] = [
        StorylineModel(id: "s1", title: "StoryTitle1".localize(), imageName: "storyline1_2"),
        StorylineModel(id: "s2", title: "StoryTitle2".localize(), imageName: "storyline2_1"),
        StorylineModel(id: "s3", title: "StoryTitle3".localize(), imageName: "storyline3_1"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }

    private func setupUI() {
        view.backgroundColor = TelegramColors.background
        title = "Games".localize()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.identifier)
        collectionView.register(StorylineCell.self, forCellWithReuseIdentifier: StorylineCell.identifier)
        
        // Supplementary views
        collectionView.register(BannerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BannerHeaderView.identifier)
        collectionView.register(FeedbackFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FeedbackFooterView.identifier)
        collectionView.register(SectionTitleView.self, forSupplementaryViewOfKind: "SectionTitle", withReuseIdentifier: SectionTitleView.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isTestB = ConfigService.shared.isTestB
            let sections = GamesSection.getSections(isTestB: isTestB)
            let currentSection = sections[sectionIndex]
            
            // Настройка размеров групп
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

            let groupHeight: NSCollectionLayoutDimension
            switch currentSection {
            case .banner: groupHeight = .absolute(0.01) // Почти нулевая высота для пустой секции
            case .games: groupHeight = .fractionalWidth(0.5 * 1.5)
            case .storylines: groupHeight = .fractionalWidth(0.6)
            }
                
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            
            // Убираем отступы для пустой баннерной секции
            section.contentInsets = (currentSection == .banner) ? .zero : NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 20, trailing: 8)
            
            var boundaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
            
            // Добавляем Supplementary элементы
            switch currentSection {
            case .banner:
                let bannerWidth = layoutEnvironment.container.contentSize.width - 32
                let bannerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(bannerWidth / 2 + 16))
                let banner = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: bannerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                boundaryItems.append(banner)
                
            case .games, .storylines:
                // Текстовый заголовок
                let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
                let titleHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSize, elementKind: "SectionTitle", alignment: .top)
                boundaryItems.append(titleHeader)
                
                // Если это последняя секция в Тесте Б — добавляем футер
                if isTestB && currentSection == .storylines {
                    let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
                    let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                    boundaryItems.append(footer)
                }
            }
            
            section.boundarySupplementaryItems = boundaryItems
            return section
        }
    }

    @objc private func feedbackTapped() {
        let feedbackAlert = FeedbackAlertView()
        feedbackAlert.onSendTapped = { [weak self] text in
            AnalyticService.shared.logEvent(name: "feedback_sent", properties: ["text":text])
            WebHookAnalyticsService.shared.sendAnalyticsReport(messageText: "Feedback Sent: \(text)")
            let toast = UIAlertController(title: nil, message: "FeedbackReceived".localize(), preferredStyle: .alert)
            self?.present(toast, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { toast.dismiss(animated: true) }
        }
        feedbackAlert.show(in: self.view)
    }

    @objc private func bannerTapped() {
        let dressUpVC = DressUpVC()
        dressUpVC.modalPresentationStyle = .fullScreen
        present(dressUpVC, animated: true)
    }
}

extension GamesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GamesSection.getSections(isTestB: ConfigService.shared.isTestB).count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = GamesSection.getSections(isTestB: ConfigService.shared.isTestB)[section]
        switch type {
        case .banner: return 0
        case .games: return games.count
        case .storylines: return storylines.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = GamesSection.getSections(isTestB: ConfigService.shared.isTestB)[indexPath.section]
        
        if type == .games {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
            cell.configure(with: games[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorylineCell.identifier, for: indexPath) as! StorylineCell
            cell.configure(with: storylines[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let type = GamesSection.getSections(isTestB: ConfigService.shared.isTestB)[indexPath.section]

        switch kind {
        case "SectionTitle":
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionTitleView.identifier, for: indexPath) as! SectionTitleView
            header.label.text = type.title
            return header
            
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BannerHeaderView.identifier, for: indexPath) as! BannerHeaderView
            header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bannerTapped)))
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FeedbackFooterView.identifier, for: indexPath) as! FeedbackFooterView
            footer.configure()
            footer.button.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
            return footer
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if ConfigService.shared.isTestB && indexPath.section == 1 {
             let gameData = games[indexPath.item]
             guard let type = GameType(rawValue: gameData.id) else { return }
             let vc = type.controller
             vc.modalPresentationStyle = .fullScreen
             present(vc, animated: true)
         } else {
             AnalyticService.shared.logEvent(name: "Storyline selected", properties: ["id":"\(indexPath.item)", "title":"\(storylines[indexPath.item].title)"])
             let vc = StorylineVC(storyIndex: indexPath.item, title: storylines[indexPath.item].title)
             vc.modalPresentationStyle = .fullScreen
             present(vc, animated: true)
         }
     }
}

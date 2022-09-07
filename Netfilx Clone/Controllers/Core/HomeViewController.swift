//
//  HomeViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/14.
//

//TODO: 改善重複代碼：getYTMovie重複出現在SearchResultVC、UpcomingVC、SearchVC

import UIKit

//要fetch的API request
enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    private var randomTrendingMovie: Title?//把Heroheader改為隨機選擇熱門影片，設定為optional讓他能是nil
    private var headerView: HeroHeaderUIView? //在viewDidLoad外面也能控制headerView
    
    //將Section的標題內容放在array中
    let sectionTitles: [String] = ["大家都在看的電影","熱門影集","現正熱播","即將上映" ,"最高評分"]
    
//    使用匿名Closure Pattern
    private let homeFeedTable: UITableView = {
        //使用style property將cell加入section
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        
        view.backgroundColor = .black
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()

        //設定tableHeader尺寸
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTable.tableHeaderView = headerView
        
        configureHeroHeaderView()
        
    }
    
    //設定TableView的大小與螢幕相同
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeaderView() {
                
        //新增一個對server的GET request，取得trending movie並隨機化
        APIService.shared.getTrendingMovies { result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self.randomTrendingMovie = selectedTitle//要加[weak self]
                self.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }

//    MARK: 設定NavBar
    private func configureNavbar(){
        var image = UIImage(named: "movieFanLogo")//為了能設定圖片的renderMode，將容器設為變數
        
        image = image?.withRenderingMode(.alwaysOriginal)//強迫iOS使用原本的圖片
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
//                                                           style: .done,
//                                                           target: self,
//                                                           action: nil)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"),
                            style: .done,
                            target: self,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: "airplayvideo"),
                            style: .done,
                            target: self,
                            action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    //設定TableView的行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //設定TableView上面每行cell物件及內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
                
        //依據section的index數判斷是哪個section，
        switch indexPath.section {
            
        case Sections.TrendingMovies.rawValue:
            APIService.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTV.rawValue:
            APIService.shared.getTrendingTVs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APIService.shared.getPopularMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APIService.shared.getUpComingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APIService.shared.getTopRatedMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        default:
            return UITableViewCell()
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //使用willDisplayHeaderView可以預先載入動態資料，讓view的生命週期更完整
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFistLetter()
    }
    
    // NOTE: 雖然viewForHeaderInSection就能完成label的設定工作，但這比較適合沒有牽涉到networking的label內容
    
    //回傳各Section的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //設定navBar滑動效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  defaultOffset = view.safeAreaInsets.top
        
        //navBar往上滑動的值＝畫面捲動的Y值＋原本的offset
        let offset = scrollView.contentOffset.y + defaultOffset
        
        //設定navBar隨著頁面往下捲動，當contenView碰到navBar時，朝上移動
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: ColletionViewTableViewCellDelegate {
    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: VideoDetailViewModel) {
        
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

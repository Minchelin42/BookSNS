import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Hero

class StoryViewController: RxBaseViewController {

    var imageList: [BookModel] = []
    
    var searchType = ""
    var rankTitle = ""
    var nowPage = 0
    var time: Float = 0.0
    var timer: Timer?
    
    let viewModel = StoryViewModel()
    let mainView = StoryView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    }
    
    deinit {
        print("StoryViewController Deinit")
    }
    
    override func bind() {
        let input = StoryViewModel.Input(searchListType: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .subscribe(with: self) { owner, bookList in
                owner.addProgressBars(count: bookList.count)
                owner.imageList = bookList
                
                owner.mainView.rankLabel.text = owner.rankTitle
                owner.mainView.bookLabel.text = owner.imageList[owner.nowPage].title
                owner.mainView.testImage.kf.setImage(with: URL(string: owner.imageList[owner.nowPage].cover)!)
                owner.startProgress()
            }
            .disposed(by: disposeBag)
        
        input.searchListType.onNext(self.searchType)

        mainView.prevTapGesture.rx.event
            .subscribe(with: self) { owner, _ in owner.leftViewTap() }
            .disposed(by: disposeBag)
        
        mainView.nextTapGesture.rx.event
            .subscribe(with: self) { owner, _ in owner.rightViewTap() }
            .disposed(by: disposeBag)
        
        viewModel.haveMoreImage
            .subscribe(with: self) { owner, value in
                if value { // nowPage < image.count
                    // 다음 이미지로 변경
                    owner.mainView.rankLabel.text = owner.rankTitle
                    owner.mainView.bookLabel.text = owner.imageList[owner.nowPage].title
                    owner.mainView.testImage.kf.setImage(with: URL(string: owner.imageList[owner.nowPage].cover)!)
                    owner.startProgress()
                } else {
                    owner.hero.modalAnimationType = .fade
                    owner.timer?.invalidate()
                    owner.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.viewTapped
            .subscribe(with: self) { owner, value in
                //false: leftTapped / true: rightTapped
                if value {
                    if owner.nowPage < owner.mainView.stackView.arrangedSubviews.count {
                        let progressBar = owner.mainView.stackView.arrangedSubviews[owner.nowPage] as? UIProgressView
                        progressBar?.setProgress(1.0, animated: false) // 현재 페이지에 해당하는 프로그래스 바 업데이트
                    }
                } else {
                    if owner.nowPage < owner.mainView.stackView.arrangedSubviews.count {
                        let progressBar = owner.mainView.stackView.arrangedSubviews[owner.nowPage] as? UIProgressView
                        progressBar?.setProgress(0.0, animated: false) // 현재 페이지에 해당하는 프로그래스 바 업데이트
                    }
                }
            }
            .disposed(by: disposeBag)
        
        mainView.linkButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = BookWebViewController()
                vc.bookTitle = owner.imageList[owner.nowPage].title
                vc.urlString = owner.imageList[owner.nowPage].link
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        mainView.dismissButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.hero.modalAnimationType = .fade
                owner.timer?.invalidate()
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    func addProgressBars(count: Int) {
        // 기존에 있는 프로그래스 바들 제거
        for subview in mainView.stackView.subviews {
            subview.removeFromSuperview()
        }
        
        // 이미지 개수에 따라 프로그래스 바 추가
        for _ in 0..<count {
            let progressBar = UIProgressView()
            progressBar.setProgress(0.0, animated: false) // 초기 진행 상태를 0으로 설정
            progressBar.progressTintColor = Color.mainColor
            progressBar.trackTintColor = Color.lightPoint
            mainView.stackView.addArrangedSubview(progressBar)
        }
    }
    
    func startProgress() {
        // 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func leftViewTap() {
        viewModel.viewTapped.onNext(false)
        
        time = 0.0
        nowPage -= 1
        timer?.invalidate()
        if nowPage < imageList.count {
            viewModel.haveMoreImage.onNext(true)
        } else {
            viewModel.haveMoreImage.onNext(false)
        }
    }
    
    func rightViewTap() {
        viewModel.viewTapped.onNext(true)

        time = 0.0
        nowPage += 1
        timer?.invalidate()
        if nowPage < imageList.count {
            viewModel.haveMoreImage.onNext(true)
        } else {
            viewModel.haveMoreImage.onNext(false)
        }
    }
    
    @objc func updateProgress() {
        time += 0.01
        let progress = time / 3.0
        if nowPage < mainView.stackView.arrangedSubviews.count {
            let progressBar = mainView.stackView.arrangedSubviews[nowPage] as? UIProgressView
            progressBar?.setProgress(progress, animated: false) // 현재 페이지에 해당하는 프로그래스 바 업데이트
        }
        if time >= 3.0 {
            print(Date())
            time = 0.0
            nowPage += 1
            timer?.invalidate()
            if nowPage < imageList.count {
                viewModel.haveMoreImage.onNext(true)
            } else {
                viewModel.haveMoreImage.onNext(false)
            }
        }
    }

}

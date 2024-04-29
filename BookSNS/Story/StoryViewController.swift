import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class StoryViewController: RxBaseViewController {

    var imageList: [String] = []
    
    var searchType = ""
    var nowPage = 0
    var time: Float = 0.0
    var timer: Timer?
    
    let viewModel = StoryViewModel()
    let mainView = StoryView()
    
    let nextTapGesture = UITapGestureRecognizer()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
    }
    
    override func bind() {
        let input = StoryViewModel.Input(searchListType: PublishSubject<String>())
        
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .subscribe(with: self) { owner, bookList in
                owner.addProgressBars(count: bookList.count)
                for index in 0..<bookList.count {
                    owner.imageList.append(bookList[index].cover)
                }
                
                owner.mainView.testImage.kf.setImage(with: URL(string: owner.imageList[owner.nowPage])!)
                owner.startProgress()
            }
            .disposed(by: disposeBag)
        
        input.searchListType.onNext(self.searchType)
        
        mainView.prevTapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                print("왼쪽 탭")
                owner.leftViewTap()
            }
            .disposed(by: disposeBag)
        
        mainView.nextTapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                print("오른쪽 탭")
                owner.rightViewTap()
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
        if nowPage < mainView.stackView.arrangedSubviews.count {
            let progressBar = mainView.stackView.arrangedSubviews[nowPage] as? UIProgressView
            progressBar?.setProgress(0.0, animated: false) // 현재 페이지에 해당하는 프로그래스 바 업데이트
        }
        
        time = 0.0
        nowPage -= 1
        timer?.invalidate()
        if nowPage < imageList.count {
            // 다음 이미지로 변경
            mainView.testImage.kf.setImage(with: URL(string: imageList[nowPage])!)
            // 다음 페이지의 프로그래스 바를 5초 동안 업데이트하기 위해 타이머 재시작
            startProgress()
        } else {
            // 이미지가 더 이상 없으면 이전 뷰 컨트롤러로 이동
            self.navigationController?.popViewController(animated: true)
            timer?.invalidate()
        }
    }
    
    func rightViewTap() {
        if nowPage < mainView.stackView.arrangedSubviews.count {
            let progressBar = mainView.stackView.arrangedSubviews[nowPage] as? UIProgressView
            progressBar?.setProgress(1.0, animated: false) // 현재 페이지에 해당하는 프로그래스 바 업데이트
        }

        time = 0.0
        nowPage += 1
        timer?.invalidate()
        if nowPage < imageList.count {
            // 다음 이미지로 변경
            mainView.testImage.kf.setImage(with: URL(string: imageList[nowPage])!)
            // 다음 페이지의 프로그래스 바를 5초 동안 업데이트하기 위해 타이머 재시작
            startProgress()
        } else {
            // 이미지가 더 이상 없으면 이전 뷰 컨트롤러로 이동
            self.navigationController?.popViewController(animated: true)
            timer?.invalidate()
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
                // 다음 이미지로 변경
                mainView.testImage.kf.setImage(with: URL(string: imageList[nowPage])!)
                // 다음 페이지의 프로그래스 바를 5초 동안 업데이트하기 위해 타이머 재시작
                startProgress()
            } else {
                // 이미지가 더 이상 없으면 이전 뷰 컨트롤러로 이동
                self.navigationController?.popViewController(animated: true)
                timer?.invalidate()
            }
        }
    }

}

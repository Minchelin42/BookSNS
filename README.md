# 📖 SnapBook
<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/cc124e09-3908-403e-abec-ecc8abce3d13" width="100" height="100"/>

### 좋아하는 책의 한 페이지를 공유하는 SNS 및 중고 서적 판매 또는 구입이 가능한 앱
- iOS 1인 개발 / BackEnd 협업
- 최소 버전 iOS 16.0
- 개발 기간 4주 (2024.04.11 ~ 2024.05.12)

## 📝 주요 기능
- 게시글 작성 및 수정
- 게시글 댓글 작성
- 스토리 기능 통한 도서 추천
- 게시글 스크랩
- 유저 간의 팔로잉 기능
- 프로필 조회 시 작성한 게시글 및 스크랩 게시글 조회
- 해시태그를 통한 게시글 검색
- 중고 서적 판매 및 구입

## ⚒️ 사용 기술 및 라이브러리
`UIKit` `CodeBaseUI` `RxSwift` `RxCocoa` `Alamofire` `Hero` `iamport` `IQKeyboardManager` `Kingfisher` `Tabman` `SnapKit` `Toast` `Then` `UserDefaults` `MVVM` `CompositionalLayout`


## ⚒️ 기술 적용
- **Portone** 연동을 통해 여러 결제 대행사(PG) 및 간편결제를 WebView 기반으로 구현
- **Router**를 통해 HTTP 요청을 추상화하여 Alamofire 네트워크 통신을 효율적으로 관리
- **NotificationCenter**를 통해 데이터의 변화를 감지하고 뷰의 업데이트를 진행
- **Input-Output** 패턴을 통해 데이터 흐름을 명확히 하고, 뷰와 비즈니스 로직 간의 결합도를 낮춤
- **RxSwift**와 **RxCocoa**를 통해 비동기 데이터 스트림 관리 및 UI와 비즈니스 로직 간의 데이터 바인딩 처리
- **weak self**를 통해 클로저 내부의 강한 참조 순환을 방지하여 메모리 누수 예방
- **interceptor**를 통해 accessToken을 갱신하는 인증 관리 로직 구현


## 📷 스크린샷
|회원가입|로그인|프로필 수정|스토리|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/fa78447b-877a-4661-8928-1b4857b01d78" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/fd8a5126-688a-4be8-b956-4a13bbae103f" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/8bc1956a-87d7-47cd-a6b5-380a8722ba38" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/75a851ef-5543-4b1e-bb68-62d6f3f3e636" width="200" height="390"/>|

|추천 피드|책 상세보기|해시태그 검색|게시글 스크랩|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/94797472-de97-4375-8590-9a5751c9f62e" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/47f1f3d2-8613-4c66-81e6-fce99c3e0b94" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/c25bdbb4-141e-4876-b4dc-be189c2b340b" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/4965e3bf-6691-433b-b1fa-0c48d4592c4f" width="200" height="390"/>|

|장터 피드|게시글 수정|유저 팔로우|팔로잉, 팔로워 조회|
|:---:|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/09b51b83-cba6-4c60-b790-bbda4b7941c3" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/08408298-09f7-4f16-b203-2e736c316722" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/ebeb4a9f-45f4-4166-a072-ab272ed9f89f" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/3e70a127-3760-4d1f-9f92-9cb68c4bb6ea" width="200" height="390"/>|

|결제 시도|결제 완료|결제 내역|
|:---:|:---:|:---:|
|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/4ea6c6bb-ce71-4439-9a30-88423e3813a7" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/608ab961-38d6-4267-81b6-e047a573d859" width="200" height="390"/>|<img src="https://github.com/Minchelin42/BookSNS/assets/126135097/f939661c-b5c5-471f-87f8-bfd47ff26ade" width="200" height="390"/>|

## 💥 트러블슈팅
### 1️⃣ **interceptor**

### 2️⃣ **NetworkMonitoring**

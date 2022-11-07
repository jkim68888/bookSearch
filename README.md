# bookSearch

## 구현 요소

- 책 검색 앱 작성
- 검색어를 입력하여 원하는 책을 찾을 수 있다.
- 책 목록 API를 통해 검색된 결과 값을 화면에서 목록 형태로 볼 수 있다.
- 책 목록에는 책의 커버 이미지, 제목, 저자, 출판일을 볼 수 있다.
- 검색된 책의 총 수량을 볼 수 있다.
- 검색 입력과 결과값 보기는 한 화면에 표기된다.
- 현재 목록의 하단으로 스크롤이 되면 다음 페이지의 목록을 볼 수 있다.
- 목록을 클릭하여 각 책의 상세 정보를 볼 수 있는 화면으로 이동할 수 있다.
- 책 상세 정보 화면에는 책의 주요 정보들이 표기된다. (앱에서 직접 구현)

## 사용한 기술

- Swift
- Clean architecture + MVVM
- Code based UI
- Error handling
- Development Target iOS 14.1
- Unit Test code
- Google Books APIs

## 클린아키텍쳐 레이어

- Domain Layer : Entity, Use Cases, Repositories Interfaces
- Data Layer : Repositories, API Networking, DTO (Data Transfer Object)
- Presentaion Layer (MVVM) : ViewModels, Views

## 클린아키텍쳐 컨셉

- Dependancy Injection (Direction: presentation -> Domain <- Data)
- Flow Coordinator (뷰컨트롤러 이동 로직)
- Observable (rxSwift 사용 안하고 Swift로 구현)

## 유닛 테스트

- UseCase 테스트 : api networking test
- UI 테스트 : keyboard test, list page test, detail page test

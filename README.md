<img width="507" alt="NalaMarket" src="https://user-images.githubusercontent.com/78457093/163565318-12cd72d5-93fc-470b-8bda-901f26281ab6.png">

날라 마켓은 `상품 리스트 조회`, `상세 정보 조회`, `상품 등록`을 할 수 있는 마켓 앱입니다 :)

|<img src="https://user-images.githubusercontent.com/78457093/163742148-877f68c8-cff4-4c6c-b61d-2a0db774c082.gif" width="250" height="500"/>|<img src="https://user-images.githubusercontent.com/78457093/163742122-e9f4ed85-5d72-4aa8-a8ff-8cdb167dd52a.gif" width="250" height="500"/>|<img src="https://user-images.githubusercontent.com/78457093/163741847-938a46cd-51c7-4b7e-8491-4461ce3bc117.gif" width="250" height="500"/>

# 목차
[1. 프로젝트 개요](#프로젝트-개요)  
[2. 기능](#기능)  
[3. 설계](#설계)  
[4. 트러블 슈팅](#트러블-슈팅)


# 프로젝트 개요
### 기술 스택
|분류|사용 기술|
|------|---|
|UI|· UIKit </br> · PhotosUI|
|Networking|· URLSession|
|Encoding/Decoding|· Codable </br> · JSONEncoder,JSONDecoder </br> · multipart/form-data|
|Caching|· NSCache|

### 적용한 라이브러리

- SwiftLint
    
    코딩 컨벤션을 일관되게 유지할 수 있도록 SwiftLint를 적용했습니다.  
    테스트 코드의 경우 편의를 위해 강제 언래핑을 사용하고 있어 SwiftLint 적용에서 테스트 파일은 제외하였습니다.
    

### 브랜치 전략

- Git-flow

    프로젝트를 효율적으로 관리하기 위해서 `Git-flow` 브랜치 전략을 간략화해 사용하였습니다.  
    별도로 PR과 배포 과정을 거치지 않은 프로젝트기때문에 Git-flow의 5종류 브랜치 중 `master`, `develop`, `feature`만을 활용했습니다.

    `feature`브랜치의 경우, 기능에 따라 크게 networking과 각 화면단위로 나누어 개발을 진행하였습니다.  
    `feature`브랜치에서 하나의 기능 개발이 완료되면 `develop`브랜치로 merge하고, 앱의 한 버전 개발이 모두 완료되면 `develop`브랜치에서 `master`브랜치로 merge하였습니다.

    <img width="783" alt="스크린샷 2022-04-12 오후 7 22 29" src="https://user-images.githubusercontent.com/78457093/163564947-976aa554-cbc6-4d02-9cac-a851d7de1d6f.png">

# 기능
## 기능 설명
### 상품 조회 메인 화면

- API를 GET해와 상품을 보여주는 화면.
    - Pagination [(구현방식으로 이동)](#pagination)  
    - Grid, List 형식을 버튼을 눌러 전환 [(구현방식으로 이동)](#cell-type-변경)  
    - Caching 및 Image download task 관리를 통한 사용자 편의 증가 [(구현방식으로 이동)](#이미지-다운로드-처리)  

### 상품 상세 화면

- 메인 화면에서 특정 상품을 탭하면 상세 정보를 보여주는 화면.
    - 스크롤뷰와 UIPageControl을 사용해 여러 장의 이미지를 편하게 보게 함 [(구현방식으로 이동)](#상품-이미지-넘기는-기능)  

### 상품 등록 화면

- 메인 화면에서 ‘+’버튼을 눌러 상품을 등록하는 화면.
    - multipart/form-data를 활용해 POST [(구현방식으로 이동)](#multipart-form-data를-활용해-post)  
    - iOS 버전에 따라 PHPicker와 ImagePicker 병행 사용 [(구현방식으로 이동)](#ios-버전에-따라-phpicker-imagepicker-병행-사용)  

## 기능 구현 방식

## 메인화면 [(기능설명으로 이동)](#기능-설명)

### pagination

상품 리스트를 스크롤했을 때 스크롤뷰의 y좌표를 계산해서 무한 스크롤이 가능하도록 Pagination을 구현했습니다.

현재 스크롤뷰의 y좌표가 총 contentHeight에서 스크롤뷰의 height를 뺀 것보다 크면, 즉 한 페이지가 지나가면 새로운 상품 리스트를 요청하는 ViewModel의 `update()`메소드를 호출해주고 있습니다.

```swift
// MarketMainViewController
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height

    if offsetY > (contentHeight - height) {
        viewModel.update()
    }
}

// MarketListViewModel
func update() {
    useCase.fetchProductList { [weak self] result in
        switch result {
        case .success(let products):
            self?.products.append(contentsOf: products)
        case .failure(let error):
            self?.state.value = .error(error)
        }
    }
}
```

### cell type 변경

enum을 통해 cellType을 관리하고, `UIBarButtonItem`의 selector에서 셀의 타입과 해당하는 타입의 이미지를 바꿔줍니다.

```swift
private enum CellType {
    case grid
    case list
}

private let cellType: CellType = .grid

private func changeCellType() {
    cellType = cellType == .grid ? .list : .grid
}

private func changeCellTypeBarButtonImage() {
    if cellType == .grid {
        navigationItem.rightBarButtonItems?.last?.image = Style.ChangingCellTypeBarButton.listImage
    } else {
        navigationItem.rightBarButtonItems?.last?.image = Style.ChangingCellTypeBarButton.gridImage
    }
}
```

`UICollectionViewDelegateFlowLayout`을 활용해 `cellType`별로 다른 itemSize를 주어 구현하였습니다.

```swift
// UICollectionViewDelegateFlowLayout
func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
) -> CGSize {
    switch cellType {
    case .grid:
        let paddingSpace = Style.Cell.gridSectionInsets.left * (Style.Cell.gridItemsPerRow + 1)
        let width = (collectionView.bounds.width - paddingSpace) / Style.Cell.gridItemsPerRow
        let height = (collectionView.bounds.height) / Style.Cell.gridItemsPerHeight
        return CGSize(width: width, height: height)
    case .list:
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height / Style.Cell.listItemPerHeight
        return CGSize(width: width, height: height)
    }
}
```

### 이미지 다운로드 처리

- 이미지 캐싱
    
    `NSCache`를 활용해 캐시된 이미지가 있으면 이미지 로드 요청을 하지 않고 바로 캐시된 이미지를 보여줘 사용자의 경험을 향상시킬 수 있도록 하였습니다.
    

```swift
// ThumbnailUseCase
private var imageCache = NSCache<NSString, UIImage>()

func fetchThumbnail(
    from urlString: String,
    completion: @escaping (Result<UIImage, Error>) -> Void
) -> Cancellable? {
    let cacheKey = NSString(string: urlString)
    if let cachedImage = imageCache.object(forKey: cacheKey) {
        completion(.success(cachedImage))
        return nil
    }

    let task = networkManager.request(to: urlString) { [weak self] result in
        switch result {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                completion(.failure(ThumbnailUseCaseError.invalidImageData))
                return
            }
            self?.imageCache.setObject(image, forKey: cacheKey)
            completion(.success(image))
        case .failure(let networkError):
            completion(.failure(networkError))
        }
    }
    task?.resume()
    return task
}
```

- image task 취소하기
    
    시간이 드는 이미지 요청 과정을 최소화하기 위해 셀을 재사용할 때 이미지 task 요청을 취소하고 있습니다.  
    CollectionView의 `prepareForReuse()`에서 `Cancellable`의 `cancel()` 메소드를 호출해줍니다.  
    
    셀의 뷰모델은 usecase가 어떻게 이미지를 가져오는지 알 필요가 없고, request를 취소하는 기능만 있으면되기 때문에 `Cancellable`이라는 프로토콜을 만들어 `URLSessionDataTask`가 해당 프로토콜을 채택하게 해주었고, 이미지를 로드해오는 위의 `fetchThumbnail` 메소드에서 `Cancellable`을 리턴해 task를 취소할 수 있도록 하고 있습니다.
    

```swift
// Cancellable
protocol Cancellable {    
    func cancel()
}
extension URLSessionDataTask: Cancellable {}

// MarketCollectionViewCellViewModel
private(set) var thumbnailTask: Cancellable?

func cancelThumbnailRequest() {
    thumbnailTask?.cancel()
}
```

## 상세 화면 [(기능설명으로 이동)](#기능-설명)

### 상품 이미지 넘기는 기능

상품의 여러 이미지를 가로로 넘기면서 몇 번째 이미지인지 쉽게 확인할 수 있는 기능을 스크롤뷰와 pageControl을 활용해 구현하였습니다.

viewModel과의 바인딩을 통해 이미지 데이터와 인덱스를 전달받고, 인덱스에 따라 스크롤뷰의 width frame에 곱하여 이미지뷰를 차례대로 스크롤뷰에 추가할 수 있도록 하였습니다.

```swift
// ProductDetailViewController
private func addProductImage(_ image: UIImage, to index: Int) {
    let imageView = UIImageView()
    let xPosition: CGFloat = view.frame.width * CGFloat(index)
    imageView.frame = .init(
        x: xPosition,
        y: .zero,
        width: imageScrollView.bounds.width,
        height: imageScrollView.bounds.height
    )
    imageView.image = image
    imageView.contentMode = .scaleAspectFill
    imageScrollView.insertSubview(imageView, belowSubview: imageScrollViewPageControl)
    imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + Style.indexOffset)
    imageViews.append(imageView)
}

private func setPageNumber(to numberOfImages: Int) {
    imageScrollViewPageControl.numberOfPages = numberOfImages
}

private func setCurrentPage(to currentPage: Int) {
    imageScrollViewPageControl.currentPage = currentPage
}
```

## 등록 화면 [(기능설명으로 이동)](#기능-설명)

### multipart form data를 활용해 post

Swift 라이브러리인 Alamofire의 `MultipartFormData`파일을 참고해 multipart/form-data를 [MultipartFormData 클래스](https://github.com/jazz-ing/ios-nala-market/blob/main/OpenMarket/OpenMarket/Networking/MultipartFormData.swift)를 구현했습니다.

복잡한 형식의 multipart/form-data를 간단히 구현할 수 있도록 라이브러리의 코드를 참고해 구현하였습니다.

### ios 버전에 따라 phpicker imagepicker 병행 사용

사용자의 사진 라이브러리에 접근하게 해주는 기존의 photo picker API인 `UIImagePickerController`와 iOS14부터 사용 가능한 `PHPickerViewController`API를 함께 사용해 사진 선택 기능을 구현했습니다.

`PHPickerViewController`에는 사진 검색 및 여러장의 사진을 한 번에 선택할 수 있는 등 추가된 기능들이 있고, 사용자에 권한 요청 팝업을 따로 띄우지 않고도 앱은 사용자가 선택한 사진과 비디오에만 접근가능해 사용자의 프라이버시를 더 잘 지킬 수 있다는 장점이 있습니다.  
따라서 사용자의 편의와 프라이버시 보호수준을 높이기 위해 iOS14 이상부터는 photo picker API를 `UIImagePickerController`대신 `PHPickerViewController`를 활용하도록 구현하였습니다.

```swift
@available(iOS 14, *)
private lazy var multipleImagePicker: PHPickerViewController = {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = Style.ImagePicker.imageSelectLimit
    configuration.filter = .images
    let picker = PHPickerViewController(configuration: configuration)
    return picker
}()
    
private lazy var imagePicker: UIImagePickerController = {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    return picker
}()
```

# 설계

## MVVM
<img width="709" alt="MVVM" src="https://user-images.githubusercontent.com/78457093/165266627-13e48a74-912a-4531-8d43-cc7131f49654.png">
앱에 새로운 기능이 추가되거나 수정되는 등 추후의 유지보수에 유용하고, 좀 더 testable한 코드를 작성하기 위해서 presentation logic을 분리하고 protocol을 활용해 MVVM 패턴으로 구현하였습니다.

지금은 viewModel에 대한 유닛 테스트를 진행하지 않았지만, 향후 viewModel을 쉽게 테스트할 수 있다는 장점도 있습니다.

### ViewModel 설계

- ViewController가 가질 수 있는 상태는 ‘로딩중, 로드됨, 에러, 내용없음 등’ 몇 가지로 한정되어있습니다.  
  이에 각 ViewModel이 ViewController가 가질 수 있는 상태를 `fetching`, `populated`, `error`, `empty`등으로 나누어 `State`라는 Enum으로 가지고 관리하고 있습니다.
- Enum의 연관값을 활용해 ViewModel에서 ViewController로 데이터를 넘겨주도록 하였습니다.

```swift
// MarketListViewModel
enum State {
    case fetching
    case populated(indexPaths: [IndexPath])
    case empty
    case error(Error)
}

// MarketMainViewController
private func bindWithViewModel() {
    viewModel.state.bind { [weak self] state in
        switch state {
        case .populated(let indexPaths):
            DispatchQueue.main.async {
                self?.collectionView.insertItems(at: indexPaths)
            }
        case .empty:
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        default:
            break
        }
    }
}
```

## 네트워크 설계

- httpMethod별로 Enum의 case를 나누고, 해당 Enum의 메소드로 URL을 구성하도록 구현했습니다.  
    이때, 여러 API에 대응할 수 있도록 URL을 구성하는 요소들인 `baseURL`, `path`, `query` 등을 프로퍼티로 갖는 `EndPointType`이라는 프로토콜을 작성했습니다.

```swift
typealias RequestQuery = [String: Any]?
typealias HTTPHeaders = [String: String]?

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var query: RequestQuery { get }
    var httpMethod: HTTPMethod { get }
    var httpHeader: HTTPHeaders { get }

    func configureURL() -> URL?
}

enum MarketEndPoint: EndPointType {
    case getProduct(id: Int)
    case getProductList(page: Int, numberOfItems: Int)
    case postProduct
    case patchProduct(id: Int)
    case deleteProduct(id: Int, password: String)
    // ...
}

extension MarketEndPoint {
    func configureURL() -> URL? {
        var components = URLComponents(string: self.baseURL)
        components?.path = self.path
        if let query = self.query {
            let queryItems = query.map { (key: String, value: Any) -> URLQueryItem in
                let value = String(describing: value)
                return URLQueryItem(name: key, value: value)
            }
            components?.queryItems = queryItems
        }
        return components?.url
    }
}
```

- 모델 레이어에 하나의 공통된 `NetworkManager`를 구현해 네트워크 요청을 수행하고, 각 `UseCase`에서 응답받은 데이터를 처리해주었습니다.
- 네트워크와 무관한 테스트 진행  
    서버의 상태나 네트워크의 상태와 무관하게 네트워킹 로직을 테스트하기 위해서 `URLSessionProtocol`을 구현해 `MockURLSession`을 만들어 네트워크와 무관한 테스트를 진행했습니다.
    

# 트러블 슈팅

### 상품 상세화면에서 pageControl이 보이지 않는 문제(기능으로 이동)

상세화면의 이미지를 넘기는 기능을 구현할 때, 처음에는 scrollView에 imageView를 추가하기 위해 `addSubview(_:)`를 사용하였습니다.  
하지만 imageView는 pageControl보다 늦은 시점에 추가되기 때문에 pageControl이 보이지 않는 문제가 생겼습니다.

대신 `insertSubview(_:belowSubview:)`메소드를 활용해 imageView를 View hierarchy상 pageControl의 아래에 둬서 pageControl이 보이도록 수정하였습니다.

### 상품 상세화면에서 이미지가 로드되지 않는 문제

서버에서 상품의 상세 정보 데이터를 내려줄 때, 이미지의 경우 URL을 반환해주므로 이후 이미지 데이터를 받아오는 비동기 작업을 또 한번 수행해야 합니다.  
상세 정보 데이터가 먼저 로드된 뒤에, 이미지가 로드되어야 하기 때문에 semaphore의 value를 1로 설정해 로드되는 순서를 지정해주었습니다.

### 상품 등록 화면에서 TextView의 입력값이 적용되지 않는 문제

POST에 실패하는 경우가 종종 생겼는데, break point를 찍어보니 TextView의 사용자 입력값이 적용되지 않는 문제가 있었습니다.  
특히 마지막 TextView인 상세설명란의 경우 대부분 적용이 되지 않아 원하지 않는 내용이 등록되었습니다. 

상품 등록 화면에서 사용자의 입력을 받을 때  `textViewDidEndEditing(_:)`메소드를 활용하였는데, 해당 메소드의 경우 first responder에서 해제될 때 호출되기 때문에 생기는 문제였습니다.  
사용자가 마지막 기입란인 TextView에 입력을 할 때는, 입력을 마친 뒤 키보드를 해제하지 않고 바로 등록 버튼을 누르는 경우가 많기 때문에 first responder에서 해제되지 않아 더욱 자주 문제가 발생했습니다.
이런 경우를 예방하기 위해서 완료 버튼을 눌렀을 때, 모든 TextView의 first responder가 해제될 수 있도록,
`registerButtonTapped()`에서 모든 TextView의 `resignFirstResponder()`를 호출해주었습니다.


### 상품 등록 화면에서 CurrencyPicker의 첫번째 row 선택시 입력값이 적용되지 않는 문제

사용자가 '통화'에 대한 TextView에 내용을 기입하는 경우 UIPicker를 통해 값을 선택하게 되는데,  
이 때 Picker를 움직이지 않고 바로 첫번째 줄인 'KRW'를 선택하고 완료 버튼을 누르는 경우 해당 입력값이 적용되지 않는 문제가 발생했습니다.

기존에는 pickerView의 `pickerView(_:didSelectRow:inComponent:)`를 활용했는데, 해당 메소드는 사용자가 직접 row를 움직여

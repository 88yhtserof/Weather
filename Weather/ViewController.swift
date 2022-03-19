//
//  ViewController.swift
//  Weather
//
//  Created by limyunhwi on 2022/03/16.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) //버튼 클릭 시 키보드 사라지게 하기
        }
    }
    
    func configureView(weatherInformation: WeatherInformation){
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {//weather 배열의 첫번째 원소를 할당
            self.weatherDescriptionLabel.text = weather.description //현재 날씨 정보 기입
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C" //temp에 저장된 값이 절대온도이기 때문에 273.15를 빼 섭씨온도로 변경해준다.
        self.tempLabel.text = "최저 온도: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.tempLabel.text = "최고 온도: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(messsage: String){
        let alert = UIAlertController(title: "에러", message: messsage, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String){
        debugPrint("1")
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=") else {return} //호출할 API 주소
        //API id는 정보 보호를 위해 커밋하지 않는다.
        debugPrint("2")
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in //[weak self]를 통해 순환참조 해결
            //dataTask가 API를 호출하고 서버에서 응답이오면 이 completionHandler 클로저가 호출된다.
            //data:서버에서 응답받은 데이터-JSON, response:HTTP 헤더 및 상태 코드같은 응답 메세지 데이터, error:요청을 실패하게 되면 error가 반환. 성공한다면 nil이 반환된다.
            //응답받은 Json 데이터를 WeatherInformation 객체로 디코딩되게 구현하자
            let successRange = (200..<300) //200번 대 값을 가질 수 있는 상수 선언
            guard let data = data, error == nil else {return} //요청이 성공했을 때 true
            let decorder = JSONDecoder() //JSON 객체에서 데이터 유형의 인스턴스로 디코딩하는 객체
            //즉 Codable 또는 Decodable 프로토콜을 준수하는 사용자 정의 타입으로 변환시켜주는 것
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {//응답 코드가 200번대 인지 확인한다.
                guard let weatherInformation = try? decorder.decode(WeatherInformation.self, from: data) else {return}
                //옵셔널 바인딩
                //Json을 맵핑시켜줄 Codable프로토콜을 준수하는 사용자정의 타입을 넣어준다.
                //from 파라미터에는 서버에서 응답받은 Json 데이터를 넣어준다.
                //디코딩을 실패하면 error를 던져주기 떄문에 try?를 넣어준다.
                //네트워크 작업은 별도의 쓰레드에서 진행되고 응답이 온다해도 자동으로 메인 쓰레드로 돌아오지 않기 때문에
                //dateTask의 파라미터인 completionHandler closer에서 UI작업을 한다면 메인쓰레드에서 작업을 할 수 있도록 만들어주어야 한다.
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false //숨겨놓은 뷰 보이기
                    self?.configureView(weatherInformation: weatherInformation)
                }
            }else {
                //요청 실패
                guard let errorMessage = try? decorder.decode(ErroeMessage.self, from: data) else {return} //서버에서 응답받은 에러 Json 데이터를 ErrorMessage 객체로 디코딩한다.
                DispatchQueue.main.async {
                    self?.showAlert(messsage: errorMessage.message)
                }
            }
        }.resume() //작업 실행
        
        //크롬 option+ comand+ i = 웹브라우저 개발자 모드
    }
}


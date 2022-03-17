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
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=") else {return} //호출할 API 주소
        //API id는 정보 보호를 위해 커밋하지 않는다.
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            //dataTask가 API를 호출하고 서버에서 응답이오면 이 completionHandler 클로저가 호출된다.
            //data:서버에서 응답받은 데이터-JSON, response:HTTP 헤더 및 상태 코드같은 응답 메세지 데이터, error:요청을 실패하게 되면 error가 반환. 성공한다면 nil이 반환된다.
            //응답받은 Json 데이터를 WeatherInformation 객체로 디코딩되게 구현하자
            guard let data = data, error == nil else {return} //요청이 성공했을 때 true
            let decorder = JSONDecoder() //JSON 객체에서 데이터 유형의 인스턴스로 디코딩하는 객체
            //즉 Codable 또는 Decodable 프로토콜을 준수하는 사용자 정의 타입으로 변환시켜주는 것
            let weatherInformation = try? decorder.decode(WeatherInformation.self, from: data)
            //Json을 맵핑시켜줄 Codable프로토콜을 준수하는 사용자정의 타입을 넣어준다.
            //from 파라미터에는 서버에서 응답받은 Json 데이터를 넣어준다.
            //디코딩을 실패하면 error를 던져주기 떄문에 try?를 넣어준다.
            debugPrint(weatherInformation)
        }.resume() //작업 실행
    }
}


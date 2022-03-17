//
//  WeatherInformation.swift
//  Weather
//
//  Created by limyunhwi on 2022/03/17.
//

import Foundation

struct WeatherInformation: Codable {
    /*
     Codable이란?
     자신을 변환하거나 외부 표현으로 변환할 수 있는 타입
     예) 외부 표현 - Json 타입
     Codable은 Decodable과 Encodable 프로토콜을 준수한다.
     Decodable은 자신을 외부표현에서 decoding할 수 있는 타입
     Encodable은 자신을 외부표현에서 Encoding할 수 있는 타입
     즉, Codable프로토콜을 채택했다는 것 Json encoing과 decoding이 모두 가능하다는 의미
     즉 Codable 프로토콜을 채택하면 WeatherInformation 객체를 Json 형태로 만들 수 있고, Json 형태를 WeatherInformation 객체로 만들 수 있다.
     
     Codable 프로토콜을 채택해 서버에서 전달받은 날씨정보 Json 데이터를 WeatherInformation struct 타입으로 변환하는 작업(decoding)작업을 수행하자.
     날씨 Json 정보에서 필요한 프로퍼티만 구조체에 정의하자
     */
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    /*
     "weather": [
         {
           "id": 800,
           "main": "Clear",
           "description": "clear sky",
           "icon": "01d"
         }
     Json의 키와 사용자가 정의한 프로퍼티 이름과 타입이 일치해야한다.
     만약 키와 프로퍼티 이름을 다르게 사용하고 싶다면 타입 내부에서 Codingkeys라는 스트링 타입의 열거형을 선언하고 Codingkey 프로토콜을 준수하게 만들어야 한다.
     */
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    //main 키에 있는 객체를 Temp 구조체에 맵핑시키기 위해서 프로퍼티를 정의하자
    /*
     "main": {
         "temp": 282.55,
         "feels_like": 281.86,
         "temp_min": 280.37,
         "temp_max": 284.26,
         "pressure": 1023,
         "humidity": 100
       }
     사용할 프로퍼티만 정의한다.
     _는 사용하지 않았기 때문에 프로퍼티의 이름과 구조체에 정의한 이름이 다르다.
     타입 내부에 코딩키스라는 문자열 타입의 열거형을 선언하고 Codingkey 프로토콜을 준수하게 만들어서 Json 키와 프로퍼티 이름이 달라도 맵핑될 수 있게 구현하자.
     */
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum Codingkeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxtemp = "temp_max"
    }
}

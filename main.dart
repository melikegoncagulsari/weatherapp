import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

const List<String> cities = ["Ankara", "İstanbul", "Hatay", "Corum", "Antalya"];
const apiKey = 'api key giriniz';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hava Durumu')),
        body: ListView.separated(
          itemBuilder: (BuildContext context, index) {
            return FutureBuilder<WeatherData>(
              future: fetchWeather(cities[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final weatherData = snapshot.data;
                  return WeatherInfo(weatherData: weatherData!);
                } else {
                  return const Text("Veri Yok");
                }
              },
            );
          },
          itemCount: cities.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherInfo({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weatherData.location,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          "${weatherData.temperature}°C",
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          "${weatherData.humidity}%",
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          "${weatherData.windSpeed}m/s",
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

Future<WeatherData> fetchWeather(String city) async {
  final response = await http.get(
    Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=$city'),
    headers: {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Veri Alınamadı!');
  }

  return WeatherData.fromJson(jsonDecode(response.body));
}

class WeatherData {
  final String location;
  final double temperature;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location']['name'],
      temperature: json['current']['temp_c'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_mph'],
    );
  }
}

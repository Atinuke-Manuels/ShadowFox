import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';
import 'location_input_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  Weather? _forecastWeather;

  @override
  void initState() {
    super.initState();

    _fetchWeatherData("Lagos"); // Default location: Lagos
  }

  void _fetchWeatherData(String location) {
    _wf.currentWeatherByCityName(location).then((weather) {
      setState(() {
        _weather = weather;
      });
    }).catchError((error) {
      // print("Error fetching current weather: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching current weather: $error"),
        ),
      );
      // Handle error gracefully
    });

    _wf.fiveDayForecastByCityName(location).then((forecast) {
      setState(() {
        // Assuming you want the first forecast entry for now
        if (forecast.isNotEmpty) {
          _forecastWeather = forecast[0];
        }
      });
    }).catchError((error) {
      // print("Error fetching forecast weather: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching forecast weather: $error"),
        ),
      );
      // Handle error gracefully
    });
  }

  void _changeLocation() async {
    String? newLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationInputPage()),
    );
    if (newLocation != null && newLocation.isNotEmpty) {
      _fetchWeatherData(newLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: _changeLocation,
        tooltip: 'Change Location',
        child: Icon(Icons.location_city, color: Colors.white,),
      ),
    );
  }

Widget _buildUI(){
    if(_weather == null ){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationName(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
          _dateAndTime(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          _weatherIcon(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
          _locationTemp(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          _otherInfo(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
          _futureDateAndTime(),
          _futureInfo(),
      ],),
    );
  }

  Widget _locationName(){
    return Text(_weather?.areaName ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
  }

  Widget _dateAndTime(){
    DateTime now = _weather!.date!;
    return Column(children: [
      Text(DateFormat("EEEE, dd/MM/yyyy").format(now), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      SizedBox(height: 10,),
      Text(DateFormat("hh:mm a").format(now), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
    ],);
  }

  Widget _weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.22,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))
          ),
        ),
        Text(_weather?.weatherDescription ?? ""),
    ],);
  }

  Widget _locationTemp(){
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),);
  }

  Widget _otherInfo(){
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.sizeOf(context).height * 0.08,
      width: MediaQuery.sizeOf(context).width * 0.9,
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          children: [
            Text("Max temp", style: TextStyle(fontSize: 12, color: Colors.white38),),
            Text("${_weather?.tempMax?.celsius?.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),),
          ],
        ),
        Column(
          children: [
            Text("Min temp", style: TextStyle(fontSize: 12, color: Colors.white38),),
            Text("${_weather?.tempMin?.celsius?.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),),
          ],
        ),
        Column(
          children: [
            Text("Wind Speed", style: TextStyle(fontSize: 12, color: Colors.white38),),
            Text("${_weather?.windSpeed?.toStringAsFixed(0)}m/s ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),),
          ],
        ),
        Column(
          children: [
            Text("Humidity", style: TextStyle(fontSize: 12, color: Colors.white38),),
            Text("${_weather?.humidity?.toStringAsFixed(0)}% ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),),
          ],
        ),
      ],),
    );
  }

  Widget _futureDateAndTime(){
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));

    return Column(children: [
      Text("Forecast for tomorrow", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
      Text(DateFormat("EEEE, dd/MM/yyyy").format(tomorrow), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),),
    ],);
  }

  Widget _futureInfo(){
    if (_forecastWeather == null ||
        _forecastWeather?.temperature == null ||
        _forecastWeather?.tempMax == null ||
        _forecastWeather?.tempMin == null) {
      return Container(); // Return an empty container or some placeholder widget
    }

    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.sizeOf(context).height * 0.08,
      width: MediaQuery.sizeOf(context).width * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("temp", style: TextStyle(fontSize: 12, color: Colors.brown),),
              Text("${_forecastWeather!.temperature!.celsius!.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.brown),),
            ],
          ),
          Column(
            children: [
              Text("Max temp", style: TextStyle(fontSize: 12, color: Colors.brown),),
              Text("${_forecastWeather!.tempMax!.celsius!.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.brown),),
            ],
          ),
          Column(
            children: [
              Text("Min temp", style: TextStyle(fontSize: 12, color: Colors.brown),),
              Text("${_forecastWeather!.tempMin!.celsius!.toStringAsFixed(0)} °C ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.brown),),
            ],
          ),
        ],
      ),
    );
  }

}


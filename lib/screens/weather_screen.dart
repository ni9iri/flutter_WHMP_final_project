import 'package:flutter/material.dart';
import '../widgets/authentication/signout.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_app/.env';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherFactory wf = new WeatherFactory(MY_API_KEY);
  Weather? _weather;
  String? _error;
  bool _loading = true;

  @override
  Future<void> _getWeather(double latitude, double longitude) async {
    try {
      Weather weather = await wf.currentWeatherByLocation(latitude, longitude);
      setState(() {
        _loading = false;
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
          _error = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _loading = false;
            _error = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
          _error =
              'Location permissions are permanently denied, we cannot request permissions.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      await _getWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _showPermissionDeniedlog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('Permission denied'),
              content: Text('You have denied location permission'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Settings'),
                  onPressed: () {
                    Geolocator.openAppSettings();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather forecast'),
        actions: [
          Signout(),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _weather != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Weather: ${_weather!.weatherMain}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Currrent location: ${_weather!.areaName}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Temperature: ${_weather!.temperature!.celsius!.toStringAsFixed(1)}°C',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Humidity: ${_weather!.humidity!.toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Pressure: ${_weather!.pressure!.toStringAsFixed(1)} hPa',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Sunrise: ${_weather!.sunrise}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Sunset: ${_weather!.sunset}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Date: ${_weather!.date}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    _error!,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
    );
  }
}

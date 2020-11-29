import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

//655160e386ca728db8e3f8d91371a955
//api.openweathermap.org/data/2.5/weather?q=London&appid=655160e386ca728db8e3f8d91371a955
//https://api.darksky.net/forecast/4f3e28c734584c3f281edfedf87b58ce/60.0,24.0?units=si
//https://api.mapbox.com/geocoding/v5/mapbox.places/London.json?access_token=pk.eyJ1IjoibGVzdGVyY3Jlc3Q0OSIsImEiOiJja2hsemRod2cyMHFkMnlxcXIzYTZneXpkIn0.nTQG5FrnF0Et8jpHUe0GVQ

// Icons
// rain
// cloudy
// wind
// partly-cloudy-night
// partly-cloudy-day"
// clear-night
// clear-day
// clear-night


void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}



class _WeatherAppState extends State<WeatherApp> {
  int temperature = 0;
  String location = 'San Francisco';
  int woeid = 2487956;
  String weather = 'clear1';

  Random rnd = new Random();

  void locationFetcher(String input) async {
    String address = input.replaceAll(" ", '%20');
    String mapBox = 'https://api.mapbox.com/geocoding/v5/mapbox.places/' + address + '.json?access_token=pk.eyJ1IjoibGVzdGVyY3Jlc3Q0OSIsImEiOiJja2hsemRod2cyMHFkMnlxcXIzYTZneXpkIn0.nTQG5FrnF0Et8jpHUe0GVQ';
    var searchResult = await http.get(mapBox);
    var result = json.decode(searchResult.body);
    var long = result["features"][0]["geometry"]["coordinates"][0].toString();
    var lat = result["features"][0]["geometry"]["coordinates"][1].toString();

    String darkSky = 'https://api.darksky.net/forecast/4f3e28c734584c3f281edfedf87b58ce/' + lat + ',' + long + '?units=si';
    var darkResult = await http.get(darkSky);
    var darkBody = json.decode(darkResult.body);
    print(darkBody);
    setState(() {
      temperature = darkBody["currently"]["temperature"].round();
      location = result["features"][0]["text"];

    });

  }


  void selectImage(){
    if(weather == 'clear'){
      int min = 1;
      int max = 3;
      int r = min + rnd.nextInt(max - min);
      weather = weather + r.toString();
      print(weather);
    }
    if(weather == 'lightcloud'){
      int min = 1;
      int max = 3;
      int r = min + rnd.nextInt(max - min);
      weather = weather + r.toString();
      print(weather);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/$weather.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        temperature.toString() + ' °C',
                        style: TextStyle(
                            color: Colors.white, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        location,
                        style: TextStyle(
                            color: Colors.white, fontSize: 40.0),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: TextField(
                        onSubmitted: (String input) {
                       locationFetcher(input);
                        },
                        style:
                        TextStyle(color: Colors.white, fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Search another location...',
                          hintStyle: TextStyle(
                              color: Colors.white, fontSize: 18.0),
                          prefixIcon:
                          Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

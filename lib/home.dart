import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_api_client.dart';
import 'package:weather_app/views/additional_information.dart';
import 'package:weather_app/views/current_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _textController = TextEditingController();
  String getWeather = "Mexico City";

  WeatherApiClient client = WeatherApiClient();
  Weather? data;

  Future<void> getData() async {
    data = await client.getCurrentWeather(getWeather);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF101039),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1886E0),
        elevation: 0.0,
        title: const Text(
          "Weather Forecast",
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.0, 5.0),
                blurRadius: 15.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.all(22.0),
              child: Text(
                "Write the name of a city to know what's the weather like in that city.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search for location",
                  filled: true,
                  fillColor: const Color(0xFF222248),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF222248), width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF222248), width: 0.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintStyle:
                      const TextStyle(color: Color(0xFFc0c0c0), fontSize: 16.0),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        getWeather = _textController.text;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xFFc0c0c0),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_textController) {
                  setState(() {
                    getWeather = _textController;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentWeather(Icons.wb_sunny_rounded, "${data!.temp}°",
                          "${data!.cityName}"),
                      const SizedBox(
                        height: 60.0,
                      ),
                      const Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20.0,
                      ),
                      additionalInformation(
                          "${data!.wind}",
                          "${data!.humidity}",
                          "${data!.pressure}",
                          "${data!.feels_like}"),
                    ],
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
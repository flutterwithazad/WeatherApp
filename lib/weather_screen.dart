import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

import './widgets/card.dart';
import './widgets/additional_information.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  NumberFormat formatter = NumberFormat("##0");

  Future<Map<String, dynamic>> getWeather() async {
    try {
      const uri =
          "https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=e69635933445698052ec12ea74a479bf";
      final response = await http.get(Uri.parse(uri));
      final jsonData = jsonDecode(response.body);

      return jsonData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  weather = getWeather();
                });
              },
              icon: const Icon(Icons.refresh_outlined),
            )
          ],
        ),
        body: FutureBuilder(
            future: weather,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              final data = snapshot.data!;
              final currentSky = data["list"][0];
              final temp = currentSky["main"]["temp"];
              final currentWeather = currentSky["weather"][0]['main'];
              final humidity = currentSky["main"]["humidity"];
              final pressure = currentSky["main"]["pressure"];

              final windSpeed = currentSky["wind"]["speed"];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 16,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "${formatter.format(temp)}° K",
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    currentWeather == "Clouds" ||
                                            currentWeather == "Rain"
                                        ? const Icon(
                                            Icons.cloud,
                                            size: 65,
                                          )
                                        : const Icon(
                                            Icons.sunny,
                                            size: 65,
                                          ),
                                    Text(
                                      currentWeather,
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Hourly Forecast",
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data["list"].length,
                            itemBuilder: (context, index) {
                              final currentTime = DateTime.parse(
                                  data["list"][index + 1]['dt_txt']);
                              final hourslydata =
                                  data["list"][index + 1]["main"]['temp'];

                              return CardWidget(
                                  icon: data["list"][index + 1]["weather"][0]
                                                  ['main'] ==
                                              "Clouds" ||
                                          data["list"][index + 1]["weather"][0]
                                                  ['main'] ==
                                              "Rain"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  temperature:
                                      "${formatter.format(hourslydata)}° K",
                                  time: DateFormat.j()
                                      .format(currentTime)
                                      .toString());
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Additional Information",
                        style: TextStyle(fontSize: 32),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AdditionalInformation(
                              numberData: humidity.toString(),
                              unitData: "Humidity",
                              icon: Icons.water_drop,
                            ),
                            AdditionalInformation(
                              numberData: windSpeed.toString(),
                              unitData: "Wind Speed",
                              icon: Icons.air,
                            ),
                            AdditionalInformation(
                              numberData: pressure.toString(),
                              unitData: "Pressure",
                              icon: Icons.beach_access,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}

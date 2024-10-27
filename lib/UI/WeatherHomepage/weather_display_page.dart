// # views/home_page.dart
import 'package:flutter/material.dart';
import 'package:learning_bloc_app/UI/WeatherHomepage/weather_details_page.dart';
import 'package:learning_bloc_app/Viewmodels/home_viewmodel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchWeatherAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.menu), // Leading icon (e.g., a menu icon)
          onPressed: () {
            // Handle menu button press
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu pressed')),
            );
          }
        ),
         actions: [
          IconButton(
            icon:  const Icon(Icons.logout), // Action icon (e.g., notifications)
            onPressed: () {
              setState(() {
                _viewModel.isValidUser = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('logout pressed')),
              );
            },
          ),
        ],
      ),
      body:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _viewModel.selectedLocation,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _viewModel.updateLocation(newValue!);
                      });
                    },
                    items: _viewModel.locations
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            )
    );
  }

  Widget _buildContent() {
    return StreamBuilder<HomeViewState>(
      stream: _viewModel.stateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final state = snapshot.data!;
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.weatherAlerts.isEmpty) {
            return const Center(child: Text('No alerts available.'));
          } else {
            return ListView.builder(
              itemCount: state.weatherAlerts.length,
              itemBuilder: (context, index) {
                final alert = state.weatherAlerts[index];
                return CustomCard(
                  title: alert.headline,
                  description: alert.desc,
                  image: "https://picsum.photos/200/300?random",
                  onReadMore: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondScreen(data: alert.desc),
                      ),
                    );
                  },
                );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final String? image; 
  final VoidCallback onReadMore;

  const CustomCard({
    super.key,
    required this.title,
    required this.description,
    this.image,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            Image.network(
              image!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: onReadMore,
                  child: const Text('Read More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

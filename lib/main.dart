import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_app/UI/Calculator/Calculator.dart';
import 'package:learning_bloc_app/UI/Counter/counter_screen.dart';
import 'package:learning_bloc_app/UI/FetchPosts/post.dart';
import 'package:learning_bloc_app/UI/ImagePicker/image_picker.dart';
import 'package:learning_bloc_app/UI/ToDo/to_do.dart';
import 'package:learning_bloc_app/UI/WeatherHomepage/weather_display_page.dart';
import 'package:learning_bloc_app/bloc/Calculator/calculator_bloc.dart';
import 'package:learning_bloc_app/bloc/FetchPosts/fetch_post_bloc.dart';
import 'package:learning_bloc_app/bloc/ImagePicker/bloc/image_picker_bloc.dart';
import 'package:learning_bloc_app/Utils/image_picker_utils.dart';
import 'package:learning_bloc_app/bloc/Todo/todo_bloc.dart';
import 'package:learning_bloc_app/bloc/counter/counter_bloc.dart';
import 'package:learning_bloc_app/UI/MultiComponent/multi_component_screen.dart';
import 'package:learning_bloc_app/bloc/switchEvents/switch_event_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SwitchEventBloc()),
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => ImagePickerBloc(ImagePickerUtils())),
        BlocProvider(create: (context) => CalculatorBloc()),
        BlocProvider(create: (context) => TodoBloc()),
         BlocProvider(create: (context) => FetchPostsBloc()),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Screen')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: [
          _buildGridCard(
            context,
            icon: Icons.toggle_on,
            title: 'Switch Example',
            route: const SwitchExampleBlock(title: 'Multi Component'),
          ),
          _buildGridCard(
            context,
            icon: Icons.exposure_plus_1,
            title: 'Counter Screen',
            route: const CounterScreen(title: 'Bloc Counter'),
          ),
          _buildGridCard(
            context,
            icon: Icons.select_all_outlined,
            title: 'Image Picker',
            route: const ImagePickerWidget(title: 'Image Picker'),
          ),
          _buildGridCard(
            context,
            icon: Icons.calculate_rounded,
            title: 'Calculator',
            route: const Calculator(title: 'Calculator'),
          ),
          _buildGridCard(
            context,
            icon: Icons.task,
            title: 'To Do',
            route: const ToDoScreen(title: 'To do'),
          ),
          _buildGridCard(
            context,
            icon: Icons.cloud,
            title: 'Weather',
            route: const MyHomePage(title: 'Weather'),
          ),
          _buildGridCard(
            context,
            icon: Icons.note,
            title: 'Posts',
            route: const PostScreen(title: 'Fetch Posts'),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildGridCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Optional: Rounded corners
        ),
        child: Center(
          child: Padding(
            // Added padding
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 48.0,
                    color: Colors.teal), // Icon color for consistency
                const SizedBox(height: 12.0), // Slightly more spacing
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold), // Bolder text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

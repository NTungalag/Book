import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Тавтай морил',
                style: TextStyle(
                    fontSize: 30, color: Colors.black.withOpacity(1), fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Хүссэн номоо солилцоод уншаарай',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(1),
                ),
              ),
            ]),
      ),
    );
  }
}

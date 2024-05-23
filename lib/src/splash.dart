import 'package:flutter/material.dart';
import 'package:social_x/core/utils/firebase/push_notification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationServices services = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices.requestNotificationPermissions();
    services.firebaseInit(context);
    services.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  'assets/images/new1.png',
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text(
              'WaveConnect',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
                fontFamily: 'Ubuntu-Regular',
              ),
            )
          ],
        ),
      ),
    );
  }
}

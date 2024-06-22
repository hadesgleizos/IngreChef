import 'package:flutter/material.dart';
import 'package:main/Home/recipes.dart';
import 'package:main/Home/scan.dart';
import 'package:main/Home/settings.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building MyHomePage');

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        automaticallyImplyLeading: false, //just for the back button
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.01, -0.74),
              child: Container(
                width: 200,
                height: 200,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image(
                  image: AssetImage('assets/images/ingreicon.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-0.04, -0.21),
              child: Text(
                'IngreChef',
                style: const TextStyle(
                  fontFamily: 'GreatVibes',
                  fontSize: 60,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.1),
              child: Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SavedRecipesPage(
                                      )));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFF1F1F1)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 16.0,
                          )),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/recipe.png',
                              width: 60,
                              height: 38,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Saved Recipes',
                              style: TextStyle(
                                fontFamily: 'NanumGothic', //Custom Font
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CameraView()
                              ));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFF1F1F1)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                            horizontal: 48.0,
                            vertical: 16.0,
                          )),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/photocamera.png',
                              width: 60,
                              height: 38,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              'Scan Now',
                              style: TextStyle(
                                fontFamily: 'NanumGothic', // Custom Font
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 16.0),                //Test Button (uncomment to use)
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => RecipeListScreen(
                      //             )));
                      //   },
                      //   style: ButtonStyle(
                      //     backgroundColor: MaterialStateProperty.all(
                      //         const Color(0xFFF1F1F1)),
                      //     foregroundColor:
                      //     MaterialStateProperty.all(Colors.black),
                      //     padding: MaterialStateProperty.all(
                      //         const EdgeInsets.symmetric(
                      //           horizontal: 48.0,
                      //           vertical: 16.0,
                      //         )),
                      //     shape: MaterialStateProperty.all(
                      //       RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(16.0),
                      //         side: const BorderSide(
                      //           color: Colors.black,
                      //           width: 1.0,
                      //         ),
                      //       ),
                      //     ),
                      //     elevation: MaterialStateProperty.all(0),
                      //     shadowColor:
                      //     MaterialStateProperty.all(Colors.transparent),
                      //   ),
                      //   child: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       const SizedBox(width: 8.0),
                      //       Text(
                      //         'Test',
                      //         style: TextStyle(
                      //           fontFamily: 'NanumGothic', // Custom Font
                      //           fontSize: 20,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whatfood/app/components/camera_component.dart';
import 'package:whatfood/app/controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController homeController;
  late CameraComponent cameraComponent;

  @override
  void initState() {
    super.initState();
    homeController = HomeController();
    cameraComponent = CameraComponent();
    homeController.getListFoodSaved();
    homeController.addListener(() {
      if (homeController.imagemCapturada != null) {
        Navigator.of(context).pushNamed('/food',
            arguments: {'image': homeController.imagemCapturada!});
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Whatfood',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Icon(
              Icons.restaurant_menu_outlined,
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: homeController.listFood.length,
          itemBuilder: (context, index) {
            return Card.outlined(
              child: ListTile(
                title: Text(homeController.listFood[index].prato),
                subtitle: Text(homeController.listFood[index].descricao),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cameraComponent.open(context, cameraComponent);
          homeController.capturaImagem(cameraComponent);
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
      // bottomNavigationBar: NavigationBar(
      //   destinations: const [
      //     NavigationDestination(
      //       selectedIcon: Icon(Icons.list_alt_outlined),
      //       icon: Icon(Icons.list_alt),
      //       label: 'Minhas receitas',
      //     ),
      //     NavigationDestination(
      //         selectedIcon: Icon(Icons.camera_alt_outlined),
      //         icon: Icon(Icons.camera_alt),
      //         label: 'Buscar receita'),
      //   ],
      // ),
    );
  }
}

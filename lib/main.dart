import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/product_data.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //حطينا ال value دي عشان يعتمدش ع ال context
    return MultiProvider(
        //هنا احنا بنعمل كذا بروفايدر عادي لكن لما يكون عندنا برزفايدر عايز معلومة من بروافيدر تاني
        //بنعمل ChangeNotifierProxyProvider وده بياخد حاجتين الاولي البروفايدر اللي فيه الحاجة اللي احنا عاوزنها
        // والتانية البروفايدر اللي عايز الحاجة
        // وبياخد دالتين الاولي create بتعمل ريترن للبروفايدر اللي عايز الحاجة
        // والتانية update بتاخد3 حاجات الكونتكست واسم يعبر عن البروفايدر اللي فيه الحاجة واسم بيعبر عن البروفايدر اللي هيستخدم الحاجة
        // وبتعمل ريترن ل للبروفايدر اللي هياخد الحاجة وهو واخد الحاجة عبارة عن براميتر

        providers: [
          ChangeNotifierProvider.value(value: AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, ProductsData>(
            create: (_) => ProductsData(),
            update: (_, auth, prod) =>
                ProductsData(token: auth.token, userId: auth.userId),
          ),
          ChangeNotifierProvider.value(value: Cart()),
          ChangeNotifierProxyProvider<AuthProvider, Order>(
            create: (_) => Order(),
            update: (_, auth, order) =>
                Order(authToken: auth.token, userId: auth.userId),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryToLogIn(),
                    builder: (ctx, authData) =>
                        authData.connectionState == ConnectionState.waiting
                            ? Center(
                                child: Text('Loading..'),
                              )
                            : AuthScreen()),
          ),
        ));
  }
}

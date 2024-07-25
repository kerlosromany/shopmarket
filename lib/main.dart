import 'package:admin_app/bloc_observer.dart';
import 'package:admin_app/cubits/main_cubit/main_cubit.dart';
import 'package:admin_app/cubits/order_cubit/order_cubit.dart';
import 'package:admin_app/screens/cats_screen.dart';
import 'package:admin_app/screens/dashboard_screen.dart';
import 'package:admin_app/screens/edit_upload_product_form_screen.dart';
import 'package:admin_app/screens/inner_screens/delete_manadep_screen.dart';
import 'package:admin_app/screens/inner_screens/edit_user/edit_users_screen.dart';
import 'package:admin_app/screens/inner_screens/get_manadep_mails_screen.dart';
import 'package:admin_app/screens/inner_screens/orders/test_screen.dart';
import 'package:admin_app/screens/inner_screens/update_percentage_screen.dart';
import 'package:admin_app/screens/inner_screens/upload_category_screen.dart';
import 'package:admin_app/screens/semi_login_screen.dart';
import 'package:admin_app/screens/sign_up_screen.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/inner_screens/orders/orders_screen.dart';
import 'screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(
          create: (context) => MainCubit(),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop Smart ADMIN AR',
          home: const DashboardScreen(),
          theme: ThemeData(
            fontFamily:
            ArabicThemeData.font(arabicFont: ArabicFont.dinNextLTArabic),
        package: ArabicThemeData.package,
          ),
          routes: {
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            EditOrUploadProductScreen.routeName: (context) => const EditOrUploadProductScreen(),
            RegisterScreen.routName: (context) => const RegisterScreen(),
           // DeleteManadepScreen.routName: (context) => const DeleteManadepScreen(),
            UploadCategoryScreen.routeName: (context) => const UploadCategoryScreen(),
            EditUsersScreen.routeName: (context) => const EditUsersScreen(),
            CatsScreen.routeName: (context) => const CatsScreen(),
            GetManadetMailsScreen.routeName: (context) => const GetManadetMailsScreen(),
            UpdatePercentageScreen.routeName: (context) => const UpdatePercentageScreen(),
            OrdersTestScreen.routeName: (context) => const OrdersTestScreen(),
          },
        ),
    );
  }
}

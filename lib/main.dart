import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:book/features/data/datasource/book_local_datasource.dart';
import 'package:book/features/data/models/book_model.dart';
import 'package:book/features/data/repository/book_local_repository_impl.dart';
import 'package:book/features/domain/usecases/get_audiobooks_usecase.dart';
import 'package:book/features/domain/usecases/local_book_usecases.dart';
import 'package:book/features/presentation/home/audiobloc/audio_book_bloc.dart';
import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:book/core/network/dio_client.dart';
import 'package:book/features/data/datasource/book_remote_datasource.dart';
import 'package:book/features/data/repository/book_repository_impl.dart';
import 'package:book/features/domain/usecases/get_books_usecase.dart';
import 'package:book/features/presentation/home/bloc/book_bloc.dart';
import 'package:book/features/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:book/features/presentation/navigation/pages/main_navigation_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookModelAdapter());
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('uz'),
        Locale('en'),
        Locale('ru'),
      ],
      path: "assets/translation",
      fallbackLocale: const Locale("en"),
      startLocale: const Locale("en"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.locale;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => FavouriteBloc(
            DeleteLocalBookUsecase(
              bookLocalRepository: BookLocalRepositoryImpl(
                bookLocalDatasource: BookLocalDatasourceImpl(),
              ),
            ),
            GetLocalBooksUseCase(
              bookLocalRepository: BookLocalRepositoryImpl(
                bookLocalDatasource: BookLocalDatasourceImpl(),
              ),
            ),
            AddLocalBookUsecase(
              bookLocalRepository: BookLocalRepositoryImpl(
                bookLocalDatasource: BookLocalDatasourceImpl(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => AudioBookBloc(GetAudiobooksUsecase(
            bookRepository: BookRepositoryImpl(
              bookRemoteDatasource: BookRemoteDatasourceImpl(
                dioClient: DioClient(),
              ),
            ),
          )),
        ),
        BlocProvider(
          create: (context) => BookBloc(GetBooksUsecase(
            bookRepository: BookRepositoryImpl(
              bookRemoteDatasource: BookRemoteDatasourceImpl(
                dioClient: DioClient(),
              ),
            ),
          )),
        ),
      ],
      child: AdaptiveTheme(
        initial: AdaptiveThemeMode.dark,
        light: ThemeData.light(useMaterial3: true),
        dark: ThemeData.dark(useMaterial3: true),
        builder: (light, dark) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: dark,
            darkTheme: dark,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

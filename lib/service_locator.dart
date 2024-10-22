// import 'package:book/core/network/dio_client.dart';
// import 'package:book/features/data/datasource/book_local_datasource.dart';
// import 'package:book/features/data/datasource/book_remote_datasource.dart';
// import 'package:book/features/data/repository/book_local_repository_impl.dart';
// import 'package:book/features/data/repository/book_repository_impl.dart';
// import 'package:book/features/domain/repository/book_repository.dart'; // Add this import
// import 'package:book/features/domain/usecases/get_audiobooks_usecase.dart';
// import 'package:book/features/domain/usecases/get_books_usecase.dart';
// import 'package:book/features/domain/usecases/local_book_usecases.dart';
// import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
// import 'package:book/features/presentation/home/audiobloc/audio_book_bloc.dart';
// import 'package:book/features/presentation/home/bloc/book_bloc.dart';
// import 'package:book/features/presentation/navigation/cubit/navigation_cubit.dart';
// import 'package:get_it/get_it.dart';

// final getIt = GetIt.instance;

// Future<void> setupDependencies() async {
//   // Network
//   getIt.registerLazySingleton(() => DioClient());

//   // Data sources
//   getIt.registerLazySingleton<BookRemoteDatasource>(
//     () => BookRemoteDatasourceImpl(dioClient: getIt()),
//   );
//   getIt.registerLazySingleton<BookLocalDatasource>(
//     () => BookLocalDatasourceImpl(),
//   );

//   // Repositories
//   getIt.registerLazySingleton<BookRepository>(
//     // Change this line
//     () => BookRepositoryImpl(bookRemoteDatasource: getIt()),
//   );
//   getIt.registerLazySingleton(
//     () => BookLocalRepositoryImpl(bookLocalDatasource: getIt()),
//   );

//   // Use cases
//   getIt.registerLazySingleton(() => GetBooksUsecase(bookRepository: getIt()));
//   getIt.registerLazySingleton(
//       () => GetAudiobooksUsecase(bookRepository: getIt()));
//   getIt.registerLazySingleton(
//       () => GetLocalBooksUseCase(bookLocalRepository: getIt()));
//   getIt.registerLazySingleton(
//       () => AddLocalBookUsecase(bookLocalRepository: getIt()));
//   getIt.registerLazySingleton(
//       () => DeleteLocalBookUsecase(bookLocalRepository: getIt()));

//   // Blocs
//   getIt.registerFactory(() => NavigationCubit());
//   getIt.registerFactory(() => FavouriteBloc(getIt(), getIt(), getIt()));
//   getIt.registerFactory(() => AudioBookBloc(getIt()));
//   getIt.registerFactory(() => BookBloc(getIt()));
// }

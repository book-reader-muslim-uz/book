import 'package:book/features/presentation/favorite_screen/bloc/favourite_bloc.dart';
import 'package:book/features/presentation/favorite_screen/widgets/favorite_list.dart';
import 'package:book/features/presentation/favorite_screen/widgets/favorite_no_items.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  bool isFirstTime = false;

  @override
  void initState() {
    super.initState();
    context.read<FavouriteBloc>().add(GetFavouriteBooksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorites'.tr(context: context),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<FavouriteBloc, FavouriteState>(
        listener: (context, state) {
          if (state is FavouriteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is FavouriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavouriteLoadedState) {
            final favorites = state.bookEntity;
            if (favorites.isEmpty) {
              const FavoriteNoItems();
            }
            return FavoriteList(
              favorites: favorites,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

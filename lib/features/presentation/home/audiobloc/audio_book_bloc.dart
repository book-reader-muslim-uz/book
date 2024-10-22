import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:book/core/usecase/usecase.dart';
import 'package:book/features/domain/entity/book_entity.dart';
import 'package:book/features/domain/usecases/get_audiobooks_usecase.dart';

part 'audio_book_event.dart';
part 'audio_book_state.dart';

class AudioBookBloc extends Bloc<AudioBookEvent, AudioBookState> {
  final GetAudiobooksUsecase getBooksUsecase;
  AudioBookBloc(
    this.getBooksUsecase,
  ) : super(AudioBookInitialState()) {
    on<GetAudioBooksEvent>(_onGetBooks);
  }

  _onGetBooks(GetAudioBooksEvent event, Emitter<AudioBookState> emit) async {
    emit(AudioBookLoadingState());
    final result = await getBooksUsecase.call(NoParams());
    result.fold(
      (l) => emit(AudioBookErrorState(errorMessage: l.toString())),
      (r) => emit(AudioBookLoadedState(books: r)),
    );
  }
}

// lib/bloc/home_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeImagesRequested extends HomeEvent {}

// States
class HomeState extends Equatable {
  const HomeState({
    this.images = const [],
    this.status = HomeStatus.initial,
  });

  final List<ImageModel> images;
  final HomeStatus status;

  HomeState copyWith({
    List<ImageModel>? images,
    HomeStatus? status,
  }) {
    return HomeState(
      images: images ?? this.images,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [images, status];
}

enum HomeStatus { initial, loading, success, failure }

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiService _apiService;

  HomeBloc(this._apiService) : super(const HomeState()) {
    on<HomeImagesRequested>(_onImagesRequested);
  }

  Future<void> _onImagesRequested(HomeImagesRequested event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final images = await _apiService.fetchImages();
      emit(state.copyWith(images: images, status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class HoverCubit extends Cubit<String?> {
//   HoverCubit() : super(null);

//   void setHoverId(String? id) => emit(id);
// }

class MapSettings extends Equatable {
  final String? hovered;
  final double zoom;

  const MapSettings(this.hovered, [this.zoom = 1]);

  MapSettings copyWith({String? hovered, double? zoom}) => MapSettings(hovered, zoom ?? this.zoom);

  @override
  List<Object?> get props => [hovered, zoom];
}

class MapSettingsCubit extends Cubit<MapSettings> {
  MapSettingsCubit() : super(const MapSettings(null));

  void setHover(String? url) => emit(state.copyWith(hovered: url));
  void setZoom(double valueToAdd) => emit(state.copyWith(zoom: state.zoom + valueToAdd));
}

class PreviewCubit extends Cubit<String?> {
  PreviewCubit() : super(null);

  void setPreview(String? url) => emit(url);
}

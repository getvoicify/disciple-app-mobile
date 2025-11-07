import 'package:dio/dio.dart';

class ChurchEntity {
  String? search;
  final String? approvalStatus;
  final String? visibility;
  final String? id;
  int? page;
  CancelToken? cancelToken;
  String? location;
  String? placeId;

  ChurchEntity({
    this.id,
    this.search,
    this.approvalStatus,
    this.visibility,
    this.page,
    this.cancelToken,
    this.location,
    this.placeId,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};

    if (search != null || search!.isNotEmpty) {
      map.addAll({'search': search});
    }

    if (approvalStatus != null) {
      map.addAll({'approvalStatus': approvalStatus});
    }

    if (visibility != null) {
      map.addAll({'visibility': visibility});
    }

    if (page != null) {
      map.addAll({'page': page});
    }

    return map;
  }

  ChurchEntity copyWith({
    String? search,
    String? approvalStatus,
    String? visibility,
    String? id,
    int? page,
    CancelToken? cancelToken,
    String? location,
    String? placeId,
  }) => ChurchEntity(
    search: search ?? this.search,
    approvalStatus: approvalStatus ?? this.approvalStatus,
    visibility: visibility ?? this.visibility,
    id: id ?? this.id,
    page: page ?? this.page,
    cancelToken: cancelToken ?? this.cancelToken,
    location: location ?? this.location,
    placeId: placeId ?? this.placeId,
  );
}

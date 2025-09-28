import 'package:dio/dio.dart';

class ChurchEntity {
  String? search;
  final String? approvalStatus;
  final String? visibility;
  final String? id;
  int? page;
  CancelToken? cancelToken;

  ChurchEntity({
    this.id,
    this.search,
    this.approvalStatus,
    this.visibility,
    this.page,
    this.cancelToken,
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
}

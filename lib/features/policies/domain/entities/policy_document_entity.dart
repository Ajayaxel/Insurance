import 'package:equatable/equatable.dart';

class PolicyDocumentEntity extends Equatable {
  final String id;
  final String name;
  final String url;
  final String? type;
  final String? uploadedAt;

  const PolicyDocumentEntity({
    required this.id,
    required this.name,
    required this.url,
    this.type,
    this.uploadedAt,
  });

  @override
  List<Object?> get props => [id, name, url, type, uploadedAt];
}

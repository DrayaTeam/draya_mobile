import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

}

 extension AuthResponseModelExtension on AuthResponseModel {
    AuthEntity toEntity() {
      return AuthEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
    }
  }

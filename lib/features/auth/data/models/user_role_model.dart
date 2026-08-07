import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_role_model.g.dart';

@JsonSerializable()
class UserRoleModel {
  String? userId;
  String? fullName;
  String? role;

  UserRoleModel({
    this.userId,
    this.fullName,
    this.role,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$UserRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleModelToJson(this);
}

extension UserRoleModelX on UserRoleModel {
  UserRoleEntity toEntity() {
    return UserRoleEntity(
      fullName: fullName ?? '',
      role: role ?? '',
    );
  }
}

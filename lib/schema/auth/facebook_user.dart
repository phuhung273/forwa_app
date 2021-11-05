import 'package:forwa_app/schema/auth/facebook_picture.dart';
import 'package:json_annotation/json_annotation.dart';

part 'facebook_user.g.dart';

// {
//   "name": "Open Graph Test User",
//   "email": "open_jygexjs_user@tfbnw.net",
//   "picture": {
//     "data": {
//       "height": 126,
//       "url": "https://scontent.fuio21-1.fna.fbcdn.net/v/t1.30497-1/s200x200/84628273_176159830277856_972693363922829312_n.jpg",
//       "width": 200
//     }
//   },
//   "id": "136742241592917"
// }
@JsonSerializable()
class FacebookUser {

  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'picture')
  FacebookPicture? picture;

  FacebookUser({
    this.id,
    this.email,
    this.name,
    this.picture,
  });

  factory FacebookUser.fromJson(Map<String, dynamic> json) =>
      _$FacebookUserFromJson(json);

  Map<String, dynamic> toJson() => _$FacebookUserToJson(this);

}
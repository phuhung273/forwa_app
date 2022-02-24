
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart';
import 'package:uuid/uuid.dart';

const GOOGLE_PLACE_TIMEOUT = 1; //In minutes

class GooglePlaceService {

  final _googlePlace = GooglePlace(dotenv.env['PLACES_API_KEY']!);

  String? _sessionToken;

  RestartableTimer? _timer;

  final uuid = const Uuid();

  /// These param are intended to be used in this class only
  /// Don't use these outside
  String? _placeId;
  DetailsResponse? _details;

  Future<List<AutocompletePrediction>?> getSuggestions(String address) async {
    debugPrint('*** Google Place Service ***: Get autocomplete');
    final results = await _googlePlace.autocomplete.get(
      address,
      sessionToken: _getOrCreateToken(),
      language: dotenv.env['PLACES_API_PREFERRED_LANGUAGE'],
      components: [Component('country', 'vn')],
    );

    if(_timer == null){
      _timer = RestartableTimer(
        const Duration(minutes: GOOGLE_PLACE_TIMEOUT),
        timeoutAndCallDetailsApi
      );
    } else {
      if(!_timer!.isActive){
        _timer!.reset();
      }
    }

    final suggestions = results?.predictions;

    if(suggestions == null) return null;

    if(suggestions.isNotEmpty){
      _placeId = suggestions.first.placeId;
    }
    debugPrint('*** Google Place Service ***: Get ${suggestions.length} suggestions for $address');

    return suggestions;
  }

  Future<DetailsResponse?> selectSuggestion(AutocompletePrediction suggestion) async {
    debugPrint('*** Google Place Service ***: Select suggestion and call Details API');
    _placeId = suggestion.placeId;
    _details = await getDetailsApi();

    if(_details != null){
      _eraseToken();
      _timer?.cancel();
    }

    return _details;
  }

  timeoutAndCallDetailsApi() async {
    debugPrint('*** Google Place Service ***: Timeout - call Details API');
    getDetailsApi();
  }

  Future<DetailsResponse?> getDetailsApi() async {
    if(_placeId == null) return null;

    final details = await _googlePlace.details.get(
      _placeId!,
      sessionToken: _getOrCreateToken(),
      fields: 'formatted_address,adr_address,name,geometry',
      language: dotenv.env['PLACES_API_PREFERRED_LANGUAGE'],
    );
    debugPrint('*** Google Place Service ***: Call Details API for placeId: $_placeId');

    _eraseToken();

    return details;
  }

  _getOrCreateToken(){
    if(_sessionToken == null){
      _sessionToken = uuid.v4();
      debugPrint('*** Google Place Service ***: New token - $_sessionToken');
    } else {
      debugPrint('*** Google Place Service ***: Reuse token - $_sessionToken');
    }

    return _sessionToken;
  }

  _eraseToken(){
    _sessionToken = null;
  }
}
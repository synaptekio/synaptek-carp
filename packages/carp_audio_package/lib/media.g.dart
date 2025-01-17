// GENERATED CODE - DO NOT MODIFY BY HAND

part of media;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDatum _$MediaDatumFromJson(Map<String, dynamic> json) => MediaDatum(
      filename: json['filename'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['media_type']),
      startRecordingTime: json['start_recording_time'] == null
          ? null
          : DateTime.parse(json['start_recording_time'] as String),
      endRecordingTime: json['end_recording_time'] == null
          ? null
          : DateTime.parse(json['end_recording_time'] as String),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..upload = json['upload'] as bool
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$MediaDatumToJson(MediaDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['filename'] = instance.filename;
  val['upload'] = instance.upload;
  writeNotNull('metadata', instance.metadata);
  val['media_type'] = _$MediaTypeEnumMap[instance.mediaType]!;
  writeNotNull(
      'start_recording_time', instance.startRecordingTime?.toIso8601String());
  writeNotNull(
      'end_recording_time', instance.endRecordingTime?.toIso8601String());
  return val;
}

const _$MediaTypeEnumMap = {
  MediaType.audio: 'audio',
  MediaType.video: 'video',
  MediaType.image: 'image',
};

NoiseDatum _$NoiseDatumFromJson(Map<String, dynamic> json) => NoiseDatum(
      meanDecibel: (json['mean_decibel'] as num).toDouble(),
      stdDecibel: (json['std_decibel'] as num).toDouble(),
      minDecibel: (json['min_decibel'] as num).toDouble(),
      maxDecibel: (json['max_decibel'] as num).toDouble(),
    )
      ..id = json['id'] as String?
      ..timestamp = DateTime.parse(json['timestamp'] as String);

Map<String, dynamic> _$NoiseDatumToJson(NoiseDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['timestamp'] = instance.timestamp.toIso8601String();
  val['mean_decibel'] = instance.meanDecibel;
  val['std_decibel'] = instance.stdDecibel;
  val['min_decibel'] = instance.minDecibel;
  val['max_decibel'] = instance.maxDecibel;
  return val;
}

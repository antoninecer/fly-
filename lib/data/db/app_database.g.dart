// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toNameMeta = const VerificationMeta('toName');
  @override
  late final GeneratedColumn<String> toName = GeneratedColumn<String>(
    'to_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromLatMeta = const VerificationMeta(
    'fromLat',
  );
  @override
  late final GeneratedColumn<double> fromLat = GeneratedColumn<double>(
    'from_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromLonMeta = const VerificationMeta(
    'fromLon',
  );
  @override
  late final GeneratedColumn<double> fromLon = GeneratedColumn<double>(
    'from_lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toLatMeta = const VerificationMeta('toLat');
  @override
  late final GeneratedColumn<double> toLat = GeneratedColumn<double>(
    'to_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toLonMeta = const VerificationMeta('toLon');
  @override
  late final GeneratedColumn<double> toLon = GeneratedColumn<double>(
    'to_lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    title,
    fromName,
    toName,
    fromLat,
    fromLon,
    toLat,
    toLon,
    startedAt,
    endedAt,
    durationSec,
    distanceKm,
    isActive,
    sourceType,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    }
    if (data.containsKey('to_name')) {
      context.handle(
        _toNameMeta,
        toName.isAcceptableOrUnknown(data['to_name']!, _toNameMeta),
      );
    }
    if (data.containsKey('from_lat')) {
      context.handle(
        _fromLatMeta,
        fromLat.isAcceptableOrUnknown(data['from_lat']!, _fromLatMeta),
      );
    }
    if (data.containsKey('from_lon')) {
      context.handle(
        _fromLonMeta,
        fromLon.isAcceptableOrUnknown(data['from_lon']!, _fromLonMeta),
      );
    }
    if (data.containsKey('to_lat')) {
      context.handle(
        _toLatMeta,
        toLat.isAcceptableOrUnknown(data['to_lat']!, _toLatMeta),
      );
    }
    if (data.containsKey('to_lon')) {
      context.handle(
        _toLonMeta,
        toLon.isAcceptableOrUnknown(data['to_lon']!, _toLonMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      ),
      toName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_name'],
      ),
      fromLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_lat'],
      ),
      fromLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}from_lon'],
      ),
      toLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_lat'],
      ),
      toLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}to_lon'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      )!,
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String type;
  final String title;
  final String? fromName;
  final String? toName;
  final double? fromLat;
  final double? fromLon;
  final double? toLat;
  final double? toLon;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSec;
  final double distanceKm;
  final bool isActive;
  final String sourceType;
  final String? notes;
  const Session({
    required this.id,
    required this.type,
    required this.title,
    this.fromName,
    this.toName,
    this.fromLat,
    this.fromLon,
    this.toLat,
    this.toLon,
    required this.startedAt,
    this.endedAt,
    required this.durationSec,
    required this.distanceKm,
    required this.isActive,
    required this.sourceType,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || fromName != null) {
      map['from_name'] = Variable<String>(fromName);
    }
    if (!nullToAbsent || toName != null) {
      map['to_name'] = Variable<String>(toName);
    }
    if (!nullToAbsent || fromLat != null) {
      map['from_lat'] = Variable<double>(fromLat);
    }
    if (!nullToAbsent || fromLon != null) {
      map['from_lon'] = Variable<double>(fromLon);
    }
    if (!nullToAbsent || toLat != null) {
      map['to_lat'] = Variable<double>(toLat);
    }
    if (!nullToAbsent || toLon != null) {
      map['to_lon'] = Variable<double>(toLon);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['duration_sec'] = Variable<int>(durationSec);
    map['distance_km'] = Variable<double>(distanceKm);
    map['is_active'] = Variable<bool>(isActive);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      fromName: fromName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromName),
      toName: toName == null && nullToAbsent
          ? const Value.absent()
          : Value(toName),
      fromLat: fromLat == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLat),
      fromLon: fromLon == null && nullToAbsent
          ? const Value.absent()
          : Value(fromLon),
      toLat: toLat == null && nullToAbsent
          ? const Value.absent()
          : Value(toLat),
      toLon: toLon == null && nullToAbsent
          ? const Value.absent()
          : Value(toLon),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSec: Value(durationSec),
      distanceKm: Value(distanceKm),
      isActive: Value(isActive),
      sourceType: Value(sourceType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      fromName: serializer.fromJson<String?>(json['fromName']),
      toName: serializer.fromJson<String?>(json['toName']),
      fromLat: serializer.fromJson<double?>(json['fromLat']),
      fromLon: serializer.fromJson<double?>(json['fromLon']),
      toLat: serializer.fromJson<double?>(json['toLat']),
      toLon: serializer.fromJson<double?>(json['toLon']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'fromName': serializer.toJson<String?>(fromName),
      'toName': serializer.toJson<String?>(toName),
      'fromLat': serializer.toJson<double?>(fromLat),
      'fromLon': serializer.toJson<double?>(fromLon),
      'toLat': serializer.toJson<double?>(toLat),
      'toLon': serializer.toJson<double?>(toLon),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSec': serializer.toJson<int>(durationSec),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'isActive': serializer.toJson<bool>(isActive),
      'sourceType': serializer.toJson<String>(sourceType),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Session copyWith({
    String? id,
    String? type,
    String? title,
    Value<String?> fromName = const Value.absent(),
    Value<String?> toName = const Value.absent(),
    Value<double?> fromLat = const Value.absent(),
    Value<double?> fromLon = const Value.absent(),
    Value<double?> toLat = const Value.absent(),
    Value<double?> toLon = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? durationSec,
    double? distanceKm,
    bool? isActive,
    String? sourceType,
    Value<String?> notes = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    fromName: fromName.present ? fromName.value : this.fromName,
    toName: toName.present ? toName.value : this.toName,
    fromLat: fromLat.present ? fromLat.value : this.fromLat,
    fromLon: fromLon.present ? fromLon.value : this.fromLon,
    toLat: toLat.present ? toLat.value : this.toLat,
    toLon: toLon.present ? toLon.value : this.toLon,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSec: durationSec ?? this.durationSec,
    distanceKm: distanceKm ?? this.distanceKm,
    isActive: isActive ?? this.isActive,
    sourceType: sourceType ?? this.sourceType,
    notes: notes.present ? notes.value : this.notes,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      toName: data.toName.present ? data.toName.value : this.toName,
      fromLat: data.fromLat.present ? data.fromLat.value : this.fromLat,
      fromLon: data.fromLon.present ? data.fromLon.value : this.fromLon,
      toLat: data.toLat.present ? data.toLat.value : this.toLat,
      toLon: data.toLon.present ? data.toLon.value : this.toLon,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('fromName: $fromName, ')
          ..write('toName: $toName, ')
          ..write('fromLat: $fromLat, ')
          ..write('fromLon: $fromLon, ')
          ..write('toLat: $toLat, ')
          ..write('toLon: $toLon, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('isActive: $isActive, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    fromName,
    toName,
    fromLat,
    fromLon,
    toLat,
    toLon,
    startedAt,
    endedAt,
    durationSec,
    distanceKm,
    isActive,
    sourceType,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.fromName == this.fromName &&
          other.toName == this.toName &&
          other.fromLat == this.fromLat &&
          other.fromLon == this.fromLon &&
          other.toLat == this.toLat &&
          other.toLon == this.toLon &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSec == this.durationSec &&
          other.distanceKm == this.distanceKm &&
          other.isActive == this.isActive &&
          other.sourceType == this.sourceType &&
          other.notes == this.notes);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> title;
  final Value<String?> fromName;
  final Value<String?> toName;
  final Value<double?> fromLat;
  final Value<double?> fromLon;
  final Value<double?> toLat;
  final Value<double?> toLon;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> durationSec;
  final Value<double> distanceKm;
  final Value<bool> isActive;
  final Value<String> sourceType;
  final Value<String?> notes;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.fromName = const Value.absent(),
    this.toName = const Value.absent(),
    this.fromLat = const Value.absent(),
    this.fromLon = const Value.absent(),
    this.toLat = const Value.absent(),
    this.toLon = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String type,
    required String title,
    this.fromName = const Value.absent(),
    this.toName = const Value.absent(),
    this.fromLat = const Value.absent(),
    this.fromLon = const Value.absent(),
    this.toLat = const Value.absent(),
    this.toLon = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.isActive = const Value.absent(),
    required String sourceType,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       title = Value(title),
       startedAt = Value(startedAt),
       sourceType = Value(sourceType);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? fromName,
    Expression<String>? toName,
    Expression<double>? fromLat,
    Expression<double>? fromLon,
    Expression<double>? toLat,
    Expression<double>? toLon,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSec,
    Expression<double>? distanceKm,
    Expression<bool>? isActive,
    Expression<String>? sourceType,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (fromName != null) 'from_name': fromName,
      if (toName != null) 'to_name': toName,
      if (fromLat != null) 'from_lat': fromLat,
      if (fromLon != null) 'from_lon': fromLon,
      if (toLat != null) 'to_lat': toLat,
      if (toLon != null) 'to_lon': toLon,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSec != null) 'duration_sec': durationSec,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (isActive != null) 'is_active': isActive,
      if (sourceType != null) 'source_type': sourceType,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? title,
    Value<String?>? fromName,
    Value<String?>? toName,
    Value<double?>? fromLat,
    Value<double?>? fromLon,
    Value<double?>? toLat,
    Value<double?>? toLon,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? durationSec,
    Value<double>? distanceKm,
    Value<bool>? isActive,
    Value<String>? sourceType,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      fromName: fromName ?? this.fromName,
      toName: toName ?? this.toName,
      fromLat: fromLat ?? this.fromLat,
      fromLon: fromLon ?? this.fromLon,
      toLat: toLat ?? this.toLat,
      toLon: toLon ?? this.toLon,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSec: durationSec ?? this.durationSec,
      distanceKm: distanceKm ?? this.distanceKm,
      isActive: isActive ?? this.isActive,
      sourceType: sourceType ?? this.sourceType,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (toName.present) {
      map['to_name'] = Variable<String>(toName.value);
    }
    if (fromLat.present) {
      map['from_lat'] = Variable<double>(fromLat.value);
    }
    if (fromLon.present) {
      map['from_lon'] = Variable<double>(fromLon.value);
    }
    if (toLat.present) {
      map['to_lat'] = Variable<double>(toLat.value);
    }
    if (toLon.present) {
      map['to_lon'] = Variable<double>(toLon.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('fromName: $fromName, ')
          ..write('toName: $toName, ')
          ..write('fromLat: $fromLat, ')
          ..write('fromLon: $fromLon, ')
          ..write('toLat: $toLat, ')
          ..write('toLon: $toLon, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('isActive: $isActive, ')
          ..write('sourceType: $sourceType, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altMetersMeta = const VerificationMeta(
    'altMeters',
  );
  @override
  late final GeneratedColumn<double> altMeters = GeneratedColumn<double>(
    'alt_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headingDegMeta = const VerificationMeta(
    'headingDeg',
  );
  @override
  late final GeneratedColumn<double> headingDeg = GeneratedColumn<double>(
    'heading_deg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    timestamp,
    lat,
    lon,
    altMeters,
    speedKmh,
    headingDeg,
    phase,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('alt_meters')) {
      context.handle(
        _altMetersMeta,
        altMeters.isAcceptableOrUnknown(data['alt_meters']!, _altMetersMeta),
      );
    } else if (isInserting) {
      context.missing(_altMetersMeta);
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    } else if (isInserting) {
      context.missing(_speedKmhMeta);
    }
    if (data.containsKey('heading_deg')) {
      context.handle(
        _headingDegMeta,
        headingDeg.isAcceptableOrUnknown(data['heading_deg']!, _headingDegMeta),
      );
    } else if (isInserting) {
      context.missing(_headingDegMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      altMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alt_meters'],
      )!,
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      )!,
      headingDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading_deg'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      ),
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPoint extends DataClass implements Insertable<TrackPoint> {
  final int id;
  final String sessionId;
  final DateTime timestamp;
  final double lat;
  final double lon;
  final double altMeters;
  final double speedKmh;
  final double headingDeg;
  final String? phase;
  const TrackPoint({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.lat,
    required this.lon,
    required this.altMeters,
    required this.speedKmh,
    required this.headingDeg,
    this.phase,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    map['alt_meters'] = Variable<double>(altMeters);
    map['speed_kmh'] = Variable<double>(speedKmh);
    map['heading_deg'] = Variable<double>(headingDeg);
    if (!nullToAbsent || phase != null) {
      map['phase'] = Variable<String>(phase);
    }
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      timestamp: Value(timestamp),
      lat: Value(lat),
      lon: Value(lon),
      altMeters: Value(altMeters),
      speedKmh: Value(speedKmh),
      headingDeg: Value(headingDeg),
      phase: phase == null && nullToAbsent
          ? const Value.absent()
          : Value(phase),
    );
  }

  factory TrackPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPoint(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      altMeters: serializer.fromJson<double>(json['altMeters']),
      speedKmh: serializer.fromJson<double>(json['speedKmh']),
      headingDeg: serializer.fromJson<double>(json['headingDeg']),
      phase: serializer.fromJson<String?>(json['phase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'altMeters': serializer.toJson<double>(altMeters),
      'speedKmh': serializer.toJson<double>(speedKmh),
      'headingDeg': serializer.toJson<double>(headingDeg),
      'phase': serializer.toJson<String?>(phase),
    };
  }

  TrackPoint copyWith({
    int? id,
    String? sessionId,
    DateTime? timestamp,
    double? lat,
    double? lon,
    double? altMeters,
    double? speedKmh,
    double? headingDeg,
    Value<String?> phase = const Value.absent(),
  }) => TrackPoint(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    timestamp: timestamp ?? this.timestamp,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    altMeters: altMeters ?? this.altMeters,
    speedKmh: speedKmh ?? this.speedKmh,
    headingDeg: headingDeg ?? this.headingDeg,
    phase: phase.present ? phase.value : this.phase,
  );
  TrackPoint copyWithCompanion(TrackPointsCompanion data) {
    return TrackPoint(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      altMeters: data.altMeters.present ? data.altMeters.value : this.altMeters,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      headingDeg: data.headingDeg.present
          ? data.headingDeg.value
          : this.headingDeg,
      phase: data.phase.present ? data.phase.value : this.phase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPoint(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('altMeters: $altMeters, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('phase: $phase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    timestamp,
    lat,
    lon,
    altMeters,
    speedKmh,
    headingDeg,
    phase,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPoint &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.timestamp == this.timestamp &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.altMeters == this.altMeters &&
          other.speedKmh == this.speedKmh &&
          other.headingDeg == this.headingDeg &&
          other.phase == this.phase);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPoint> {
  final Value<int> id;
  final Value<String> sessionId;
  final Value<DateTime> timestamp;
  final Value<double> lat;
  final Value<double> lon;
  final Value<double> altMeters;
  final Value<double> speedKmh;
  final Value<double> headingDeg;
  final Value<String?> phase;
  const TrackPointsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.altMeters = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.headingDeg = const Value.absent(),
    this.phase = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required DateTime timestamp,
    required double lat,
    required double lon,
    required double altMeters,
    required double speedKmh,
    required double headingDeg,
    this.phase = const Value.absent(),
  }) : sessionId = Value(sessionId),
       timestamp = Value(timestamp),
       lat = Value(lat),
       lon = Value(lon),
       altMeters = Value(altMeters),
       speedKmh = Value(speedKmh),
       headingDeg = Value(headingDeg);
  static Insertable<TrackPoint> custom({
    Expression<int>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? timestamp,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<double>? altMeters,
    Expression<double>? speedKmh,
    Expression<double>? headingDeg,
    Expression<String>? phase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (timestamp != null) 'timestamp': timestamp,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (altMeters != null) 'alt_meters': altMeters,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (headingDeg != null) 'heading_deg': headingDeg,
      if (phase != null) 'phase': phase,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionId,
    Value<DateTime>? timestamp,
    Value<double>? lat,
    Value<double>? lon,
    Value<double>? altMeters,
    Value<double>? speedKmh,
    Value<double>? headingDeg,
    Value<String?>? phase,
  }) {
    return TrackPointsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      altMeters: altMeters ?? this.altMeters,
      speedKmh: speedKmh ?? this.speedKmh,
      headingDeg: headingDeg ?? this.headingDeg,
      phase: phase ?? this.phase,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (altMeters.present) {
      map['alt_meters'] = Variable<double>(altMeters.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (headingDeg.present) {
      map['heading_deg'] = Variable<double>(headingDeg.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('timestamp: $timestamp, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('altMeters: $altMeters, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('headingDeg: $headingDeg, ')
          ..write('phase: $phase')
          ..write(')'))
        .toString();
  }
}

class $PlaybackStatesTable extends PlaybackStates
    with TableInfo<$PlaybackStatesTable, PlaybackState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _currentTimeSecMeta = const VerificationMeta(
    'currentTimeSec',
  );
  @override
  late final GeneratedColumn<int> currentTimeSec = GeneratedColumn<int>(
    'current_time_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMultiplierMeta = const VerificationMeta(
    'speedMultiplier',
  );
  @override
  late final GeneratedColumn<double> speedMultiplier = GeneratedColumn<double>(
    'speed_multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _isPlayingMeta = const VerificationMeta(
    'isPlaying',
  );
  @override
  late final GeneratedColumn<bool> isPlaying = GeneratedColumn<bool>(
    'is_playing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_playing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    currentTimeSec,
    speedMultiplier,
    isPlaying,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('current_time_sec')) {
      context.handle(
        _currentTimeSecMeta,
        currentTimeSec.isAcceptableOrUnknown(
          data['current_time_sec']!,
          _currentTimeSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentTimeSecMeta);
    }
    if (data.containsKey('speed_multiplier')) {
      context.handle(
        _speedMultiplierMeta,
        speedMultiplier.isAcceptableOrUnknown(
          data['speed_multiplier']!,
          _speedMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('is_playing')) {
      context.handle(
        _isPlayingMeta,
        isPlaying.isAcceptableOrUnknown(data['is_playing']!, _isPlayingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  PlaybackState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackState(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      currentTimeSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_time_sec'],
      )!,
      speedMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_multiplier'],
      )!,
      isPlaying: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_playing'],
      )!,
    );
  }

  @override
  $PlaybackStatesTable createAlias(String alias) {
    return $PlaybackStatesTable(attachedDatabase, alias);
  }
}

class PlaybackState extends DataClass implements Insertable<PlaybackState> {
  final String sessionId;
  final int currentTimeSec;
  final double speedMultiplier;
  final bool isPlaying;
  const PlaybackState({
    required this.sessionId,
    required this.currentTimeSec,
    required this.speedMultiplier,
    required this.isPlaying,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['current_time_sec'] = Variable<int>(currentTimeSec);
    map['speed_multiplier'] = Variable<double>(speedMultiplier);
    map['is_playing'] = Variable<bool>(isPlaying);
    return map;
  }

  PlaybackStatesCompanion toCompanion(bool nullToAbsent) {
    return PlaybackStatesCompanion(
      sessionId: Value(sessionId),
      currentTimeSec: Value(currentTimeSec),
      speedMultiplier: Value(speedMultiplier),
      isPlaying: Value(isPlaying),
    );
  }

  factory PlaybackState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackState(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      currentTimeSec: serializer.fromJson<int>(json['currentTimeSec']),
      speedMultiplier: serializer.fromJson<double>(json['speedMultiplier']),
      isPlaying: serializer.fromJson<bool>(json['isPlaying']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'currentTimeSec': serializer.toJson<int>(currentTimeSec),
      'speedMultiplier': serializer.toJson<double>(speedMultiplier),
      'isPlaying': serializer.toJson<bool>(isPlaying),
    };
  }

  PlaybackState copyWith({
    String? sessionId,
    int? currentTimeSec,
    double? speedMultiplier,
    bool? isPlaying,
  }) => PlaybackState(
    sessionId: sessionId ?? this.sessionId,
    currentTimeSec: currentTimeSec ?? this.currentTimeSec,
    speedMultiplier: speedMultiplier ?? this.speedMultiplier,
    isPlaying: isPlaying ?? this.isPlaying,
  );
  PlaybackState copyWithCompanion(PlaybackStatesCompanion data) {
    return PlaybackState(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      currentTimeSec: data.currentTimeSec.present
          ? data.currentTimeSec.value
          : this.currentTimeSec,
      speedMultiplier: data.speedMultiplier.present
          ? data.speedMultiplier.value
          : this.speedMultiplier,
      isPlaying: data.isPlaying.present ? data.isPlaying.value : this.isPlaying,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackState(')
          ..write('sessionId: $sessionId, ')
          ..write('currentTimeSec: $currentTimeSec, ')
          ..write('speedMultiplier: $speedMultiplier, ')
          ..write('isPlaying: $isPlaying')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, currentTimeSec, speedMultiplier, isPlaying);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackState &&
          other.sessionId == this.sessionId &&
          other.currentTimeSec == this.currentTimeSec &&
          other.speedMultiplier == this.speedMultiplier &&
          other.isPlaying == this.isPlaying);
}

class PlaybackStatesCompanion extends UpdateCompanion<PlaybackState> {
  final Value<String> sessionId;
  final Value<int> currentTimeSec;
  final Value<double> speedMultiplier;
  final Value<bool> isPlaying;
  final Value<int> rowid;
  const PlaybackStatesCompanion({
    this.sessionId = const Value.absent(),
    this.currentTimeSec = const Value.absent(),
    this.speedMultiplier = const Value.absent(),
    this.isPlaying = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackStatesCompanion.insert({
    required String sessionId,
    required int currentTimeSec,
    this.speedMultiplier = const Value.absent(),
    this.isPlaying = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       currentTimeSec = Value(currentTimeSec);
  static Insertable<PlaybackState> custom({
    Expression<String>? sessionId,
    Expression<int>? currentTimeSec,
    Expression<double>? speedMultiplier,
    Expression<bool>? isPlaying,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (currentTimeSec != null) 'current_time_sec': currentTimeSec,
      if (speedMultiplier != null) 'speed_multiplier': speedMultiplier,
      if (isPlaying != null) 'is_playing': isPlaying,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackStatesCompanion copyWith({
    Value<String>? sessionId,
    Value<int>? currentTimeSec,
    Value<double>? speedMultiplier,
    Value<bool>? isPlaying,
    Value<int>? rowid,
  }) {
    return PlaybackStatesCompanion(
      sessionId: sessionId ?? this.sessionId,
      currentTimeSec: currentTimeSec ?? this.currentTimeSec,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      isPlaying: isPlaying ?? this.isPlaying,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (currentTimeSec.present) {
      map['current_time_sec'] = Variable<int>(currentTimeSec.value);
    }
    if (speedMultiplier.present) {
      map['speed_multiplier'] = Variable<double>(speedMultiplier.value);
    }
    if (isPlaying.present) {
      map['is_playing'] = Variable<bool>(isPlaying.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackStatesCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('currentTimeSec: $currentTimeSec, ')
          ..write('speedMultiplier: $speedMultiplier, ')
          ..write('isPlaying: $isPlaying, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MapPackagesTable extends MapPackages
    with TableInfo<$MapPackagesTable, MapPackage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MapPackagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minZoomMeta = const VerificationMeta(
    'minZoom',
  );
  @override
  late final GeneratedColumn<int> minZoom = GeneratedColumn<int>(
    'min_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxZoomMeta = const VerificationMeta(
    'maxZoom',
  );
  @override
  late final GeneratedColumn<int> maxZoom = GeneratedColumn<int>(
    'max_zoom',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isFallbackMeta = const VerificationMeta(
    'isFallback',
  );
  @override
  late final GeneratedColumn<bool> isFallback = GeneratedColumn<bool>(
    'is_fallback',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_fallback" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fileName,
    minZoom,
    maxZoom,
    priority,
    isFallback,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'map_packages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MapPackage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('min_zoom')) {
      context.handle(
        _minZoomMeta,
        minZoom.isAcceptableOrUnknown(data['min_zoom']!, _minZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_minZoomMeta);
    }
    if (data.containsKey('max_zoom')) {
      context.handle(
        _maxZoomMeta,
        maxZoom.isAcceptableOrUnknown(data['max_zoom']!, _maxZoomMeta),
      );
    } else if (isInserting) {
      context.missing(_maxZoomMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_fallback')) {
      context.handle(
        _isFallbackMeta,
        isFallback.isAcceptableOrUnknown(data['is_fallback']!, _isFallbackMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MapPackage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MapPackage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      minZoom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_zoom'],
      )!,
      maxZoom: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_zoom'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isFallback: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_fallback'],
      )!,
    );
  }

  @override
  $MapPackagesTable createAlias(String alias) {
    return $MapPackagesTable(attachedDatabase, alias);
  }
}

class MapPackage extends DataClass implements Insertable<MapPackage> {
  final String id;
  final String name;
  final String fileName;
  final int minZoom;
  final int maxZoom;
  final int priority;
  final bool isFallback;
  const MapPackage({
    required this.id,
    required this.name,
    required this.fileName,
    required this.minZoom,
    required this.maxZoom,
    required this.priority,
    required this.isFallback,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['file_name'] = Variable<String>(fileName);
    map['min_zoom'] = Variable<int>(minZoom);
    map['max_zoom'] = Variable<int>(maxZoom);
    map['priority'] = Variable<int>(priority);
    map['is_fallback'] = Variable<bool>(isFallback);
    return map;
  }

  MapPackagesCompanion toCompanion(bool nullToAbsent) {
    return MapPackagesCompanion(
      id: Value(id),
      name: Value(name),
      fileName: Value(fileName),
      minZoom: Value(minZoom),
      maxZoom: Value(maxZoom),
      priority: Value(priority),
      isFallback: Value(isFallback),
    );
  }

  factory MapPackage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MapPackage(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fileName: serializer.fromJson<String>(json['fileName']),
      minZoom: serializer.fromJson<int>(json['minZoom']),
      maxZoom: serializer.fromJson<int>(json['maxZoom']),
      priority: serializer.fromJson<int>(json['priority']),
      isFallback: serializer.fromJson<bool>(json['isFallback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'fileName': serializer.toJson<String>(fileName),
      'minZoom': serializer.toJson<int>(minZoom),
      'maxZoom': serializer.toJson<int>(maxZoom),
      'priority': serializer.toJson<int>(priority),
      'isFallback': serializer.toJson<bool>(isFallback),
    };
  }

  MapPackage copyWith({
    String? id,
    String? name,
    String? fileName,
    int? minZoom,
    int? maxZoom,
    int? priority,
    bool? isFallback,
  }) => MapPackage(
    id: id ?? this.id,
    name: name ?? this.name,
    fileName: fileName ?? this.fileName,
    minZoom: minZoom ?? this.minZoom,
    maxZoom: maxZoom ?? this.maxZoom,
    priority: priority ?? this.priority,
    isFallback: isFallback ?? this.isFallback,
  );
  MapPackage copyWithCompanion(MapPackagesCompanion data) {
    return MapPackage(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      minZoom: data.minZoom.present ? data.minZoom.value : this.minZoom,
      maxZoom: data.maxZoom.present ? data.maxZoom.value : this.maxZoom,
      priority: data.priority.present ? data.priority.value : this.priority,
      isFallback: data.isFallback.present
          ? data.isFallback.value
          : this.isFallback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MapPackage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('priority: $priority, ')
          ..write('isFallback: $isFallback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, fileName, minZoom, maxZoom, priority, isFallback);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MapPackage &&
          other.id == this.id &&
          other.name == this.name &&
          other.fileName == this.fileName &&
          other.minZoom == this.minZoom &&
          other.maxZoom == this.maxZoom &&
          other.priority == this.priority &&
          other.isFallback == this.isFallback);
}

class MapPackagesCompanion extends UpdateCompanion<MapPackage> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> fileName;
  final Value<int> minZoom;
  final Value<int> maxZoom;
  final Value<int> priority;
  final Value<bool> isFallback;
  final Value<int> rowid;
  const MapPackagesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fileName = const Value.absent(),
    this.minZoom = const Value.absent(),
    this.maxZoom = const Value.absent(),
    this.priority = const Value.absent(),
    this.isFallback = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MapPackagesCompanion.insert({
    required String id,
    required String name,
    required String fileName,
    required int minZoom,
    required int maxZoom,
    this.priority = const Value.absent(),
    this.isFallback = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       fileName = Value(fileName),
       minZoom = Value(minZoom),
       maxZoom = Value(maxZoom);
  static Insertable<MapPackage> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? fileName,
    Expression<int>? minZoom,
    Expression<int>? maxZoom,
    Expression<int>? priority,
    Expression<bool>? isFallback,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fileName != null) 'file_name': fileName,
      if (minZoom != null) 'min_zoom': minZoom,
      if (maxZoom != null) 'max_zoom': maxZoom,
      if (priority != null) 'priority': priority,
      if (isFallback != null) 'is_fallback': isFallback,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MapPackagesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? fileName,
    Value<int>? minZoom,
    Value<int>? maxZoom,
    Value<int>? priority,
    Value<bool>? isFallback,
    Value<int>? rowid,
  }) {
    return MapPackagesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      priority: priority ?? this.priority,
      isFallback: isFallback ?? this.isFallback,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (minZoom.present) {
      map['min_zoom'] = Variable<int>(minZoom.value);
    }
    if (maxZoom.present) {
      map['max_zoom'] = Variable<int>(maxZoom.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isFallback.present) {
      map['is_fallback'] = Variable<bool>(isFallback.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MapPackagesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('minZoom: $minZoom, ')
          ..write('maxZoom: $maxZoom, ')
          ..write('priority: $priority, ')
          ..write('isFallback: $isFallback, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $PlaybackStatesTable playbackStates = $PlaybackStatesTable(this);
  late final $MapPackagesTable mapPackages = $MapPackagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    trackPoints,
    playbackStates,
    mapPackages,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String type,
      required String title,
      Value<String?> fromName,
      Value<String?> toName,
      Value<double?> fromLat,
      Value<double?> fromLon,
      Value<double?> toLat,
      Value<double?> toLon,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSec,
      Value<double> distanceKm,
      Value<bool> isActive,
      required String sourceType,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> title,
      Value<String?> fromName,
      Value<String?> toName,
      Value<double?> fromLat,
      Value<double?> fromLon,
      Value<double?> toLat,
      Value<double?> toLon,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> durationSec,
      Value<double> distanceKm,
      Value<bool> isActive,
      Value<String> sourceType,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TrackPointsTable, List<TrackPoint>>
  _trackPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackPoints,
    aliasName: $_aliasNameGenerator(db.sessions.id, db.trackPoints.sessionId),
  );

  $$TrackPointsTableProcessedTableManager get trackPointsRefs {
    final manager = $$TrackPointsTableTableManager(
      $_db,
      $_db.trackPoints,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlaybackStatesTable, List<PlaybackState>>
  _playbackStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playbackStates,
    aliasName: $_aliasNameGenerator(
      db.sessions.id,
      db.playbackStates.sessionId,
    ),
  );

  $$PlaybackStatesTableProcessedTableManager get playbackStatesRefs {
    final manager = $$PlaybackStatesTableTableManager(
      $_db,
      $_db.playbackStates,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_playbackStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromLat => $composableBuilder(
    column: $table.fromLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fromLon => $composableBuilder(
    column: $table.fromLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toLat => $composableBuilder(
    column: $table.toLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toLon => $composableBuilder(
    column: $table.toLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trackPointsRefs(
    Expression<bool> Function($$TrackPointsTableFilterComposer f) f,
  ) {
    final $$TrackPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableFilterComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> playbackStatesRefs(
    Expression<bool> Function($$PlaybackStatesTableFilterComposer f) f,
  ) {
    final $$PlaybackStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackStates,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackStatesTableFilterComposer(
            $db: $db,
            $table: $db.playbackStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromLat => $composableBuilder(
    column: $table.fromLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fromLon => $composableBuilder(
    column: $table.fromLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toLat => $composableBuilder(
    column: $table.toLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toLon => $composableBuilder(
    column: $table.toLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<String> get toName =>
      $composableBuilder(column: $table.toName, builder: (column) => column);

  GeneratedColumn<double> get fromLat =>
      $composableBuilder(column: $table.fromLat, builder: (column) => column);

  GeneratedColumn<double> get fromLon =>
      $composableBuilder(column: $table.fromLon, builder: (column) => column);

  GeneratedColumn<double> get toLat =>
      $composableBuilder(column: $table.toLat, builder: (column) => column);

  GeneratedColumn<double> get toLon =>
      $composableBuilder(column: $table.toLon, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> trackPointsRefs<T extends Object>(
    Expression<T> Function($$TrackPointsTableAnnotationComposer a) f,
  ) {
    final $$TrackPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> playbackStatesRefs<T extends Object>(
    Expression<T> Function($$PlaybackStatesTableAnnotationComposer a) f,
  ) {
    final $$PlaybackStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playbackStates,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlaybackStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.playbackStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool trackPointsRefs,
            bool playbackStatesRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> fromName = const Value.absent(),
                Value<String?> toName = const Value.absent(),
                Value<double?> fromLat = const Value.absent(),
                Value<double?> fromLon = const Value.absent(),
                Value<double?> toLat = const Value.absent(),
                Value<double?> toLon = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                type: type,
                title: title,
                fromName: fromName,
                toName: toName,
                fromLat: fromLat,
                fromLon: fromLon,
                toLat: toLat,
                toLon: toLon,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSec: durationSec,
                distanceKm: distanceKm,
                isActive: isActive,
                sourceType: sourceType,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String title,
                Value<String?> fromName = const Value.absent(),
                Value<String?> toName = const Value.absent(),
                Value<double?> fromLat = const Value.absent(),
                Value<double?> fromLon = const Value.absent(),
                Value<double?> toLat = const Value.absent(),
                Value<double?> toLon = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationSec = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required String sourceType,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                type: type,
                title: title,
                fromName: fromName,
                toName: toName,
                fromLat: fromLat,
                fromLon: fromLon,
                toLat: toLat,
                toLon: toLon,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSec: durationSec,
                distanceKm: distanceKm,
                isActive: isActive,
                sourceType: sourceType,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({trackPointsRefs = false, playbackStatesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (trackPointsRefs) db.trackPoints,
                    if (playbackStatesRefs) db.playbackStates,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (trackPointsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          TrackPoint
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._trackPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).trackPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (playbackStatesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          PlaybackState
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._playbackStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).playbackStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool trackPointsRefs, bool playbackStatesRefs})
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      required String sessionId,
      required DateTime timestamp,
      required double lat,
      required double lon,
      required double altMeters,
      required double speedKmh,
      required double headingDeg,
      Value<String?> phase,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      Value<String> sessionId,
      Value<DateTime> timestamp,
      Value<double> lat,
      Value<double> lon,
      Value<double> altMeters,
      Value<double> speedKmh,
      Value<double> headingDeg,
      Value<String?> phase,
    });

final class $$TrackPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPoint> {
  $$TrackPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.trackPoints.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altMeters => $composableBuilder(
    column: $table.altMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altMeters => $composableBuilder(
    column: $table.altMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<double> get altMeters =>
      $composableBuilder(column: $table.altMeters, builder: (column) => column);

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get headingDeg => $composableBuilder(
    column: $table.headingDeg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPoint,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (TrackPoint, $$TrackPointsTableReferences),
          TrackPoint,
          PrefetchHooks Function({bool sessionId})
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<double> altMeters = const Value.absent(),
                Value<double> speedKmh = const Value.absent(),
                Value<double> headingDeg = const Value.absent(),
                Value<String?> phase = const Value.absent(),
              }) => TrackPointsCompanion(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                lat: lat,
                lon: lon,
                altMeters: altMeters,
                speedKmh: speedKmh,
                headingDeg: headingDeg,
                phase: phase,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionId,
                required DateTime timestamp,
                required double lat,
                required double lon,
                required double altMeters,
                required double speedKmh,
                required double headingDeg,
                Value<String?> phase = const Value.absent(),
              }) => TrackPointsCompanion.insert(
                id: id,
                sessionId: sessionId,
                timestamp: timestamp,
                lat: lat,
                lon: lon,
                altMeters: altMeters,
                speedKmh: speedKmh,
                headingDeg: headingDeg,
                phase: phase,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$TrackPointsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$TrackPointsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPoint,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (TrackPoint, $$TrackPointsTableReferences),
      TrackPoint,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$PlaybackStatesTableCreateCompanionBuilder =
    PlaybackStatesCompanion Function({
      required String sessionId,
      required int currentTimeSec,
      Value<double> speedMultiplier,
      Value<bool> isPlaying,
      Value<int> rowid,
    });
typedef $$PlaybackStatesTableUpdateCompanionBuilder =
    PlaybackStatesCompanion Function({
      Value<String> sessionId,
      Value<int> currentTimeSec,
      Value<double> speedMultiplier,
      Value<bool> isPlaying,
      Value<int> rowid,
    });

final class $$PlaybackStatesTableReferences
    extends BaseReferences<_$AppDatabase, $PlaybackStatesTable, PlaybackState> {
  $$PlaybackStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.playbackStates.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlaybackStatesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get currentTimeSec => $composableBuilder(
    column: $table.currentTimeSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMultiplier => $composableBuilder(
    column: $table.speedMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPlaying => $composableBuilder(
    column: $table.isPlaying,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get currentTimeSec => $composableBuilder(
    column: $table.currentTimeSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMultiplier => $composableBuilder(
    column: $table.speedMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPlaying => $composableBuilder(
    column: $table.isPlaying,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackStatesTable> {
  $$PlaybackStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get currentTimeSec => $composableBuilder(
    column: $table.currentTimeSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedMultiplier => $composableBuilder(
    column: $table.speedMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPlaying =>
      $composableBuilder(column: $table.isPlaying, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlaybackStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackStatesTable,
          PlaybackState,
          $$PlaybackStatesTableFilterComposer,
          $$PlaybackStatesTableOrderingComposer,
          $$PlaybackStatesTableAnnotationComposer,
          $$PlaybackStatesTableCreateCompanionBuilder,
          $$PlaybackStatesTableUpdateCompanionBuilder,
          (PlaybackState, $$PlaybackStatesTableReferences),
          PlaybackState,
          PrefetchHooks Function({bool sessionId})
        > {
  $$PlaybackStatesTableTableManager(
    _$AppDatabase db,
    $PlaybackStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaybackStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaybackStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<int> currentTimeSec = const Value.absent(),
                Value<double> speedMultiplier = const Value.absent(),
                Value<bool> isPlaying = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackStatesCompanion(
                sessionId: sessionId,
                currentTimeSec: currentTimeSec,
                speedMultiplier: speedMultiplier,
                isPlaying: isPlaying,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required int currentTimeSec,
                Value<double> speedMultiplier = const Value.absent(),
                Value<bool> isPlaying = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackStatesCompanion.insert(
                sessionId: sessionId,
                currentTimeSec: currentTimeSec,
                speedMultiplier: speedMultiplier,
                isPlaying: isPlaying,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlaybackStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$PlaybackStatesTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn:
                                    $$PlaybackStatesTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlaybackStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackStatesTable,
      PlaybackState,
      $$PlaybackStatesTableFilterComposer,
      $$PlaybackStatesTableOrderingComposer,
      $$PlaybackStatesTableAnnotationComposer,
      $$PlaybackStatesTableCreateCompanionBuilder,
      $$PlaybackStatesTableUpdateCompanionBuilder,
      (PlaybackState, $$PlaybackStatesTableReferences),
      PlaybackState,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$MapPackagesTableCreateCompanionBuilder =
    MapPackagesCompanion Function({
      required String id,
      required String name,
      required String fileName,
      required int minZoom,
      required int maxZoom,
      Value<int> priority,
      Value<bool> isFallback,
      Value<int> rowid,
    });
typedef $$MapPackagesTableUpdateCompanionBuilder =
    MapPackagesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> fileName,
      Value<int> minZoom,
      Value<int> maxZoom,
      Value<int> priority,
      Value<bool> isFallback,
      Value<int> rowid,
    });

class $$MapPackagesTableFilterComposer
    extends Composer<_$AppDatabase, $MapPackagesTable> {
  $$MapPackagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFallback => $composableBuilder(
    column: $table.isFallback,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MapPackagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MapPackagesTable> {
  $$MapPackagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minZoom => $composableBuilder(
    column: $table.minZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxZoom => $composableBuilder(
    column: $table.maxZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFallback => $composableBuilder(
    column: $table.isFallback,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MapPackagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MapPackagesTable> {
  $$MapPackagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get minZoom =>
      $composableBuilder(column: $table.minZoom, builder: (column) => column);

  GeneratedColumn<int> get maxZoom =>
      $composableBuilder(column: $table.maxZoom, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isFallback => $composableBuilder(
    column: $table.isFallback,
    builder: (column) => column,
  );
}

class $$MapPackagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MapPackagesTable,
          MapPackage,
          $$MapPackagesTableFilterComposer,
          $$MapPackagesTableOrderingComposer,
          $$MapPackagesTableAnnotationComposer,
          $$MapPackagesTableCreateCompanionBuilder,
          $$MapPackagesTableUpdateCompanionBuilder,
          (
            MapPackage,
            BaseReferences<_$AppDatabase, $MapPackagesTable, MapPackage>,
          ),
          MapPackage,
          PrefetchHooks Function()
        > {
  $$MapPackagesTableTableManager(_$AppDatabase db, $MapPackagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MapPackagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MapPackagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MapPackagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int> minZoom = const Value.absent(),
                Value<int> maxZoom = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isFallback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MapPackagesCompanion(
                id: id,
                name: name,
                fileName: fileName,
                minZoom: minZoom,
                maxZoom: maxZoom,
                priority: priority,
                isFallback: isFallback,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String fileName,
                required int minZoom,
                required int maxZoom,
                Value<int> priority = const Value.absent(),
                Value<bool> isFallback = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MapPackagesCompanion.insert(
                id: id,
                name: name,
                fileName: fileName,
                minZoom: minZoom,
                maxZoom: maxZoom,
                priority: priority,
                isFallback: isFallback,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MapPackagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MapPackagesTable,
      MapPackage,
      $$MapPackagesTableFilterComposer,
      $$MapPackagesTableOrderingComposer,
      $$MapPackagesTableAnnotationComposer,
      $$MapPackagesTableCreateCompanionBuilder,
      $$MapPackagesTableUpdateCompanionBuilder,
      (
        MapPackage,
        BaseReferences<_$AppDatabase, $MapPackagesTable, MapPackage>,
      ),
      MapPackage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$PlaybackStatesTableTableManager get playbackStates =>
      $$PlaybackStatesTableTableManager(_db, _db.playbackStates);
  $$MapPackagesTableTableManager get mapPackages =>
      $$MapPackagesTableTableManager(_db, _db.mapPackages);
}

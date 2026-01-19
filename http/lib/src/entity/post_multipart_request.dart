import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:http_service/src/util/constants.dart';
import 'package:http_service/src/util/object_util.dart';
import 'package:mime/mime.dart' as mime;
import 'package:uuid/uuid.dart';

/// A multipart HTTP POST request for uploading files and form data.
final class PostMultipartRequest extends http.MultipartRequest {
  PostMultipartRequest._({
    required Uri url,
    required Iterable<http.MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String>? fields,
  }) : super(_methodName, url) {
    if (headers != null) {
      this.headers.addAll(headers);
    }

    if (fields != null) {
      this.fields.addAll(fields);
    }

    this.files.addAll(files);
  }

  /// Creates a [PostMultipartRequest] with files and form fields.
  /// [url] is the target URL for the request.
  /// [fileFieldNameToFileBytes] maps file field names to their binary content.
  /// [headers] are optional HTTP headers to include.
  /// [fields] are optional form field values.
  PostMultipartRequest.build({
    required Uri url,
    required Map<String, Uint8List> fileFieldNameToFileBytes,
    Map<String, String>? headers,
    Map<String, String>? fields,
  }) : this._(
         url: url,
         files: _obtainMultipartFilesFromMediaFilesWithPaths(
           fileFieldNameToFileBytes: fileFieldNameToFileBytes,
         ),
         headers: headers,
         fields: fields,
       );

  static const String _methodName = 'POST';

  static Iterable<http.MultipartFile> _obtainMultipartFilesFromMediaFilesWithPaths({
    required Map<String, Uint8List> fileFieldNameToFileBytes,
  }) {
    return fileFieldNameToFileBytes.entries.map((MapEntry<String, Uint8List> entry) {
      final String fileFieldName = entry.key;
      final Uint8List fileBytes = entry.value;
      final http_parser.MediaType? mediaType = _obtainFileMediaType(fileBytes);

      return http.MultipartFile.fromBytes(
        fileFieldName,
        fileBytes,
        filename: _generateFileNameFromFileSubtype(mediaType?.subtype),
        contentType: mediaType,
      );
    });
  }

  static http_parser.MediaType? _obtainFileMediaType(Uint8List fileBytes) {
    final String? mimeType = mime.lookupMimeType(emptyString, headerBytes: fileBytes);

    try {
      return mimeType?.let(http_parser.MediaType.parse);
    } catch (_) {
      return null;
    }
  }

  static String _generateFileNameFromFileSubtype(String? fileSubtype) {
    final String fileUid = const Uuid().v4();
    return '$fileUid.$fileSubtype';
  }
}

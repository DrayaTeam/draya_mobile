import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppNavigator {
  static Future<T?> push<T>({
    required BuildContext context,
    required String path,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? extra,
  }) {
    return context.push<T>(
      _buildPath(
        path: path,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      ),
      extra: extra,
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required String path,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? extra,
  }) {
    context.pushReplacement(
      _buildPath(
        path: path,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      ),
      extra: extra,
    );
  }

  static void goAndRemove({
    required BuildContext context,
    required String path,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
    Object? extra,
  }) {
    context.go(
      _buildPath(
        path: path,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      ),
      extra: extra,
    );
  }

  static void pop<T extends Object?>({
    required BuildContext context,
    T? result,
  }) {
    context.pop(result);
  }

  static String _buildPath({
    required String path,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
  }) {
    String destination = path;

    if (pathParameters != null) {
      for (var p in pathParameters.entries) {
        destination = destination.replaceAll(
          ":${p.key}",
          Uri.encodeComponent(p.value),
        );
      }
    }

    final uri = Uri(
      path: destination,
      queryParameters: queryParameters == null || queryParameters.isEmpty
          ? null
          : queryParameters,
    );

    return uri.toString();
  }
}

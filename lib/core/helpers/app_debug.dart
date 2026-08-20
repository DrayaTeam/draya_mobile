import "package:flutter/material.dart";

void d({required String? message}) {
  final stack = StackTrace.current.toString().split("\n");
  String caller = "Unknown Caller";

  if (stack.length > 1) {
    caller = stack[1].trim();
  }

  debugPrint("[CUSTOM_DEBUGGER] $caller: $message");
}

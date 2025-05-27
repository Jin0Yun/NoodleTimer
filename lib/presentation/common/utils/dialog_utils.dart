import 'package:flutter/material.dart';
import 'package:noodle_timer/presentation/common/widget/custom_alert_dialog.dart';

class DialogUtils {
  static void showError(
      BuildContext context,
      String message, {
        VoidCallback? onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        message: message,
        confirmText: '확인',
        isSuccess: false,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onConfirm?.call();
          });
        },
      ),
    );
  }

  static void showSuccess(
      BuildContext context,
      String message, {
        VoidCallback? onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        message: message,
        confirmText: '확인',
        isSuccess: true,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onConfirm?.call();
          });
        },
      ),
    );
  }

  static void showConfirm(
      BuildContext context,
      String message, {
        required VoidCallback onConfirm,
        String confirmText = '확인',
        String cancelText = '취소',
      }) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        hasCancel: true,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onConfirm();
          });
        },
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
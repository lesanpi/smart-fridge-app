import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/widgets/loading_indicator.dart';

Future<T?> futureLoadingIndicator<T>(
  BuildContext context,
  Future<T> future, {
  Duration? timeoutAt,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // future.then<T?>((result) {
      future.then<T?>((result) {
        // If the future completes successfully, dismiss the dialog.
        Navigator.pop(context, result);
      }, onError: (error, stackTrace) {
        // If the future completes with an error, dismiss the loading dialog
        // and show the error dialog.
        Navigator.pop(context);

        _onErrorDialog(
          context: context,
          errorMessage: 'Ha ocurrido un error inesperado: $error',
          onTryAgainFuture: future,
          error: error,
          stackTrace: stackTrace,
        );
      }).timeout(timeoutAt ?? const Duration(seconds: 15), onTimeout: () {
        // If the future times out, dismiss the loading dialog
        // and show the error dialog with a Request Timeout message.
        Navigator.pop(context);
        _onErrorDialog(
          context: context,
          errorMessage: 'Error de conexión. Vuelva a intentar',
          onTryAgainFuture: future,
        );
      });
      return const LoadingIndicator();
    },
  );
}

/// The error dialog that is shown when an error occurs. It can be dismissed.
///
/// The 'onErrorMessage' parameter is the error message that is shown to the
/// user when this dialog is shown.
///
/// The `onTryAgainFuture` parameter is the future that will be executed when
/// the user taps the "Try Again" button.
///
/// The `error` parameter is the error that was thrown.
/// The `stackTrace` parameter is the stack trace of the error that was thrown.
/// Both the `error` and `stackTrace` parameters are for debugging purpose.
Future _onErrorDialog({
  required BuildContext context,
  String? errorMessage,
  Future? onTryAgainFuture,
  Object? error,
  StackTrace? stackTrace,
}) {
  // print(error);
  // print(stackTrace);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage ?? 'Ocurrió un error'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          (onTryAgainFuture != null)
              ? TextButton(
                  child: const Text('Reintentar'),
                  onPressed: () {
                    Navigator.pop(context);
                    futureLoadingIndicator(context, onTryAgainFuture);
                  })
              : Container(),
        ],
      );
    },
  );
}

Future onDialogMessage({
  required context,
  VoidCallback? onClose,
  required String title,
  required String message,
  VoidCallback? warningCallback,
  bool warning = false,
  String warningButtonText = 'INTENTAR DE NUEVO',
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          // width: size.width * 0.8,
          width: 350,
          // height: 425,
          padding: const EdgeInsets.symmetric(
              horizontal: Consts.defaultPadding, vertical: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(Consts.defaultBorderRadius * 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0.0, 2.0),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: Consts.defaultPadding),
              warning
                  ? const Icon(
                      Icons.error_outline,
                      color: Consts.primary,
                      size: 80,
                    )
                  : const Icon(
                      Icons.check,
                      color: Consts.primary,
                      size: 80,
                    ),
              const SizedBox(height: Consts.defaultPadding / 2),
              Text(
                title,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Consts.neutral.shade700,
                      fontSize: 18,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Consts.defaultPadding),

              // if (message.isNotEmpty)
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.02,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Consts.defaultPadding),
              if (warning && warningCallback != null) ...[
                ElevatedButton(
                  clipBehavior: Clip.none,
                  onPressed: () {
                    Navigator.pop(context);
                    warningCallback();
                  },
                  child: Text(
                    warningButtonText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                // const SizedBox(height: Consts.defaultPadding / 2),
              ],
              const SizedBox(height: Consts.defaultPadding / 2),

              OutlinedButton(
                clipBehavior: Clip.none,
                onPressed: () {
                  Navigator.pop(context);
                  if (onClose != null) onClose();
                },
                child: Text(
                  'CERRAR',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Consts.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_test/config/theme/app_theme.dart';
import 'package:rick_test/logic/bloc/ConnectivityBloc/connectivity_bloc.dart';

class ConnectivityBanner extends StatelessWidget {
  final Widget child;

  const ConnectivityBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          _showSnackBar(
            context,
            'Нет подключения к интернету',
            Colors.red,
            Icons.wifi_off,
          );
        } else if (state is ConnectivityConnected) {
          _showSnackBar(
            context,
            'Подключение восстановлено',
            RickAndMortyColors.secondaryColor,
            Icons.wifi,
          );
        }
      },
      child: child,
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                message,
                style: RickAndMortyTextStyles.white16.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.02,
            left: 16,
            right: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: color == Colors.red 
              ? const Duration(days: 1) // Показываем пока нет подключения
              : const Duration(seconds: 3), // Автоскрытие при восстановлении
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
  }
} 
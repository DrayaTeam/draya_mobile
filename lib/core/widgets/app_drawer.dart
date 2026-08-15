import 'package:draya_mobile/core/helpers/app_navigator.dart';
import 'package:draya_mobile/core/helpers/app_shared_pref_helper.dart';
import 'package:draya_mobile/core/router/app_routes.dart';
import 'package:draya_mobile/core/theme/app_colors.dart';
import 'package:draya_mobile/core/theme/app_sizes.dart';
import 'package:draya_mobile/core/view_models/drawer_model.dart';
import 'package:draya_mobile/core/widgets/app_logo_and_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final List<DrawerModel> drawerItemsList;
  const AppDrawer({super.key, required this.drawerItemsList});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.path;
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.s48,
          horizontal: AppSizes.s16,
        ),
        children: [
          _buildLogoAndCloseIconRow(context),
          const SizedBox(height: AppSizes.s16),
          const Divider(),
          const SizedBox(height: AppSizes.s16),
          ...drawerItemsList.map(
            (item) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                ...item.items.map(
                  (item) {
                    final isSelected =
                        item.route != null && currentRoute == item.route;

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: AppColors.primary100,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.s8),
                      ),

                      visualDensity: VisualDensity.compact,

                      leading: Icon(
                        item.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.foregroundMuted,
                        size: 28,
                      ),

                      title: Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.foregroundMuted,
                            ),
                      ),

                      onTap: () {
                        if (item.route == null) return;

                        AppNavigator.pop(context: context);

                        AppNavigator.goAndRemove(
                          context: context,
                          path: item.route!,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSizes.s8),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          const Divider(),
          const SizedBox(height: AppSizes.s16),
          _buildLogoutListTile(context),
        ],
      ),
    );
  }
}

Widget _buildLogoAndCloseIconRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const AppLogoAndName(subtitle:  "لوحة التحكم"),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          AppNavigator.pop(context: context);
        },
      ),
    ],
  );
}

Widget _buildLogoutListTile(BuildContext context) {
  return ListTile(
    visualDensity: VisualDensity.compact,
    leading: const Icon(
      Icons.logout_outlined,
      color: AppColors.error,
      size: 28,
    ),
    title: Text(
      "تسجيل الخروج",
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: AppColors.error,
      ),
    ),
    onTap: () {
      AppSharedPrefHelper.clearAllSecuredData();
      AppNavigator.goAndRemove(context: context, path: AppRoutes.signinPage);
    },
  );
}

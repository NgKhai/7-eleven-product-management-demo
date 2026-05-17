library product_management_app;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app/product_management_app.dart';

part 'core/network/api_client.dart';

part 'core/theme/app_theme.dart';

part 'core/utils/formatters.dart';

part 'core/utils/iterable_extensions.dart';

part 'core/utils/responsive.dart';

part 'core/utils/validators.dart';

part 'data/models/cart_item.dart';

part 'data/models/category.dart';

part 'data/models/order.dart';

part 'data/models/picked_image.dart';

part 'data/models/product.dart';

part 'data/models/user.dart';

part 'presentation/blocs/auth/auth_cubit.dart';

part 'presentation/blocs/cart/cart_cubit.dart';

part 'presentation/blocs/category/category_cubit.dart';

part 'presentation/blocs/order/order_cubit.dart';

part 'presentation/blocs/product/product_cubit.dart';

part 'presentation/dialogs/checkout_sheet.dart';

part 'presentation/dialogs/confirm_delete_product.dart';

part 'presentation/dialogs/order_detail_sheet.dart';

part 'presentation/dialogs/product_detail_sheet.dart';

part 'presentation/dialogs/product_form_sheet.dart';

part 'presentation/pages/admin/admin_dashboard_page.dart';

part 'presentation/pages/admin/admin_order_page.dart';

part 'presentation/pages/admin/admin_product_page.dart';

part 'presentation/pages/auth/login_page.dart';

part 'presentation/pages/root_view.dart';

part 'presentation/pages/user/cart_page.dart';

part 'presentation/pages/user/my_orders_page.dart';

part 'presentation/pages/user/product_catalog_page.dart';

part 'presentation/pages/user/user_home_page.dart';

part 'presentation/widgets/empty_state.dart';

part 'presentation/widgets/adaptive_shell.dart';

part 'presentation/widgets/logout_button.dart';

part 'presentation/widgets/order_list.dart';

part 'presentation/widgets/product_image.dart';

part 'presentation/widgets/snack_bar.dart';

part 'presentation/widgets/status_chip.dart';

part 'presentation/widgets/status_filter_bar.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  // defaultValue: 'http://localhost:5000/api', // for iOS
  defaultValue: 'http://10.0.2.2:5000/api', // for Android
  // defaultValue: 'http://192.168.x.x/api' // for physical device (replace x to your current IP)
);
const _unset = Object();

void main() {
  runApp(const ProductManagementApp());
}

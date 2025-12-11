import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallify/infrastructure/utils/responsive_util.dart';

class GeneralUtils {
  GeneralUtils();

  void showToastMessage({
    required String toastMsg,
    Toast toastLength = Toast.LENGTH_SHORT,
    required bool isSuccess,
  }) {
    Fluttertoast.showToast(
      msg: toastMsg,
      toastLength: toastLength,
      gravity: ToastGravity.BOTTOM,
      //backgroundColor: isSuccess ? AppColors.bottomSheetBGColor : Colors.red,
      //textColor: themeController.secondaryColor.value,
      fontSize: 14.px,
    );
  }
}

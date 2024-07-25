import 'package:admin_app/cubits/order_cubit/order_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCubit extends Cubit<OrdersStates> {
  OrdersCubit() : super(OrdersInitialState());

  static OrdersCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOrderStatus(
      {required String orderId, required bool orderIsDoneValue}) async {
    try {
      await _firestore.collection('ordersAdvanced').doc(orderId).update({
        'orderIsDone': orderIsDoneValue,
      });

      emit(ChangeIsDoneSuccessfullyState());
    } catch (e) {
      emit(ChangeIsDoneFailureState());
    }
  }

  Future<void> deleteMandopOrder({required String orderId}) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('ordersAdvanced')
          .doc(orderId)
          .get();

      if (docSnapshot.exists) {
        bool mandopMoneyDone = docSnapshot['mandopMoneyDone'] as bool;

        if (mandopMoneyDone) {
          await FirebaseFirestore.instance
              .collection('ordersAdvanced')
              .doc(orderId)
              .delete();
          emit(DeleteOrderSuccessfullyState());
        } else {
          emit(DeleteMandopOrderFailureState());
        }
      } else {
        emit(DeleteMandopOrderFailureState());
      }
    } catch (e) {
      emit(DeleteMandopOrderFailureState());
    }
  }

  Future<void> deleteOrder({required String orderId}) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('ordersAdvanced')
          .doc(orderId)
          .get();

      if (docSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('ordersAdvanced')
            .doc(orderId)
            .delete();
        emit(DeleteOrderSuccessfullyState());
      } else {
        emit(DeleteOrderFailureState());
      }
    } catch (e) {
      emit(DeleteOrderFailureState());
    }
  }
}

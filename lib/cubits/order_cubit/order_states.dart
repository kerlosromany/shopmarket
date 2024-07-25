abstract class OrdersStates{}

class OrdersInitialState extends OrdersStates{}

class FetchOrdersSuccessfullyState extends OrdersStates{}
class FetchOrdersFailureState extends OrdersStates{}

class ChangeIsDoneSuccessfullyState extends OrdersStates{}
class LoadingIsDoneState extends OrdersStates{}
class ChangeIsDoneFailureState extends OrdersStates{}

class DeleteOrderSuccessfullyState extends OrdersStates{}
class DeleteMandopOrderFailureState extends OrdersStates{}

class DeleteOrderFailureState extends OrdersStates{}
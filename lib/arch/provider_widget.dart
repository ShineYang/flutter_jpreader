import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child)?
      builder; //child widget observer
  final T? model; //vm
  final Function(T)? onReady; //init

  ProviderWidget({
    this.model,
    this.onReady,
    this.builder,
  });

  @override
  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.onReady != null) {
      widget.onReady!(widget.model!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (_) => widget.model!,
      child: Consumer<T>(
        builder: widget.builder!,
      ),
    );
  }
}

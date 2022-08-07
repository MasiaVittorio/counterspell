import 'package:counter_spell_new/core.dart';


class DesignPattern extends StatelessWidget {

  const DesignPattern();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);

    return bloc.payments.unlocked.build((_, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          ListTile(
            title: const Text("Pick design pattern"),
            leading: const Icon(McIcons.material_design),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: (){
              stage!.panelController.close();
              stage.showSnackBar(
                const DesignSnackBar(),
                duration: null,
                rightAligned: true,
                pagePersistent: true,
              );
            },
          ),

          if(!unlocked) Positioned.fill(child: GestureDetector(
            onTap: () => stage!.showAlert(const SupportAlert(), size: SupportAlert.height),
            child: Container(
              color: theme.scaffoldBackgroundColor
                  .withOpacity(0.5),
            ),
          ),),
        ],
      ),
    );
  }
}
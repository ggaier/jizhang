import 'package:accountbook/bill_accounts/bill_accounts_bloc.dart';
import 'package:accountbook/bill_category/bill_categories_repo.dart';
import 'package:accountbook/bill_category/bill_category_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillCategorySelectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BillCategorySelectorState();
}

class _BillCategorySelectorState extends State {
  final TextEditingController _billCategoryTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _billCategoryTEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillCategoryBloc, BaseBlocState>(
      bloc: context.read<BillCategoryBloc>(),
      builder: (context, state) {
        final billCategory = state.getData<List<BillCategory>>();
        var accountName = billCategory?.first.name;
        if (accountName != null) {
          _billCategoryTEC.text = accountName;
        }
        print("name: $accountName");
        return Row(
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text("分类")),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(hintText: "请选择账单类别"),
                readOnly: true,
                controller: _billCategoryTEC,
                onTap: () => _showBillCategoryDialog(context),
              ),
            )
          ],
        );
      },
    );
  }

  _showBillCategoryDialog(BuildContext context) async {
    final category = await showModalBottomSheet<BillCategory>(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => BillCategoryBloc(RepositoryProvider.of<BillCategoriesRepoImpl>(context)),
          child: BlocBuilder<BillCategoryBloc, BaseBlocState>(
            builder: (context, state) {
              final bloc = context.read<BillCategoryBloc>();
              if (bloc.state.isInitial) {
                bloc.add(BillCategoryLoadedEvent());
                return Container();
              }
              final categories = state.getData<List<BillCategory>>();
              if (categories == null || categories.isEmpty) {
                Navigator.pop(context);
                return Container();
              }
              return Column(
                children: [
                  AppBar(automaticallyImplyLeading: true, title: Text("账户")),
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var category = categories[index];
                      return TextButton(onPressed: () => Navigator.pop(context, category), child: Text(category.name));
                    },
                    itemCount: categories.length,
                  )
                ],
              );
            },
          ),
        );
      },
    );
    if (category != null) {
      context.read<BillCategoryBloc>().add(BillCategorySelectedEvent(category));
    }
  }
}

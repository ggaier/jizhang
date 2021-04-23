import 'package:accountbook/add_bill/add_bill_bloc.dart';
import 'package:accountbook/bill_accounts/bill_accounts_bloc.dart';
import 'package:accountbook/bill_category/bill_categories_repo.dart';
import 'package:accountbook/bill_category/bill_category_bloc.dart';
import 'package:accountbook/bloc/base_bloc.dart';
import 'package:accountbook/vo/bill_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BillCategoriesView on AddBillBloc {
  showBillCategoryDialog(BuildContext context) async {
    final category = await showModalBottomSheet<BillCategory>(
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
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
              print("category length: ${categories.length}");
              return Column(
                children: [
                  AppBar(title: Text("账单分类"), leading: null, automaticallyImplyLeading: false),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var category = categories[index];
                        return TextButton(
                            onPressed: () => Navigator.pop(context, category), child: Text(category.name));
                      },
                      itemCount: categories.length,
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
    if (category != null) {
      this.setBillCategory(category);
    }
  }
}

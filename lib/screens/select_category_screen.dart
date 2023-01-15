import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';

class CategorySelectScreen extends StatefulWidget {
  bool filterIsAllCategories;
  List<Category> categories;
  Category? category;
  List<Category> selectedCategories;

  CategorySelectScreen({
    this.categories = const [],
    this.category = null,
    this.selectedCategories = const [],
    this.filterIsAllCategories = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.categories.isEmpty) {
      BlocProvider.of<CategoriesBloc>(context).add(CategoriesFetchEvent());
    } else {
      BlocProvider.of<CategoriesBloc>(context)
          .add(CategoriesWithDataEvent(categories: widget.categories));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category != null ? widget.category!.name! : 'انتخاب دسته بندی',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Themes.text,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Themes.icon,
            size: 22,
          ),
        ),
        backgroundColor: Themes.background,
        elevation: 0.7,
      ),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<CategoriesBloc, CategoriesBlocState>(
            builder: _blocBuilder,
          ),
        ),
      ),
    );
  }

  Widget _blocBuilder(context, CategoriesBlocState state) {
    if (state is CategoriesBlocLoading) {
      return Loading();
    }
    if (state is CategoriesBlocError) {
      notify("خطای غیر منتظره ای رخ داد لطفا مجدد تلاش کنید");
      return MaterialButton(
        onPressed: _onTryAgain,
        child: Text(
          "تلاش مجدد",
          style: TextStyle(color: Themes.textLight, fontSize: 15),
        ),
        color: Themes.primary,
      );
    }

    if (state is CategoriesBlocLoaded) {
      return _buildList(state.categories);
    }

    return Container();
  }

  void _onTryAgain() {
    BlocProvider.of<CategoriesBloc>(context).add(CategoriesFetchEvent());
  }

  Widget _buildList(List<Category> categories) {
    if (categories.isEmpty) {
      return Text(
        "موردی یافت نشد",
        style: TextStyle(color: Themes.text, fontSize: 18),
      );
    }
    var showableList = categories
        .where((element) =>
            element.parentId == widget.category?.id &&
            (widget.filterIsAllCategories ? !(element.isAll ?? false) : true))
        .toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        var childs = categories
            .where((element) =>
                element.parentId == showableList[index].id &&
                (widget.filterIsAllCategories
                    ? !(element.isAll ?? false)
                    : true))
            .toList();
        return _buildListItem(showableList[index], childs, categories,
            showableList.last == showableList[index]);
      },
      itemCount: showableList.length,
    );
  }

  Widget _buildListItem(Category category, List<Category> childs,
      List<Category> list, bool isLast) {
    return GestureDetector(
      onTap: () {
        var selectedCategories = widget.selectedCategories + [category];

        if (childs.isEmpty || category.isAll == true) {
          Navigator.pop(context, selectedCategories);
        } else {
          goNextCategory(category, list, selectedCategories);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(
                    color: Themes.primary.withOpacity(0.5),
                    width: 0.7,
                  ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            category.name ?? '',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }

  void goNextCategory(
    Category category,
    List<Category> list,
    List<Category> selectedCategories,
  ) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectScreen(
          filterIsAllCategories: widget.filterIsAllCategories,
          categories: list,
          category: category,
          selectedCategories: selectedCategories,
        ),
      ),
    );

    if (result != null && result is List<Category>) {
      Navigator.pop(context, result);
    }
  }
}

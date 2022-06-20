import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/search_controller.dart';
import 'package:qnpick/ui/widgets/input_fields.dart';
import 'package:qnpick/ui/widgets/svg_icons.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onFieldSubmitted(String inputText) {
      controller.searchFieldFocus.unfocus();
      controller.search();
    }

    void _onBackPressed() {
      controller.searchFieldFocus.unfocus();
      controller.reset();
      Get.back();
    }

    void _onFilterPressed() {}

    void _onInputChanged(String input) {
      controller.update();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GetBuilder<SearchController>(
          builder: (_) {
            return Column(
              children: [
                Hero(
                  tag: "search",
                  child: SizedBox(
                    height: 56,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: IconButton(
                              onPressed: _onBackPressed,
                              splashRadius: 25,
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: _.searchTextController.text != ''
                                    ? darkPrimaryColor
                                    : lightGrayColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: Center(
                                child: SearchInputField(
                                  controller: _.searchTextController,
                                  onFieldSubmitted: _onFieldSubmitted,
                                  focusNode: _.searchFieldFocus,
                                  onChanged: _onInputChanged,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 6, top: 10, bottom: 10),
                            child: IconButton(
                              onPressed: _onFilterPressed,
                              splashRadius: 25,
                              icon: FilterIcon(
                                color: _.searchTextController.text != ''
                                    ? darkPrimaryColor
                                    : lightGrayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 150, bottom: 30),
                  child: SearchCharacter(),
                ),
                const Text(
                  '무엇이든 물어보세요',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: lightGrayColor,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

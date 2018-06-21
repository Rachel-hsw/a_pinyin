package org.sceext.a_pinyin;


interface ApinyinInterface {

  // get a_pinyin interface version
  // current version: '0.1.0'
  String version();

  // request a_pinyin to accept post data
  // return true if success
  boolean request_permission();

  // post a text item to a_pinyin, with json data
  //   {
  //     // TODO
  //   }
  //
  // return true if success
  boolean post(String json);
}

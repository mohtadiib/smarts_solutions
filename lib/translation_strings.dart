import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'lang/messages_all.dart';

class Translations {
  static Future<Translations> load(Locale locale) {
    final String name =
        (locale.countryCode != null && locale.countryCode.isEmpty)
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((dynamic _) {
      Intl.defaultLocale = localeName;
      return new Translations();
    });
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String get username {
    return Intl.message(
      'Username',
      name: 'username',
    );
  }

  String get not_valid_username {
    return Intl.message(
      'Not Valid Username',
      name: 'not_valid_username',
    );
  }

  String get password {
    return Intl.message(
      'password',
      name: 'password',
    );
  }

  String get password_is_too_short {
    return Intl.message(
      'password is too short',
      name: 'password_is_too_short',
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
    );
  }

  String get language {
    return Intl.message(
      'عربي',
      name: 'language',
    );
  }

  String get links {
    return Intl.message(
      'Links',
      name: 'links',
    );
  }

  String get contacts {
    return Intl.message(
      'Contacts',
      name: 'contacts',
    );
  }

  String get attendance {
    return Intl.message(
      'Attendance',
      name: 'attendance',
    );
  }

  String get support {
    return Intl.message(
      'Support',
      name: 'support',
    );
  }

  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
    );
  }
  String get Skip {
    return Intl.message(
      'Skip',
      name: 'Skip',
    );
  }
  String get Next {
    return Intl.message(
      'Next',
      name: 'Next',
    );
  }

  String get welcome1_title {
    return Intl.message(
      'welcome1_title',
      name: 'welcome1_title',
    );
  }
  String get welcome1_subtitle {
    return Intl.message(
      'welcome1_subtitle',
      name: 'welcome1_subtitle',
    );
  }

  String get welcome2_title {
    return Intl.message(
      'welcome2_title',
      name: 'welcome2_title',
    );
  }
  String get welcome2_subtitle {
    return Intl.message(
      'welcome2_subtitle',
      name: 'welcome2_subtitle',
    );
  }

  String get welcome3_title {
    return Intl.message(
      'welcome3_title',
      name: 'welcome3_title',
    );
  }
  String get welcome3_subtitle {
    return Intl.message(
      'welcome3_subtitle',
      name: 'welcome3_subtitle',
    );
  }

  String get welcome4_title {
    return Intl.message(
      'welcome4_title',
      name: 'welcome4_title',
    );
  }
  String get welcome4_subtitle {
    return Intl.message(
      'welcome4_subtitle',
      name: 'welcome4_subtitle',
    );
  }

  String get welcome5_title {
    return Intl.message(
      'welcome5_title',
      name: 'welcome5_title',
    );
  }
  String get welcome5_subtitle {
    return Intl.message(
      'welcome5_subtitle',
      name: 'welcome5_subtitle',
    );
  }

  String get welcome6_title {
    return Intl.message(
      'welcome6_title',
      name: 'welcome6_title',
    );
  }
  String get welcome6_subtitle {
    return Intl.message(
      'welcome6_subtitle',
      name: 'welcome6_subtitle',
    );
  }

  String get getStarted {
    return Intl.message(
      'getStarted',
      name: 'getStarted',
    );
  }

  String get workfields {
    return Intl.message(
      'workfields',
      name: 'workfields',
    );
  }

  //--------------------navigation side bar-------------------------------
  String get home{
    return Intl.message(
      'home',
      name: 'home',
    );
  }

  String get last_order{
    return Intl.message(
      'last_order',
      name: 'last_order',
    );
  }

  String get notifi{
    return Intl.message(
      'notifi',
      name: 'notifi',
    );
  }

  String get help{
    return Intl.message(
      'help',
      name: 'help',
    );
  }

   String get about_us{
    return Intl.message(
      'about_us',
      name: 'about_us',
    );
  }

  String get log_out{
    return Intl.message(
      'log_out',
      name: 'log_out',
    );
  }

  String get exit{
    return Intl.message(
      'exit',
      name: 'exit',
    );
  }
  //------------------------home bage---------------------------------------
  String get catigories{
    return Intl.message(
      'catigories',
      name: 'catigories',
    );
  }

  String get create_order{
    return Intl.message(
      'create_order',
      name: 'create_order',
    );
  }

  String get content{
    return Intl.message(
      'content',
      name: 'content',
    );
  }

  String get create_visit{
    return Intl.message(
      'create_visit',
      name: 'create_visit',
    );
  }

  String get direct_order{
    return Intl.message(
      'direct_order',
      name: 'direct_order',
    );
  }

  //------------------------direct order bage---------------------------------------

  String get item_title{
    return Intl.message(
      'item_title',
      name: 'item_title',
    );
  }

  String get item_sub_title{
    return Intl.message(
      'item_sub_title',
      name: 'item_sub_title',
    );
  }

  String get button_next{
    return Intl.message(
      'button_next',
      name: 'button_next',
    );
  }

  String get delete_content{
    return Intl.message(
      'delete_content',
      name: 'delete_content',
    );
  }

  String get delete_close{
    return Intl.message(
      'delete_close',
      name: 'delete_close',
    );
  }

  String get delete_ok{
    return Intl.message(
      'delete_ok',
      name: 'delete_ok',
    );
  }

  String get tasleek_type{
    return Intl.message(
      'tasleek_type',
      name: 'tasleek_type',
    );
  }

  String get damaan{
    return Intl.message(
      'damaan',
      name: 'damaan',
    );
  }

  String get item_{
    return Intl.message(
      'item_',
      name: 'item_',
    );
  }

  String get damman_content{
    return Intl.message(
      'damman_content',
      name: 'damman_content',
    );
  }



  //------------------------user bage---------------------------------------

  String get user_title{
    return Intl.message(
      'user_title',
      name: 'user_title',
    );
  }

  String get user_sub_title{
    return Intl.message(
      'user_sub_title',
      name: 'user_sub_title',
    );
  }

  String get phone_hint{
    return Intl.message(
      'phone_hint',
      name: 'phone_hint',
    );
  }


  String get button_agree{
    return Intl.message(
      'button_agree',
      name: 'button_agree',
    );
  }

  String get user2_sub_title{
    return Intl.message(
      'user2_sub_title',
      name: 'user2_sub_title',
    );
  }

  String get user_button_verify{
    return Intl.message(
      'user_button_verify',
      name: 'user_button_verify',
    );
  }

  String get edit_phone{
    return Intl.message(
      'edit_phone',
      name: 'edit_phone',
    );
  }

  String get valPhoneMinTen{
    return Intl.message(
      'valPhoneMinTen',
      name: 'valPhoneMinTen',
    );
  }


  //------------------------comlete user bage---------------------------------------

  String get complete_user_title{
    return Intl.message(
      'complete_user_title',
      name: 'complete_user_title',
    );
  }

  String get complete_sub_user_title{
    return Intl.message(
      'complete_sub_user_title',
      name: 'complete_sub_user_title',
    );
  }

  String get firstname{
    return Intl.message(
      'firstname',
      name: 'firstname',
    );
  }

  String get lastname{
    return Intl.message(
      'lastname',
      name: 'lastname',
    );
  }

  String get Region{
    return Intl.message(
      'Region',
      name: 'Region',
    );
  }

  String get Regions{
    return Intl.message(
      'Regions',
      name: 'Regions',
    );
  }

  String get passuser{
    return Intl.message(
      'passuser',
      name: 'passuser',
    );
  }

  String get lastNameValid{
    return Intl.message(
      'lastNameValid',
      name: 'lastNameValid',
    );
  }

  String get firstNameValid{
    return Intl.message(
      'firstNameValid',
      name: 'firstNameValid',
    );
  }

  String get passValid{
    return Intl.message(
      'passValid',
      name: 'passValid',
    );
  }

  String get tenPassValid{
    return Intl.message(
      'tenPassValid',
      name: 'tenPassValid',
    );
  }

  //------------------------map bage---------------------------------------

  String get map_title{
    return Intl.message(
      'map_title',
      name: 'map_title',
    );
  }

  String get map_button{
    return Intl.message(
      'map_button',
      name: 'map_button',
    );
  }

  String get no_servece_here{
    return Intl.message(
      'no_servece_here',
      name: 'no_servece_here',
    );
  }

  //------------------------payment bage---------------------------------------

  String get payment_title{
    return Intl.message(
      'payment_title',
      name: 'payment_title',
    );
  }

  String get direct_payment{
    return Intl.message(
      'direct_payment',
      name: 'direct_payment',
    );
  }

  //------------------------card pay data bage---------------------------------------

  String get payment_card_title{
    return Intl.message(
      'payment_card_title',
      name: 'payment_card_title',
    );
  }

  String get payment_card_subtitle{
    return Intl.message(
      'payment_card_subtitle',
      name: 'payment_card_subtitle',
    );
  }

  String get card_data{
    return Intl.message(
      'card_data',
      name: 'card_data',
    );
  }

  String get card_username{
    return Intl.message(
      'card_username',
      name: 'card_username',
    );
  }

  String get card_number{
    return Intl.message(
      'card_number',
      name: 'card_number',
    );
  }

  String get card_pass{
    return Intl.message(
      'card_pass',
      name: 'card_pass',
    );
  }

  String get card_date{
    return Intl.message(
      'card_date',
      name: 'card_date',
    );
  }

  String get card_button{
    return Intl.message(
      'card_button',
      name: 'card_button',
    );
  }


  String get payment_2_subtitle{
    return Intl.message(
      'payment_2_subtitle',
      name: 'payment_2_subtitle',
    );
  }

  String get agree_takeed{
    return Intl.message(
      'agree_takeed',
      name: 'agree_takeed',
    );
  }

  String get cancel_button{
    return Intl.message(
      'cancel_button',
      name: 'cancel_button',
    );
  }
  //------------------------CheckOut Order---------------------------------------

  String get checkOut_bage_title{
    return Intl.message(
      'checkOut_bage_title',
      name: 'checkOut_bage_title',
    );
  }

  //------------------------success bage---------------------------------------

  String get success_title{
    return Intl.message(
      'success_title',
      name: 'success_title',
    );
  }

  String get category_suc{
    return Intl.message(
      'category_suc',
      name: 'category_suc',
    );
  }

  String get type_suc{
    return Intl.message(
      'type_suc',
      name: 'type_suc',
    );
  }

  String get amount_suc{
    return Intl.message(
      'amount_suc',
      name: 'amount_suc',
    );
  }

  String get order_id_suc{
    return Intl.message(
      'order_id_suc',
      name: 'order_id_suc',
    );
  }

  String get done_button{
    return Intl.message(
      'done_button',
      name: 'done_button',
    );
  }

  String get exit_button{
    return Intl.message(
      'exit_button',
      name: 'exit_button',
    );
  }

  String get phone_validate{
    return Intl.message(
      'phone_validate',
      name: 'phone_validate',
    );
  }


  //------------------------visite bage---------------------------------------

  String get visite_title{
    return Intl.message(
      'visite_title',
      name: 'visite_title',
    );
  }

  String get visite_sub_title{
    return Intl.message(
      'visite_sub_title',
      name: 'visite_sub_title',
    );
  }

  String get visite_date{
    return Intl.message(
      'visite_date',
      name: 'visite_date',
    );
  }

  String get visite_time{
    return Intl.message(
      'visite_time',
      name: 'visite_time',
    );
  }

  String get visite_back_button{
    return Intl.message(
      'visite_back_button',
      name: 'visite_back_button',
    );
  }

  String get visite_done_button{
    return Intl.message(
      'visite_done_button',
      name: 'visite_done_button',
    );
  }

  //------------------------notification bage---------------------------------------

  String get notification_title{
    return Intl.message(
      'notification_title',
      name: 'notification_title',
    );
  }

  String get order_status_waeit{
    return Intl.message(
      'order_status_waeit',
      name: 'order_status_waeit',
    );
  }
  String get order_status_done{
    return Intl.message(
      'order_status_done',
      name: 'order_status_done',
    );
  }

  String get order_date{
    return Intl.message(
      'order_date',
      name: 'order_date',
    );
  }

  //------------------------last order bage---------------------------------------

  String get last_order_title{
    return Intl.message(
      'last_order_title',
      name: 'last_order_title',
    );
  }

  String get order_id{
    return Intl.message(
      'order_id',
      name: 'order_id',
    );
  }

  String get order_date_time{
    return Intl.message(
      'order_date_time',
      name: 'order_date_time',
    );
  }

  String get order_status2{
    return Intl.message(
      'order_status2',
      name: 'order_status2',
    );
  }

  String get order_type_direct{
    return Intl.message(
      'order_type_direct',
      name: 'order_type_direct',
    );
  }

  String get order_type_visit{
    return Intl.message(
      'order_type_visit',
      name: 'order_type_visit',
    );
  }

  String get code_engen{
    return Intl.message(
      'code_engen',
      name: 'code_engen',
    );
  }

  String get details{
    return Intl.message(
      'details',
      name: 'details',
    );
  }



  String get order_type{
    return Intl.message(
      'order_type',
      name: 'order_type',
    );
  }

  String get engineer_order{
    return Intl.message(
      'engineer_order',
      name: 'engineer_order',
    );
  }

  String get phone_order{
    return Intl.message(
      'phone_order',
      name: 'phone_order',
    );
  }

  String get last_order_items_title{
    return Intl.message(
      'last_order_items_title',
      name: 'last_order_items_title',
    );
  }

  String get location{
    return Intl.message(
      'location',
      name: 'location',
    );
  }


  //------------------------help bage---------------------------------------

  String get help_title{
    return Intl.message(
      'help_title',
      name: 'help_title',
    );
  }

  String get help_1{
    return Intl.message(
      'help_1',
      name: 'help_1',
    );
  }

  String get help_2{
    return Intl.message(
      'help_2',
      name: 'help_2',
    );
  }

  String get help_3{
    return Intl.message(
      'help_3',
      name: 'help_3',
    );
  }

  String get help_4{
    return Intl.message(
      'help_4',
      name: 'help_4',
    );
  }

  String get help_5{
    return Intl.message(
      'help_5',
      name: 'help_5',
    );
  }

  String get help_6{
    return Intl.message(
      'help_6',
      name: 'help_6',
    );
  }

  String get help_7{
    return Intl.message(
      'help_7',
      name: 'help_7',
    );
  }

  String get help_8{
    return Intl.message(
      'help_8',
      name: 'help_8',
    );
  }

  String get check_internet{
    return Intl.message(
      'check_internet',
      name: 'check_internet',
    );
  }

  String get quantity_item{
    return Intl.message(
      'quantity_item',
      name: 'quantity_item',
    );
  }

  String get total_item{
    return Intl.message(
      'total_item',
      name: 'total_item',
    );
  }

  String get damman_start{
    return Intl.message(
      'damman_start',
      name: 'damman_start',
    );
  }

  String get damman_end{
    return Intl.message(
      'damman_end',
      name: 'damman_end',
    );
  }







}

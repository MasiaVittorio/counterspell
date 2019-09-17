import 'package:flutter/material.dart';

import '../bloc.dart';


///Since we will often use this long type,
/// it's convenient to rename it "SheetF".
typedef SheetF = Future<void> Function();
///Just remember that it means "a function that
/// shows the [NBottomSheet] and complete a [Future]
/// once that route is closed by any [pop]"


class SheetsBloc {

  ///This is just the main bloc that has the app 
  /// [context] stored and available to its sub blocs
  CSBloc parentBloc;

  ///This is the [List] of all the sheets opened  
  /// (but only "VIRTUALLY" closed -except for 
  /// the last one-) by this [SheetsBloc] class
  List<SheetF> _sheets;

  ///This variable is important to tell the class
  /// that we are closing a [Sheet] just to open another
  /// one, so it shouldn't open the previous sheet
  /// in response to this "VIRTUAL" [pop] 
  bool _forward;

  ///this is used to detect if a ghost sheet is showed
  /// (whithout being on the stack)
  bool _temporary = false;


  ///Create an instance of [SheetsBloc] 
  SheetsBloc(this.parentBloc){
    this._sheets = <SheetF>[];
    this._forward = false;
  }
  

  ///Call a [Sheet] function (that will show the [NBottomSheet])
  /// but make sure this whole design works well
  void show({ SheetF sheet, bool safe = false}){

    ///Before opening another [Sheet], close the previous one!
    if (
      _temporary == true || (
        this._sheets.length > 0 
        && 
        safe == false ///But not if this [show] is triggered by [_exited]
      )
    ){
      _temporary = false;

      ///This will make the incoming [pop] safe
      this._forward = true;

      ///This [pop] will trigger [_exited]
      Navigator.pop(this.parentBloc.context);

    }

    ///Save the new [Sheet] to the [_sheets] stack
    this._sheets.add(sheet);

    ///Show the new [Sheet] by calling it
    /// (remember that Sheet means [Future<void> Function()])
    sheet().then((void v) {
  
      ///But remember to trigger [_exited] 
      /// once the [Sheet] is closed by any [pop]
      this._exited();
  
    });

  }


  ///This function is triggered by the closure
  /// of the last [show]ed [Sheet], and it manages
  /// to show the previous one, but just if the
  /// closure was NOT meant to allow the opening of
  /// another following sheet
  void _exited(){

    ///If the pop was only meant to be followed 
    /// by another [Sheet] opening, don't do nothing
    /// but restore [_forward] to false 
    if (this._forward) this._forward = false;

    ///If the previous [Sheet] was normally closed,
    /// proceed to return to the last one
    else {

      ///Obviously, if the [Sheet] stack was empty, return
      /// (even if this shouldn't happen)
      if(this._sheets.length==0) return;
      ///If not, proceed to remove the closed [Sheet]
      else this._sheets.removeLast();

      ///If there is still some [Sheet] on the stack
      if(this._sheets.length==0) return;
      ///Proceed to [show] it
      else this.show(
        ///But remember to remove it from the stack before,
        /// because the [show] method will add it anyway
        sheet: this._sheets.removeLast(),
        ///Don't trigger the pop because this [show] doesn't come
        /// from any real sheet
        safe: true,
      );
    }
  }


  void ignoreLast(){
    if((this._sheets?.length ?? 0) > 0)
      this._sheets.removeLast();
  }


  ///Call a [Sheet] function (that will show the [NBottomSheet])
  /// but don't turn back to it
  void showTemporary({ SheetF sheet, bool safe = false}){
    _temporary = true;

    ///Before opening another [Sheet], close the previous one!
    if (
      this._sheets.length > 0 
      && 
      safe == false
      ///But not if this [show] is triggered by [_exited]
      ///(it will never be)
    ){
      print("closing sheet before a temporary one");

      ///This will make the incoming [pop] safe
      this._forward = true;

      ///This [pop] will trigger [_exited]
      Navigator.pop(this.parentBloc.context);

    }

    ///DO NOT Save this new [Sheet] to the [_sheets] stack

    ///Show the new [Sheet] by calling it
    /// (remember that Sheet means [Future<void> Function()])
    sheet().then((void v) {
  
      ///But remember to trigger [_exitedTemporary] 
      /// once the [Sheet] is closed by any [pop]
      this._exitedTemporary();
  
    });

  }

  ///This function is triggered by the closure
  /// of the last TEMPORARY showed [Sheet], and it manages
  /// to show the previous one, but just if the
  /// closure was NOT meant to allow the opening of
  /// another following sheet
  void _exitedTemporary(){

    ///If the pop was only meant to be followed 
    /// by another [Sheet] opening, don't do nothing
    /// but restore [_forward] to false 
    if (this._forward) this._forward = false;

    ///If the previous [Sheet] was normally closed,
    /// proceed to return to the last one
    else {

      ///Obviously, if the [Sheet] stack was empty, return
      /// (even if this shouldn't happen)
      if(this._sheets.length==0) return;
      ///DO NOT proceed to remove the closed [Sheet] because 
      /// a temporary sheet is not saved


      ///If there is still some [Sheet] on the stack
      if(this._sheets.length==0) return;
      ///Proceed to [show] it
      else this.show(
        ///But remember to remove it from the stack before,
        /// because the [show] method will add it anyway
        sheet: this._sheets.removeLast(),
        ///Don't trigger the pop because this [show] doesn't come
        /// from any real sheet
        safe: true,
      );
    }
  }

}


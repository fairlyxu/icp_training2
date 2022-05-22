// Persistent logger keeping track of what is going on.

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import List "mo:base/List";
import Nat "mo:base/Nat"; 
import TextLoggers "TextLoggers";
 
shared(msg) actor class  MyLogger() = self {

  let AMOUNT: Nat = 100 ; 

  type TextLogger = TextLoggers.TextLogger;
  
  // init logger buffer array
  let text_loggers : [var ?TextLogger] = Array.init(AMOUNT, null);

  public func view(from : Nat, to : Nat) : async () {
    switch (text_loggers[to % AMOUNT]) {
      case null { assert(false);[] };
      case (?text_logger) {
        await text_logger.view(from, to)
      };
    };
  };

  public func append(e : Nat, v : [Text]) : async () {
    let i = e % AMOUNT;
    let text_logger = switch (text_loggers[i]) {
      case null {
        let reslogs = await TextLoggers.TextLogger(); 
        text_loggers[i] := ?reslogs;
        reslogs;
      };
      case (?text_logger) text_logger;
    };
    await text_logger.append(e, v);
  };
  
}

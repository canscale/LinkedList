import M "mo:matchers/Matchers";
import S "mo:matchers/Suite";
import T "mo:matchers/Testable";
import Nat "mo:base/Nat";
import DLL "../src/DoublyLinkedList";
import LLM "./LinkedListMatchers";
import TH "./TestHelpers";

let { run;test;suite; } = S;

let emptySuite = suite("empty", 
  [
    test("is null with correct type",
      DLL.empty<Nat>(),
      M.equals(LLM.testableDoublyLinkedList<Nat>(null, Nat.toText, Nat.equal))
    )
  ]
);

let prependSuite = suite("prepend",
  [
    test("if the list is null, creates a list with the prepended element",
      DLL.prepend<Nat>(5, DLL.empty<Nat>()),
      M.equals(LLM.testableDoublyLinkedList<Nat>(?{
        var head = {
          value = 5;
          var prev = null;
          var next = null;
        };
        var tail = {
          value = 5;
          var prev = null;
          var next = null;
        };
      }, Nat.toText, Nat.equal))
    ),
    test("prepends an element to the head existing list",
      do {
        let el2: DLL.DoublyLinkedListElement<Nat> = {
          value = 10;
          var prev = null;
          var next = null;
        };
        let el1: DLL.DoublyLinkedListElement<Nat> = {
          value = 8;
          var prev = null;
          var next = ?el2;
        };
        el2.prev := ?el1;
        DLL.prepend<Nat>(5, ?{
          var head = el1;
          var tail = el2;
        })
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        do {
          let el3: DLL.DoublyLinkedListElement<Nat> = {
            value = 10;
            var prev = null;
            var next = null;
          };
          let el2: DLL.DoublyLinkedListElement<Nat> = {
            value = 8;
            var prev = null;
            var next = ?el3;
          };
          el3.prev := ?el2;
          let el1: DLL.DoublyLinkedListElement<Nat> = {
            value = 5;
            var prev = null;
            var next = ?el2;
          };
          el2.prev := ?el1;
          ?{
            var head = el1;
            var tail = el3;
          }
        },
        Nat.toText, 
        Nat.equal
      ))
    )
  ]
);

let appendSuite = suite("append",
  [
    test("if the list is null, creates a list with the appended element",
      DLL.append<Nat>(DLL.empty<Nat>(), 5),
      M.equals(LLM.testableDoublyLinkedList<Nat>(?{
        var head = {
          value = 5;
          var prev = null;
          var next = null;
        };
        var tail = {
          value = 5;
          var prev = null;
          var next = null;
        };
      }, Nat.toText, Nat.equal))
    ),
    test("appends an element to the tail of an existing list",
      do {
        let el3: DLL.DoublyLinkedListElement<Nat> = {
          value = 10;
          var prev = null;
          var next = null;
        };
        let el2: DLL.DoublyLinkedListElement<Nat> = {
          value = 9;
          var prev = null;
          var next = ?el3;
        };
        el3.prev := ?el2;
        let el1: DLL.DoublyLinkedListElement<Nat> = {
          value = 8;
          var prev = null;
          var next = ?el2;
        };
        el2.prev := ?el1;
        DLL.append<Nat>(?{
          var head = el1;
          var tail = el3;
        }, 5)
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        do {
          let el4: DLL.DoublyLinkedListElement<Nat> = {
            value = 5;
            var prev = null;
            var next = null;
          };
          let el3: DLL.DoublyLinkedListElement<Nat> = {
            value = 10;
            var prev = null;
            var next = ?el4;
          };
          el4.prev := ?el3;
          let el2: DLL.DoublyLinkedListElement<Nat> = {
            value = 9;
            var prev = null;
            var next = ?el3;
          };
          el3.prev := ?el2;
          let el1: DLL.DoublyLinkedListElement<Nat> = {
            value = 8;
            var prev = null;
            var next = ?el2;
          };
          el2.prev := ?el1;
          ?{
            var head = el1;
            var tail = el4;
          }
        },
        Nat.toText, 
        Nat.equal
      ))
    )
  ]
);

let mergeSuite = suite("merge",
  [
    test("merging two null lists returns the null list",
      DLL.merge<Nat>(DLL.empty<Nat>(), DLL.empty<Nat>()),
      M.equals(LLM.testableDoublyLinkedList(DLL.empty<Nat>(), Nat.toText, Nat.equal))
    ),
    test("merging a null list with a populated list returns the populated list",
      DLL.merge<Nat>(
        DLL.empty<Nat>(), 
        ?{ 
          var head = {
            value = 5;
            var prev = null;
            var next = null;
          };
          var tail = {
            value = 5;
            var prev = null;
            var next = null;
          }
        }
      ), 
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        ?{
          var head = {
            value = 5;
            var prev = null;
            var next = null;
          };
          var tail = {
            value = 5;
            var prev = null;
            var next = null;
          }
        },
        Nat.toText,
        Nat.equal
      ))
    ),
    test("merging a populated list a null list returns the populated list",
      DLL.merge<Nat>(
        ?{ 
          var head = {
            value = 5;
            var prev = null;
            var next = null;
          };
          var tail = {
            value = 5;
            var prev = null;
            var next = null;
          }
        },
        DLL.empty<Nat>()
      ), 
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        ?{
          var head = {
            value = 5;
            var prev = null;
            var next = null;
          };
          var tail = {
            value = 5;
            var prev = null;
            var next = null;
          }
        },
        Nat.toText,
        Nat.equal
      ),
    )),
    test("merging two lists, l1 and l2, returns them in the order provided with l1.head at the head and l2.tail at the tail",
      do {
        let l1tailElement: DLL.DoublyLinkedListElement<Nat> = {
          value = 8;
          var prev = null;
          var next = null;
        };
        let l1headElement: DLL.DoublyLinkedListElement<Nat> = {
          value = 5;
          var prev = null;
          var next = ?l1tailElement;
        };
        l1tailElement.prev := ?l1headElement;
        let l2headtailElement: DLL.DoublyLinkedListElement<Nat> = {
          value = 7;
          var prev = null;
          var next = null;
        };
        DLL.merge<Nat>(
          ?{ 
            var head = l1headElement; 
            var tail = l1tailElement; 
          },
          ?{ 
            var head = l2headtailElement;
            var tail = l2headtailElement; 
          }
        )
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        do {
          let el3: DLL.DoublyLinkedListElement<Nat> = {
            value = 7;
            var prev = null;
            var next = null;
          };
          let el2: DLL.DoublyLinkedListElement<Nat> = {
            value = 8;
            var prev = null;
            var next = ?el3;
          };
          el3.prev := ?el2;
          let el1: DLL.DoublyLinkedListElement<Nat> = {
            value = 5;
            var prev = null;
            var next = ?el2;
          };
          el2.prev := ?el1;
          ?{
            var head = el1;
            var tail = el3;
          }
        },
        Nat.toText,
        Nat.equal
      ))
    )
  ]
);

let popHeadSuite = suite("popHead",
  [
    test("returns an empty list as the first parameter when performed on an empty list",
      do {
        let (ll, _) = DLL.popHead<Nat>(DLL.empty<Nat>());
        ll
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(null, Nat.toText, Nat.equal))
    ),
    test("returns null as the second parameter when performed on an empty list",
      do {
        let (_, el) = DLL.popHead<Nat>(DLL.empty<Nat>());
        T.optional<Nat>(T.natTestable, el)
      },
      M.isNull<Nat>()
    ),
    test("returns an empty list as the first parameter when performed on a list with one element",
      do {
        let ll = DLL.append<Nat>(DLL.empty<Nat>(), 5);
        let (newLL, _) = DLL.popHead<Nat>(ll);
        newLL
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(null, Nat.toText, Nat.equal))
    ),
    test("returns the single element as the second parameter when performed on a list with one element",
      do {
        let ll = DLL.append<Nat>(DLL.empty<Nat>(), 5);
        let (_, el) = DLL.popHead<Nat>(ll);
        el
      },
      M.equals(T.optional<Nat>(T.natTestable, ?5))
    ),
    test("returns the remaining list as the first parameter when performed on a list with multiple elements",
      do {
        let ll = TH.createDoublyLinkedListWithElements<Nat>([8, 5, 10]); 
        let (newLL, _) = DLL.popHead<Nat>(ll);
        newLL
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        TH.createDoublyLinkedListWithElements<Nat>([5, 10]),
        Nat.toText,
        Nat.equal
      ))
    ),
    test("returns the single element as the second parameter when performed on a list with multiple elements",
      do {
        let ll = TH.createDoublyLinkedListWithElements<Nat>([8, 5, 10]); 
        let (_, el) = DLL.popHead<Nat>(ll);
        el
      },
      M.equals(T.optional<Nat>(T.natTestable, ?8))
    ),
  ]
);

let popTailSuite = suite("popTail",
  [
    test("returns an empty list as the first parameter when performed on an empty list",
      do {
        let (ll, _) = DLL.popTail<Nat>(DLL.empty<Nat>());
        ll
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(null, Nat.toText, Nat.equal))
    ),
    test("returns null as the second parameter when performed on an empty list",
      do {
        let (_, el) = DLL.popTail<Nat>(DLL.empty<Nat>());
        T.optional<Nat>(T.natTestable, el)
      },
      M.isNull<Nat>()
    ),
    test("returns an empty list as the first parameter when performed on a list with one element",
      do {
        let ll = DLL.append<Nat>(DLL.empty<Nat>(), 5);
        let (newLL, _) = DLL.popTail<Nat>(ll);
        newLL
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(null, Nat.toText, Nat.equal))
    ),
    test("returns the single element as the second parameter when performed on a list with one element",
      do {
        let ll = DLL.append<Nat>(DLL.empty<Nat>(), 5);
        let (_, el) = DLL.popTail<Nat>(ll);
        el
      },
      M.equals(T.optional<Nat>(T.natTestable, ?5))
    ),
    test("returns the remaining list as the first parameter when performed on a list with multiple elements",
      do {
        let ll = TH.createDoublyLinkedListWithElements<Nat>([8, 5, 10]); 
        let (newLL, _) = DLL.popTail<Nat>(ll);
        newLL
      },
      M.equals(LLM.testableDoublyLinkedList<Nat>(
        TH.createDoublyLinkedListWithElements<Nat>([8, 5]),
        Nat.toText,
        Nat.equal
      ))
    ),
    test("returns the single element as the second parameter when performed on a list with multiple elements",
      do {
        let ll = TH.createDoublyLinkedListWithElements<Nat>([8, 5, 10]); 
        let (_, el) = DLL.popTail<Nat>(ll);
        el
      },
      M.equals(T.optional<Nat>(T.natTestable, ?10))
    ),
  ]
);

run(suite("LinkedList",
  [
    emptySuite,
    prependSuite,
    appendSuite,
    mergeSuite,
    popHeadSuite,
    popTailSuite
  ]
))
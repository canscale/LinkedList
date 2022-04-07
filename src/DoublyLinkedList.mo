import Bool "mo:base/Bool";
import Text "mo:base/Text";

/// Mutable Doubly Linked Lists
module {
  public type DoublyLinkedListElement<T> = {
    value: T;
    var prev: ?DoublyLinkedListElement<T>;
    var next: ?DoublyLinkedListElement<T>;
  };

  public type DoublyLinkedList<T> = ?{
    var head: DoublyLinkedListElement<T>;
    var tail: DoublyLinkedListElement<T>;
  };

  /// Create an empty DoublyLinkedList
  public func empty<T>(): DoublyLinkedList<T> { null };

  /// Prepend an element to a DoublyLinkedList, mutating the underlying DoublyLinkedList. Returns the new DoublyLinkedList
  public func prepend<T>(x: T, l: DoublyLinkedList<T>): DoublyLinkedList<T> {
    switch(l) {
      case null { 
        var element: DoublyLinkedListElement<T> = { 
          value = x; 
          var prev = null;
          var next = null; 
        };
        ?{
          var head = element;
          var tail = element;
        }
      };
      case (?list) {
        var element: DoublyLinkedListElement<T> = { 
          value = x; 
          var prev = null;
          var next = ?list.head;
        };
        list.head.prev := ?element;
        list.head := element;
        ?list
      }
    }
  };

  /// Append an element to a DoublyLinkedList, mutating the underlying DoublyLinkedList. Returns the new DoublyLinkedList
  public func append<T>(l: DoublyLinkedList<T>, x: T): DoublyLinkedList<T> {
    switch(l) {
      case null { 
        var element: DoublyLinkedListElement<T> = { 
          value = x; 
          var prev = null;
          var next = null 
        };
        ?{
          var head = element;
          var tail = element;
        }
      };
      case (?list) {
        var element: DoublyLinkedListElement<T> = { 
          value = x; 
          var prev = ?list.tail;
          var next = null;
        };
        list.tail.next := ?element;
        list.tail := element;
        ?list
      }
    }
  };

  /// Pops the head element of the DoublyLinkedList, mutating the underlying DoublyLinkedList and returning both the new DoublyLinkedList and the popped element (if exists)
  public func popHead<T>(l: DoublyLinkedList<T>): (DoublyLinkedList<T>, ?T) {
    switch(l) {
      case null { (null, null) };
      case (?list) {
        switch(list.head.next) {
          // if there is only one element in the list, pop it and return an empty list
          case null { (null, ?list.head.value) };
          // otherwise pop the head element and point head to the next element
          case (?newHead) { 
            let value = list.head.value;
            newHead.prev := null;
            (
              ?{
                var head = newHead;
                var tail = list.tail;
              },
              ?value
            )
          }
        }
      }
    }
  }; 

  /// Pops the tail element of the DoublyLinkedList, mutating the underlying DoublyLinkedList and returning both the new DoublyLinkedList and the popped element (if exists)
  public func popTail<T>(l: DoublyLinkedList<T>): (DoublyLinkedList<T>, ?T) {
    switch(l) {
      case null { (null, null) };
      case (?list) {
        switch(list.tail.prev) {
          // if there is only one element in the list, pop it and return an empty list
          case null { (null, ?list.tail.value) };
          // otherwise pop the tail element and point the tail to the previous element
          case (?newTail) {
            let value = list.tail.value;
            newTail.next := null;
            (
              ?{
                var head = list.head;
                var tail = newTail;
              },
              ?value
            )
          }
        }
      }
    }
  }; 

  /// Merge two DoublyLinkedLists, mutating the underlying DoublyLinkedList arguments passed in. Returns the merged DoublyLinkedLists
  public func merge<T>(l1: DoublyLinkedList<T>, l2: DoublyLinkedList<T>): DoublyLinkedList<T> {
    switch(l1, l2) {
      case (null, null) { null };
      case (?l1, null) { ?l1 };
      case (null, ?l2) { ?l2 };
      case (?l1, ?l2) {
        l1.tail.next := ?l2.head;
        l2.head.prev := ?l1.tail;
        l1.tail := l2.tail;
        ?l1
      }
    }
  };

  /// Takes in two DoublyLinkedLists and a user defined equivalence function for each element of the DoublyLinkedList. Returns a boolean
  public func equal<T>(l1: DoublyLinkedList<T>, l2: DoublyLinkedList<T>, equal: (T, T) -> Bool): Bool {
    switch(l1, l2) {
      case (null, null) { true };
      case (?l1, ?l2) {
        func linkedListElementsEqualForward(e1: ?DoublyLinkedListElement<T>, e2: ?DoublyLinkedListElement<T>): Bool {
          switch(e1, e2) {
            case (null, null) { true };
            case (?e1, ?e2) {
              if (equal(e1.value, e2.value)) {
                linkedListElementsEqualForward(e1.next, e2.next)
              } else {
                false
              }
            };
            case _ { false }
          }
        };
        func linkedListElementsEqualReverse(e1: ?DoublyLinkedListElement<T>, e2: ?DoublyLinkedListElement<T>): Bool {
          switch(e1, e2) {
            case (null, null) { true };
            case (?e1, ?e2) {
              if (equal(e1.value, e2.value)) {
                linkedListElementsEqualReverse(e1.prev, e2.prev)
              } else {
                false
              }
            };
            case _ { false }
          }
        };

        linkedListElementsEqualForward(?l1.head, ?l2.head) and 
        linkedListElementsEqualForward(?l1.tail, ?l2.tail) and
        linkedListElementsEqualReverse(?l1.head, ?l2.head) and 
        linkedListElementsEqualReverse(?l1.tail, ?l2.tail)
      };
      case _ { false }
    }
  };

  /// **For Debugging**: Takes in a DoublyLinkedList and toText function, and returns a textual representation of the DoublyLinkedList
  public func toText<T>(ll: DoublyLinkedList<T>, toText: T -> Text): Text {
    switch(ll) {
      case null { "null" };
      case (?ll) {
        func elementsToText(el: ?DoublyLinkedListElement<T>): Text {
          switch(el) {
            case null { "null "};
            case (?el) { 
              let prevElText = switch(el.prev) {
                case null { "null" };
                case (?el) { toText(el.value) }
              };
              "{ value=" # toText(el.value) # ", prev=" # prevElText # ", next=" # elementsToText(el.next) # " }" 
            };
          }
        };

        elementsToText(?ll.head)
      }
    }
  }
}
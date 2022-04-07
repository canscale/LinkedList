import T "mo:matchers/Testable";
import LL "../src/LinkedList";
import DLL "../src/DoublyLinkedList";
import Bool "mo:base/Bool";
import Text "mo:base/Text";

module {
  public func testableLinkedList<T>(ll: LL.LinkedList<T>, toText: T -> Text, equal: (T, T) -> Bool): T.TestableItem<LL.LinkedList<T>> = {
    display = func(ll: LL.LinkedList<T>): Text = LL.toText(ll, toText);
    equals = func(l1: LL.LinkedList<T>, l2: LL.LinkedList<T>): Bool = LL.equal<T>(l1, l2, equal);
    item = ll;
  };

  public func testableDoublyLinkedList<T>(dll: DLL.DoublyLinkedList<T>, toText: T -> Text, equal: (T, T) -> Bool): T.TestableItem<DLL.DoublyLinkedList<T>> = {
    display = func(dll: DLL.DoublyLinkedList<T>): Text = DLL.toText(dll, toText);
    equals = func(dl1: DLL.DoublyLinkedList<T>, dl2: DLL.DoublyLinkedList<T>): Bool = DLL.equal<T>(dl1, dl2, equal);
    item = dll;
  };
}
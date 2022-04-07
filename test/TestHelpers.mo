import DLL "../src/DoublyLinkedList";

/// This module contains helpers for setting up data structures in tests
module {
  public func createDoublyLinkedListWithElements<T>(elements: [T]): DLL.DoublyLinkedList<T> {
    var ll = DLL.empty<T>();
    for (el in elements.vals()) {
      ll := DLL.append(ll, el);
    };
    
    ll
  };
}
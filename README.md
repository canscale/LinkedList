# LinkedList 

Stable and mutable singly and doubly linked lists in Motoko

## Motivation

**Careful, these operations mutate the underlying linked lists involved!**

Sometimes you want both an efficient prepend and append, and the fact that your underlying data structure is mutating just isn't as important as the consistent performance of operations on that data.

## API Documentation

API documentation for this library can be found at https://canscale.github.io/LinkedList

## Usage
Install vessel and ensure this is included in your package-set.dhall and vessel.dhall

Singly Linked List Example
```
import LL "mo:linkedlist/LinkedList";
import Nat "mo:base/Nat";
...

// create, append, and prepend to a linked list
var l1 = LL.empty<Nat>();
l1 := LL.append<Nat>(l1, 5); 
l1 := LL.prepend<Nat>(l1, 3); 

// merge two linked lists
var l2 = LL.empty<Nat>();
l2 := LL.append<Nat>(l2, 8); 
l2 := LL.append<Nat>(l2, 10); 

// Careful! This mutates both l1 and l2
let l3 = LL.merge<Nat>(l1, l2);
```

```
import DLL "mo:linkedlist/DoublyLinkedList";
import Nat "mo:base/Nat";
...

// create, append, and prepend to a doubly linked list
var l1 = DLL.empty<Nat>();
l1 := DLL.append<Nat>(l1, 5); 
l1 := DLL.prepend<Nat>(l1, 3); 

// merge two doubly linked lists
var l2 = DLL.empty<Nat>();
l2 := DLL.append<Nat>(l2, 8); 
l2 := DLL.append<Nat>(l2, 10); 

// Careful! This mutates both l1 and l2
let l3 = DLL.merge<Nat>(l1, l2);

// pop elements from the head and tail of a doubly linked list
let (l4, poppedHead) = DLL.popHead<Nat>(l3); 
let (l5, poppedTail) = DLL.popTail<Nat>(l3); 
```

## License
StableRBTree is distributed under the terms of the Apache License (Version 2.0).

See LICENSE for details.
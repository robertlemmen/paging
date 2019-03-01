#!/usr/bin/env perl6

# a simple store that uses a comparator to order it's contents. it does not
# support duplicate entries, just give them a unique id if you want that. you
# can locate into the store with a locator, this returns a cursor that can be
# used to iterate entries from the located position. the same comparator is used
# to find the position of the locator relative to the elements in the store.
# there is also a variant of the locate method, locate-floor, which uses a
# reverse locator and then returns a cursor that goes backwards in the list of
# elements.
class Store {
    has @!contents;
    has &.comparator;
    has &.reverse-comparator;

    method add($item) {
        ...
    }

    method remove($item) {
        ...
    }

    method start() {
        return Cursor.new(self, -1, Cursor::forwards);
    }

    method end() {
        return Cursor.new(self, @!contents.elems, Cursor::backwards);
    }

    method locate-ceiling($locator) {
        ...
    }

    method locate-floor($locator) {
        ...
    }

    # we should make this private somehow, the error message we get is also
    # somewhat underwhelming
    method get($index) {
        return @!contents[$index];
    }

    class Cursor does Iterator {
        enum Direction <forwards backwards>;

        has $.store;
        has $.index;
        has $.direction;
        
        method pull-one() {
            given $!direction {
                when forwards  { 
                    $!index++;
                    # XXX check out of range
                }
                when backwards { 
                    $!index--;
                    # XXX check out of range
                }
            }
            my $store = $!store;
            return $store.get($!index);
        }
    }
}

# a store configured to keep a sorted list of numbers
my $store = Store.new(
                comparator => sub ($a, $b) { return $a < $b },
                reverse-comparator => sub ($a, $b) { return $a > $b } );

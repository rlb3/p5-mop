#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use mop;

my $Foo = $::Class->new;

{
    local $::CLASS = $Foo;

    method foo ( $bar, $baz ) {
        join ", " => $bar, $baz;
    }

    method bar () { "BAR" }

    method baz { "BAZ" }

    method slurpy_array ($foo, @args) {
        $foo . ': ' . join(', ', @args);
    }

    method slurpy_hash ($foo, %params) {
        $foo . ': ' . join(', ', map { $_ . ' => ' . $params{$_} } keys %params);
    }
}

my $foo_method = $Foo->find_method('foo');
ok( $foo_method, '... found the foo method' );
ok( $foo_method->isa( $::Method ), '... it is a proper method');

my $bar_method = $Foo->find_method('bar');
ok( $bar_method, '... found the bar method' );
ok( $bar_method->isa( $::Method ), '... it is a proper method');

my $baz_method = $Foo->find_method('baz');
ok( $baz_method, '... found the baz method' );
ok( $baz_method->isa( $::Method ), '... it is a proper method');

# We need to call this so that
# Foo gets set up properly and
# is given a v-table, etc, etc.
$Foo->FINALIZE;

my $foo = $Foo->new;
is( $foo->foo( 10, 20 ), '10, 20', '... got the right value from ->foo' );
is( $foo->bar, 'BAR', '... got the right value from ->bar' );
is( $foo->baz, 'BAZ', '... got the right value from ->baz' );
is( $foo->slurpy_array( "foo", 1, 2, 3 ), 'foo: 1, 2, 3');
is( $foo->slurpy_hash( "bar", a => 1, b => 2 ), 'bar: a => 1, b => 2');

done_testing;
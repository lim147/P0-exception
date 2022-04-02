(module
(import "P0lib" "write" (func $write (param i32)))
(import "P0lib" "writeln" (func $writeln))
(import "P0lib" "read" (func $read (result i32)))
(func $sqrt (param $x i32) (result i32)
(local $r i32)
(local $0 i32)
local.get $x
i32.const 0
i32.lt_s
if
throw 0
else
local.get $x
local.set $r
end
local.get $r)
(func $program
(local $a i32)
(local $0 i32)
i32.const 2
call $sqrt
local.set $a
local.get $a
call $write
)
(memory 1)
(start $program)
)
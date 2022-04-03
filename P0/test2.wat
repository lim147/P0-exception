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
(func $quadraticsolution (param $a i32) (param $b i32) (param $c i32) (result i32) (result i32)
(local $x i32)
(local $y i32)
(local $d i32)
(local $0 i32)
local.get $a
local.get $a
i32.mul
i32.const 4
local.get $a
i32.mul
local.get $c
i32.mul
i32.sub
call $sqrt
local.set $d
local.get $b
i32.const -1
i32.mul
local.get $d
i32.add
i32.const 2
local.get $a
i32.mul
i32.div_s
local.get $b
i32.const -1
i32.mul
local.get $d
i32.sub
i32.const 2
local.get $a
i32.mul
i32.div_s
local.set $y
local.set $x
local.get $x
local.get $y)
(func $program
(local $a i32)
(local $b i32)
(local $c i32)
(local $x i32)
(local $y i32)
(local $done i32)
(local $0 i32)
i32.const 0
local.set $done
loop
local.get $done
i32.eqz
if
try
call $read
local.set $a
call $read
local.set $b
call $read
local.set $c
local.get $a
local.get $b
local.get $c
call $quadraticsolution
local.set $y
local.set $x
local.get $x
call $write
local.get $y
call $write
catch 0
i32.const 1
local.set $done
br 1
end
br 1
end
end
)
(memory 1)
(start $program)
)
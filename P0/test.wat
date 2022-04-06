(module
  (import "P0lib" "write" (func $write (param i32)))
  (import "P0lib" "writeln" (func $writeln))
  (import "P0lib" "read" (func $read (result i32)))
  (tag $e1 (param i32))
  (tag $e2 (param i32))

  (func $test
     try
      i32.const 0
      throw $e2
     catch $e1
      drop
      i32.const 1
      call $write
     catch $e2
      drop
      i32.const 2
      call $write
    catch_all
    end
  )
 (start $test)
)

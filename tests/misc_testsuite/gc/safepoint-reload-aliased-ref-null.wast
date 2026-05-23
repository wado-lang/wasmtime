;;! gc = true
;;! function_references = true
;;! wide_arithmetic = true
;;! simd = true
;;! threads = true
;;! reference_types = true

;; Regression test for a Cranelift safepoint-spiller miscompile.
;;
;; Tracking issue: https://github.com/bytecodealliance/wasmtime/issues/13461
;;
;; A GC reference that is live across a call safepoint is reloaded (after
;; bytecodealliance/wasmtime#13228) from a stack slot that was never spilled,
;; so it reads back as null and a later `ref.as_non_null` traps.
;;
;; This module was produced by a real frontend (the Wado compiler): it
;; JSON-deserializes a two-field struct in a loop. The struct-access object is
;; built with `struct.new` (hence non-null) and is held in a local that is live
;; across the call that fetches the next field. On the second loop iteration the
;; reloaded local reads back null.
;;
;; Correct behavior: `(invoke "run")` returns without trapping (wasmtime 44).
;; Buggy behavior (wasmtime 45.0.0 .. 46.0.0-dev / first bad commit 24938c4163):
;;   `wasm trap: null reference`.
;;
;; The miscompile is register-allocation-sensitive, so the module does not
;; reduce under `wasm-tools shrink` (it is already DCE'd). Kept as-is.

(module
  (rec
    (type (;0;) (array (mut i8)))
    (type (;1;) (sub (struct (field (mut (ref 0))) (field (mut i32)))))
    (type (;2;) (sub (struct (field (mut (ref 1))) (field (mut i32)))))
    (type (;3;) (sub (struct (field (mut (ref 2))) (field (mut (ref struct))) (field (mut i8)))))
    (type (;4;) (sub (struct (field (mut i32)) (field (mut (ref 1))) (field (mut i64)))))
    (type (;5;) (sub (struct (field (mut i32)) (field (mut i32)) (field (mut i8)) (field (mut i8)) (field (mut i32)) (field (mut i32)) (field (mut i32)) (field (mut (ref 1))))))
    (type (;6;) (sub (struct)))
    (type (;7;) (sub (struct (field (mut f64)) (field (mut f64)))))
    (type (;8;) (array (mut i64)))
    (type (;9;) (sub (struct (field i32))))
    (type (;10;) (sub final 9 (struct (field i32) (field i32))))
    (type (;11;) (sub final 9 (struct (field i32))))
    (type (;12;) (sub (struct (field i32))))
    (type (;13;) (sub final 12 (struct (field i32) (field i32))))
    (type (;14;) (sub final 12 (struct (field i32))))
    (type (;15;) (sub (struct (field i32))))
    (type (;16;) (sub final 15 (struct (field i32) (field (ref 7)))))
    (type (;17;) (sub final 15 (struct (field i32) (field (ref 4)))))
    (type (;18;) (sub (struct (field i32))))
    (type (;19;) (sub final 18 (struct (field i32) (field i32))))
    (type (;20;) (sub final 18 (struct (field i32) (field (ref 4)))))
    (type (;21;) (sub (struct (field i32))))
    (type (;22;) (sub final 21 (struct (field i32) (field (ref 1)))))
    (type (;23;) (sub final 21 (struct (field i32) (field (ref 4)))))
    (type (;24;) (sub (struct (field (mut (ref 8))) (field (mut i32)))))
    (type (;25;) (func (param structref (ref 1) i32 i32) (result (ref 12))))
    (type (;26;) (sub (struct (field structref) (field (ref 25)))))
  )
  (type (;27;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;28;) (func (param i32 i32 i32) (result i32)))
  (type (;29;) (func (param i32)))
  (type (;30;) (func (param i32 i32)))
  (type (;31;) (func (param i32)))
  (type (;32;) (func (result i32)))
  (type (;33;) (func (param i32 i32) (result i32)))
  (type (;34;) (func (param i32) (result i32)))
  (type (;35;) (func))
  (type (;36;) (func (param (ref 1) i32 i32) (result (ref 12))))
  (type (;37;) (func))
  (type (;38;) (func (param (ref 1)) (result (ref 1))))
  (type (;39;) (func (param (ref 0) i32 i32)))
  (type (;40;) (func (param i32 (ref 1) i32)))
  (type (;41;) (func (param (ref 1))))
  (type (;42;) (func (param (ref 1))))
  (type (;43;) (func))
  (type (;44;) (func (param (ref 0) i32) (result i64)))
  (type (;45;) (func (param i32) (result i32)))
  (type (;46;) (func (param i32 (ref 0) i32)))
  (type (;47;) (func (param f64) (result i64 i32)))
  (type (;48;) (func (param i64 i64) (result i64)))
  (type (;49;) (func (param i32) (result i64 i64)))
  (type (;50;) (func (param i32) (result i64)))
  (type (;51;) (func (param i32) (result i64 i64)))
  (type (;52;) (func (param i64 i64 i64 i32) (result i64)))
  (type (;53;) (func (param f64 i32) (result i64 i32)))
  (type (;54;) (func (param f64) (result i64 i32)))
  (type (;55;) (func (param i64 i32) (result i64 i32)))
  (type (;56;) (func (param (ref 1) i32 i64 i32)))
  (type (;57;) (func (param (ref 1) i64 i32 i32)))
  (type (;58;) (func (param (ref 1) i64 i32 i32 i32)))
  (type (;59;) (func (param (ref 1) i64 i32 i32 i32)))
  (type (;60;) (func (param f64) (result i32 i32 i32)))
  (type (;61;) (func (param i64 i32) (result f64)))
  (type (;62;) (func (param i64 i32) (result f64)))
  (type (;63;) (func (param i64) (result i32)))
  (type (;64;) (func (param (ref 0) i32 i64 i32)))
  (type (;65;) (func (param (ref 5) i32 i32 (ref 1))))
  (type (;66;) (func))
  (type (;67;) (func (param i32) (result (ref 9))))
  (type (;68;) (func (param (ref 1) i32)))
  (type (;69;) (func (param (ref 1) i32) (result i32)))
  (type (;70;) (func (param (ref 1) i32 i32)))
  (type (;71;) (func (param (ref 1) (ref 1))))
  (type (;72;) (func (param (ref 1) (ref 1) i32 i32)))
  (type (;73;) (func (param (ref 1) i32)))
  (type (;74;) (func (param (ref 5) i32 i32)))
  (type (;75;) (func (param (ref 5) (ref 1))))
  (type (;76;) (func (param (ref 5) i32)))
  (type (;77;) (func (param (ref 5) i32 (ref 1) i32) (result i32)))
  (type (;78;) (func (param (ref 2))))
  (type (;79;) (func (param (ref 2) i32) (result (ref null 4))))
  (type (;80;) (func (param (ref 2)) (result (ref 21))))
  (type (;81;) (func (param (ref 2)) (result (ref 18))))
  (type (;82;) (func (param (ref 2))))
  (type (;83;) (func (param (ref 2)) (result (ref null 4))))
  (type (;84;) (func (param (ref 2)) (result (ref null 4))))
  (type (;85;) (func (param (ref 2)) (result (ref null 4))))
  (type (;86;) (func (param (ref 2)) (result (ref null 4))))
  (type (;87;) (func (param (ref 2)) (result (ref null 4))))
  (type (;88;) (func (param (ref 2)) (result (ref 15))))
  (type (;89;) (func (param (ref 1) i32 i32) (result (ref 12))))
  (type (;90;) (func (param i32)))
  (type (;91;) (func (result i64)))
  (type (;92;) (func (param i32)))
  (type (;93;) (func (param (ref 1)) (result i32 (ref null 7) (ref null 4))))
  (type (;94;) (func (param (ref 2)) (result i32 f64 (ref null 4))))
  (type (;95;) (func (param (ref 3)) (result i32 (ref null 12) (ref null 4))))
  (type (;96;) (func (param (ref 2) (ref 1) i32 (ref struct)) (result i32 (ref null 3) (ref null 4))))
  (type (;97;) (func (param i32) (result i32)))
  (type (;98;) (func (param i32) (result i32)))
  (type (;99;) (func (param i32 (ref 5))))
  (type (;100;) (func (param f64 (ref 5))))
  (type (;101;) (func (param f64 i32 (ref 5))))
  (type (;102;) (func (param i32 (ref 5))))
  (memory (;0;) 16)
  (global (;0;) (mut (ref null 24)) ref.null none)
  (global (;1;) (mut i32) i32.const 0)
  (global (;2;) (mut i32) i32.const 1024)
  (export "run" (func 13))
  (elem (;0;) declare func 76)
  (func (;0;) (type 27) (param i32 i32 i32 i32) (result i32)
    (local i32)
    local.get 2
    i32.const 8
    local.get 2
    select
    local.set 2
    global.get 2
    local.get 2
    i32.const 1
    i32.sub
    i32.add
    i32.const 0
    local.get 2
    i32.sub
    i32.and
    global.set 2
    global.get 2
    local.set 4
    global.get 2
    local.get 3
    i32.add
    global.set 2
    local.get 4
  )
  (func (;1;) (type 28) (param i32 i32 i32) (result i32)
    i32.const 0
  )
  (func (;2;) (type 29) (param i32))
  (func (;3;) (type 30) (param i32 i32))
  (func (;4;) (type 29) (param i32))
  (func (;5;) (type 32) (result i32)
    i32.const 0
  )
  (func (;6;) (type 33) (param i32 i32) (result i32)
    i32.const 0
  )
  (func (;7;) (type 34) (param i32) (result i32)
    i32.const 0
  )
  (func (;8;) (type 29) (param i32))
  (func (;9;) (type 91) (result i64)
    i64.const 0
  )
  (func (;10;) (type 29) (param i32))
  (func (;11;) (type 35)
    (local (ref null 7) f64 i32 f64 i32 (ref null 1) (ref null 5) (ref null 1) (ref null 5) (ref null 5) (ref null 5) (ref null 5) (ref null 5) i32 (ref null 7) (ref null 4))
    i32.const 0
    i32.const 17
    array.new_data 0 0
    i32.const 17
    struct.new 1
    call 42
    local.set 15
    local.set 14
    local.set 13
    local.get 13
    i32.eqz
    if ;; label = @1
      local.get 14
      ref.as_non_null
      local.set 0
      local.get 0
      struct.get 7 0
      local.set 1
      local.get 1
      f64.const 0x1.8p+0 (;=1.5;)
      f64.eq
      local.set 2
      local.get 2
      i32.eqz
      if ;; label = @2
        block (result (ref 1)) ;; label = @3
          i32.const 118
          array.new_default 0
          i32.const 0
          struct.new 1
          local.set 5
          local.get 5
          ref.as_non_null
          i32.const 0
          i32.const 20
          array.new_data 0 1
          i32.const 20
          struct.new 1
          call 54
          local.get 5
          ref.as_non_null
          i32.const 0
          i32.const 38
          array.new_data 0 2
          i32.const 38
          struct.new 1
          call 54
          local.get 5
          ref.as_non_null
          i32.const 32
          call 56
          local.get 5
          ref.as_non_null
          i32.const 97
          call 56
          local.get 5
          ref.as_non_null
          i32.const 116
          call 56
          local.get 5
          ref.as_non_null
          i32.const 32
          call 56
          local.get 5
          ref.as_non_null
          i32.const 0
          i32.const 19
          array.new_data 0 4
          i32.const 19
          struct.new 1
          call 54
          local.get 5
          ref.as_non_null
          i32.const 58
          call 56
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 5
          ref.as_non_null
          struct.new 5
          local.set 6
          local.get 6
          ref.as_non_null
          local.set 9
          i32.const 14
          local.get 9
          ref.as_non_null
          call 47
          local.get 5
          ref.as_non_null
          i32.const 0
          i32.const 23
          array.new_data 0 6
          i32.const 23
          struct.new 1
          call 54
          local.get 5
          ref.as_non_null
          i32.const 112
          call 56
          local.get 5
          ref.as_non_null
          i32.const 46
          call 56
          local.get 5
          ref.as_non_null
          i32.const 120
          call 56
          local.get 5
          ref.as_non_null
          i32.const 58
          call 56
          local.get 5
          ref.as_non_null
          i32.const 32
          call 56
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 5
          ref.as_non_null
          struct.new 5
          local.set 6
          local.get 6
          ref.as_non_null
          local.set 10
          local.get 1
          local.get 10
          ref.as_non_null
          call 48
          local.get 5
          ref.as_non_null
          i32.const 10
          call 56
          local.get 5
          ref.as_non_null
          br 0 (;@3;)
          unreachable
        end
        call 18
        unreachable
      end
      local.get 0
      struct.get 7 1
      local.set 3
      local.get 3
      f64.const 0x1.4p+1 (;=2.5;)
      f64.eq
      local.set 4
      local.get 4
      i32.eqz
      if ;; label = @2
        block (result (ref 1)) ;; label = @3
          i32.const 118
          array.new_default 0
          i32.const 0
          struct.new 1
          local.set 7
          local.get 7
          ref.as_non_null
          i32.const 0
          i32.const 20
          array.new_data 0 1
          i32.const 20
          struct.new 1
          call 54
          local.get 7
          ref.as_non_null
          i32.const 0
          i32.const 38
          array.new_data 0 2
          i32.const 38
          struct.new 1
          call 54
          local.get 7
          ref.as_non_null
          i32.const 32
          call 56
          local.get 7
          ref.as_non_null
          i32.const 97
          call 56
          local.get 7
          ref.as_non_null
          i32.const 116
          call 56
          local.get 7
          ref.as_non_null
          i32.const 32
          call 56
          local.get 7
          ref.as_non_null
          i32.const 0
          i32.const 19
          array.new_data 0 4
          i32.const 19
          struct.new 1
          call 54
          local.get 7
          ref.as_non_null
          i32.const 58
          call 56
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 7
          ref.as_non_null
          struct.new 5
          local.set 8
          local.get 8
          ref.as_non_null
          local.set 11
          i32.const 15
          local.get 11
          ref.as_non_null
          call 47
          local.get 7
          ref.as_non_null
          i32.const 0
          i32.const 23
          array.new_data 0 9
          i32.const 23
          struct.new 1
          call 54
          local.get 7
          ref.as_non_null
          i32.const 112
          call 56
          local.get 7
          ref.as_non_null
          i32.const 46
          call 56
          local.get 7
          ref.as_non_null
          i32.const 121
          call 56
          local.get 7
          ref.as_non_null
          i32.const 58
          call 56
          local.get 7
          ref.as_non_null
          i32.const 32
          call 56
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 7
          ref.as_non_null
          struct.new 5
          local.set 8
          local.get 8
          ref.as_non_null
          local.set 12
          local.get 3
          local.get 12
          ref.as_non_null
          call 48
          local.get 7
          ref.as_non_null
          i32.const 10
          call 56
          local.get 7
          ref.as_non_null
          br 0 (;@3;)
          unreachable
        end
        call 18
        unreachable
      end
    else
      i32.const 0
      i32.const 24
      array.new_data 0 11
      i32.const 24
      struct.new 1
      call 18
      unreachable
    end
  )
  (func (;12;) (type 36) (param (ref 1) i32 i32) (result (ref 12))
    (local i32 i32 i32)
    local.get 2
    local.get 1
    i32.sub
    local.set 3
    local.get 3
    i32.const 1
    i32.eq
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 1
        i32.const 0
        i32.add
        local.set 4
        local.get 0
        struct.get 1 0
        local.get 4
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 120
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      i32.const 0
      i32.const 0
      struct.new 13
      return
    end
    local.get 3
    i32.const 1
    i32.eq
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 1
        i32.const 0
        i32.add
        local.set 5
        local.get 0
        struct.get 1 0
        local.get 5
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 121
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      i32.const 0
      i32.const 1
      struct.new 13
      return
    end
    i32.const 1
    struct.new 12
    return
    unreachable
  )
  (func (;13;) (type 37)
    block ;; label = @1
      global.get 1
      if ;; label = @2
        br 1 (;@1;)
      end
      call 43
      i32.const 1
      global.set 1
    end
    call 11
    i32.const 0
    call 2
  )
  (func (;14;) (type 38) (param (ref 1)) (result (ref 1))
    (local (ref 0) (ref 0) i32 i32)
    local.get 0
    struct.get 1 0
    local.set 1
    local.get 1
    array.len
    local.set 3
    local.get 3
    array.new_default 0
    local.set 2
    i32.const 0
    local.set 4
    block ;; label = @1
      loop ;; label = @2
        local.get 4
        local.get 3
        i32.ge_s
        br_if 1 (;@1;)
        local.get 2
        local.get 4
        local.get 1
        local.get 4
        array.get_u 0
        array.set 0
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        br 0 (;@2;)
      end
    end
    local.get 2
    ref.as_non_null
    local.get 0
    struct.get 1 1
    struct.new 1
    return
    unreachable
  )
  (func (;15;) (type 39) (param (ref 0) i32 i32)
    (local i32)
    block ;; label = @1
      i32.const 0
      local.set 3
      block ;; label = @2
        loop ;; label = @3
          local.get 3
          local.get 2
          i32.ge_s
          if ;; label = @4
            br 3 (;@1;)
          end
          local.get 1
          local.get 3
          i32.add
          local.get 0
          local.get 3
          array.get_u 0
          i32.store8
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          br 0 (;@3;)
        end
      end
    end
  )
  (func (;16;) (type 40) (param i32 (ref 1) i32)
    (local (ref null 0) i32 (ref null 0) (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 1
    struct.get 1 0
    local.set 3
    local.get 1
    struct.get 1 1
    local.set 4
    local.get 2
    if ;; label = @1
      local.get 4
      i32.const 1
      i32.add
      array.new_default 0
      local.set 5
      local.get 5
      ref.as_non_null
      local.set 6
      i32.const 0
      local.set 8
      local.get 3
      ref.as_non_null
      local.set 7
      i32.const 0
      local.set 9
      local.get 4
      local.set 10
      local.get 8
      local.get 9
      i32.gt_s
      if ;; label = @2
        local.get 10
        local.set 11
        block ;; label = @3
          loop ;; label = @4
            local.get 11
            i32.const 0
            i32.le_s
            br_if 1 (;@3;)
            local.get 11
            i32.const 1
            i32.sub
            local.set 11
            local.get 6
            local.get 8
            local.get 11
            i32.add
            local.get 7
            local.get 9
            local.get 11
            i32.add
            array.get_u 0
            array.set 0
            br 0 (;@4;)
          end
        end
      else
        i32.const 0
        local.set 11
        block ;; label = @3
          loop ;; label = @4
            local.get 11
            local.get 10
            i32.ge_s
            br_if 1 (;@3;)
            local.get 6
            local.get 8
            local.get 11
            i32.add
            local.get 7
            local.get 9
            local.get 11
            i32.add
            array.get_u 0
            array.set 0
            local.get 11
            i32.const 1
            i32.add
            local.set 11
            br 0 (;@4;)
          end
        end
      end
      local.get 5
      local.get 4
      i32.const 10
      array.set 0
      local.get 0
      local.get 5
      ref.as_non_null
      local.get 4
      i32.const 1
      i32.add
      call 22
    else
      local.get 0
      local.get 3
      ref.as_non_null
      local.get 4
      call 22
    end
    local.get 0
    call 8
  )
  (func (;17;) (type 41) (param (ref 1))
    (local i32 i64 i32 i32)
    call 9
    local.set 2
    local.get 2
    i32.wrap_i64
    local.get 2
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    local.set 4
    local.set 3
    local.get 3
    call 7
    local.set 1
    local.get 4
    local.get 0
    i32.const 1
    call 16
    local.get 1
    call 10
  )
  (func (;18;) (type 42) (param (ref 1))
    local.get 0
    call 17
    unreachable
  )
  (func (;19;) (type 43)
    unreachable
  )
  (func (;20;) (type 44) (param (ref 0) i32) (result i64)
    (local i32)
    i32.const 0
    i32.const 0
    i32.const 1
    local.get 1
    call 0
    local.set 2
    local.get 0
    local.get 2
    local.get 1
    call 15
    local.get 2
    i64.extend_i32_s
    local.get 1
    i64.extend_i32_s
    i64.const 32
    i64.shl
    i64.or
    return
    unreachable
  )
  (func (;21;) (type 45) (param i32) (result i32)
    (local i32 i32 i32)
    call 5
    local.set 1
    local.get 0
    local.get 1
    call 3
    i32.const 0
    i32.const 0
    i32.const 4
    i32.const 8
    call 0
    local.set 2
    local.get 1
    local.get 2
    call 6
    drop
    local.get 2
    i32.const 4
    i32.add
    i32.load
    local.set 3
    local.get 2
    i32.const 8
    i32.const 4
    i32.const 0
    call 0
    drop
    local.get 1
    call 4
    local.get 3
    return
    unreachable
  )
  (func (;22;) (type 46) (param i32 (ref 0) i32)
    (local i64 i32 i32 i32)
    local.get 1
    local.get 2
    call 20
    local.set 3
    local.get 3
    i32.wrap_i64
    local.set 4
    local.get 3
    i64.const 32
    i64.shr_s
    i32.wrap_i64
    local.set 5
    local.get 0
    local.get 4
    local.get 5
    call 1
    local.set 6
    local.get 6
    i32.const -1
    i32.eq
    if ;; label = @1
      local.get 0
      call 21
      drop
    end
    local.get 4
    local.get 5
    i32.const 1
    i32.const 0
    call 0
    drop
  )
  (func (;23;) (type 47) (param f64) (result i64 i32)
    (local i64 i64 i32 i64 i64 i64 i32)
    block (result i64) ;; label = @1
      local.get 0
      i64.reinterpret_f64
      br 0 (;@1;)
      unreachable
    end
    local.set 1
    local.get 1
    i64.const 4503599627370495
    i64.and
    local.set 2
    local.get 1
    i64.const 52
    i64.shr_u
    i64.const 2047
    i64.and
    i32.wrap_i64
    local.set 3
    local.get 3
    i32.eqz
    if ;; label = @1
      local.get 2
      i64.eqz
      if ;; label = @2
        i64.const 0
        i32.const 0
        return
      end
      local.get 2
      i64.const 11
      i64.shl
      local.set 4
      i32.const 64
      i32.const 64
      local.get 4
      i64.clz
      i32.wrap_i64
      i32.sub
      i32.sub
      i64.extend_i32_s
      local.set 5
      local.get 4
      local.get 5
      i64.shl
      i32.const -1085
      local.get 5
      i32.wrap_i64
      i32.sub
      return
    end
    i64.const -9223372036854775808
    local.get 2
    i64.const 11
    i64.shl
    i64.or
    local.set 6
    local.get 3
    i32.const 1
    i32.sub
    i32.const -1085
    i32.add
    local.set 7
    local.get 6
    local.get 7
    return
    unreachable
  )
  (func (;24;) (type 48) (param i64 i64) (result i64)
    (local i64 i64)
    local.get 0
    local.get 1
    i64.div_u
    local.set 2
    local.get 0
    local.get 1
    i64.rem_u
    local.set 3
    local.get 2
    local.get 0
    i64.const 1
    i64.and
    i64.or
    local.get 3
    i64.const 0
    i64.ne
    i64.extend_i32_u
    i64.or
    return
    unreachable
  )
  (func (;25;) (type 49) (param i32) (result i64 i64)
    block ;; label = @1
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            block ;; label = @5
              block ;; label = @6
                block ;; label = @7
                  block ;; label = @8
                    block ;; label = @9
                      block ;; label = @10
                        block ;; label = @11
                          block ;; label = @12
                            block ;; label = @13
                              block ;; label = @14
                                block ;; label = @15
                                  block ;; label = @16
                                    block ;; label = @17
                                      block ;; label = @18
                                        block ;; label = @19
                                          block ;; label = @20
                                            block ;; label = @21
                                              block ;; label = @22
                                                block ;; label = @23
                                                  block ;; label = @24
                                                    block ;; label = @25
                                                      block ;; label = @26
                                                        block ;; label = @27
                                                          block ;; label = @28
                                                            local.get 0
                                                            br_table 1 (;@27;) 2 (;@26;) 3 (;@25;) 4 (;@24;) 5 (;@23;) 6 (;@22;) 7 (;@21;) 8 (;@20;) 9 (;@19;) 10 (;@18;) 11 (;@17;) 12 (;@16;) 13 (;@15;) 14 (;@14;) 15 (;@13;) 16 (;@12;) 17 (;@11;) 18 (;@10;) 19 (;@9;) 20 (;@8;) 21 (;@7;) 22 (;@6;) 23 (;@5;) 24 (;@4;) 25 (;@3;) 26 (;@2;) 0 (;@28;)
                                                          end
                                                          call 19
                                                          unreachable
                                                          br 26 (;@1;)
                                                        end
                                                        i64.const -9202643304706469457
                                                        i64.const -2331608335343510137
                                                        return
                                                      end
                                                      i64.const -3512093806901185045
                                                      i64.const -5910495864778290618
                                                      return
                                                    end
                                                    i64.const -6382629663588669918
                                                    i64.const 5824576295778454961
                                                    return
                                                  end
                                                  i64.const -8701430062309552535
                                                  i64.const -6518754469289960082
                                                  return
                                                end
                                                i64.const -2702340141148116919
                                                i64.const 5820440219632367201
                                                return
                                              end
                                              i64.const -5728515861582144019
                                              i64.const 4788037454677749836
                                              return
                                            end
                                            i64.const -8173041140997884609
                                            i64.const -6088502188546649757
                                            return
                                          end
                                          i64.const -1848681798185579781
                                          i64.const -915538744049291539
                                          return
                                        end
                                        i64.const -5038936143766954516
                                        i64.const 7857851839894723564
                                        return
                                      end
                                      i64.const -7616003081050118570
                                      i64.const -4209185567039092848
                                      return
                                    end
                                    i64.const -948738275445456221
                                    i64.const 368606216923924028
                                    return
                                  end
                                  i64.const -4311967555482476979
                                  i64.const 6154202648235558777
                                  return
                                end
                                i64.const -7028762532061872567
                                i64.const -8601490892183123070
                                return
                              end
                              i64.const -9223372036854775808
                              i64.const 0
                              return
                            end
                            i64.const -3545582879861895366
                            i64.const 0
                            return
                          end
                          i64.const -6409681921289327534
                          i64.const 7381240676301154012
                          return
                        end
                        i64.const -8723282702051517698
                        i64.const -7611128154919104932
                        return
                      end
                      i64.const -2737644984756826646
                      i64.const 1725319251657714538
                      return
                    end
                    i64.const -5757034887131305499
                    i64.const -6827560182880305040
                    return
                  end
                  i64.const -8196078626372074882
                  i64.const -1466078993672598280
                  return
                end
                i64.const -1885900863153361278
                i64.const 8136200465769716229
                return
              end
              i64.const -5069001465015685406
              i64.const -7896285879677171347
              return
            end
            i64.const -7640289654143017766
            i64.const -5385653213018257807
            return
          end
          i64.const -987975350460687152
          i64.const 4871985254153548563
          return
        end
        i64.const -4343663012265570552
        i64.const -758345818024902857
        return
      end
      i64.const -7054365918152680534
      i64.const -7784369436827535058
      return
    end
    unreachable
  )
  (func (;26;) (type 50) (param i32) (result i64)
    block (result i64) ;; label = @1
      block ;; label = @2
        block ;; label = @3
          block ;; label = @4
            block ;; label = @5
              block ;; label = @6
                block ;; label = @7
                  block ;; label = @8
                    block ;; label = @9
                      block ;; label = @10
                        block ;; label = @11
                          block ;; label = @12
                            block ;; label = @13
                              block ;; label = @14
                                block ;; label = @15
                                  block ;; label = @16
                                    block ;; label = @17
                                      block ;; label = @18
                                        block ;; label = @19
                                          block ;; label = @20
                                            block ;; label = @21
                                              block ;; label = @22
                                                block ;; label = @23
                                                  block ;; label = @24
                                                    block ;; label = @25
                                                      block ;; label = @26
                                                        block ;; label = @27
                                                          block ;; label = @28
                                                            block ;; label = @29
                                                              local.get 0
                                                              br_table 1 (;@28;) 2 (;@27;) 3 (;@26;) 4 (;@25;) 5 (;@24;) 6 (;@23;) 7 (;@22;) 8 (;@21;) 9 (;@20;) 10 (;@19;) 11 (;@18;) 12 (;@17;) 13 (;@16;) 14 (;@15;) 15 (;@14;) 16 (;@13;) 17 (;@12;) 18 (;@11;) 19 (;@10;) 20 (;@9;) 21 (;@8;) 22 (;@7;) 23 (;@6;) 24 (;@5;) 25 (;@4;) 26 (;@3;) 27 (;@2;) 0 (;@29;)
                                                            end
                                                            call 19
                                                            unreachable
                                                            br 27 (;@1;)
                                                          end
                                                          i64.const -9223372036854775808
                                                          br 26 (;@1;)
                                                        end
                                                        i64.const -6917529027641081856
                                                        br 25 (;@1;)
                                                      end
                                                      i64.const -4035225266123964416
                                                      br 24 (;@1;)
                                                    end
                                                    i64.const -432345564227567616
                                                    br 23 (;@1;)
                                                  end
                                                  i64.const -7187745005283311616
                                                  br 22 (;@1;)
                                                end
                                                i64.const -4372995238176751616
                                                br 21 (;@1;)
                                              end
                                              i64.const -854558029293551616
                                              br 20 (;@1;)
                                            end
                                            i64.const -7451627795949551616
                                            br 19 (;@1;)
                                          end
                                          i64.const -4702848726509551616
                                          br 18 (;@1;)
                                        end
                                        i64.const -1266874889709551616
                                        br 17 (;@1;)
                                      end
                                      i64.const -7709325833709551616
                                      br 16 (;@1;)
                                    end
                                    i64.const -5024971273709551616
                                    br 15 (;@1;)
                                  end
                                  i64.const -1669528073709551616
                                  br 14 (;@1;)
                                end
                                i64.const -7960984073709551616
                                br 13 (;@1;)
                              end
                              i64.const -5339544073709551616
                              br 12 (;@1;)
                            end
                            i64.const -2062744073709551616
                            br 11 (;@1;)
                          end
                          i64.const -8206744073709551616
                          br 10 (;@1;)
                        end
                        i64.const -5646744073709551616
                        br 9 (;@1;)
                      end
                      i64.const -2446744073709551616
                      br 8 (;@1;)
                    end
                    i64.const -8446744073709551616
                    br 7 (;@1;)
                  end
                  i64.const -5946744073709551616
                  br 6 (;@1;)
                end
                i64.const -2821744073709551616
                br 5 (;@1;)
              end
              i64.const -8681119073709551616
              br 4 (;@1;)
            end
            i64.const -6239712823709551616
            br 3 (;@1;)
          end
          i64.const -3187955011209551616
          br 2 (;@1;)
        end
        i64.const -8910000909647051616
        br 1 (;@1;)
      end
      i64.const -6525815118631426616
    end
    return
    unreachable
  )
  (func (;27;) (type 51) (param i32) (result i64 i64)
    (local i32 i32 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)
    local.get 0
    i32.const 27
    i32.div_s
    local.set 1
    local.get 0
    i32.const 27
    i32.rem_s
    local.set 2
    local.get 2
    i32.const 0
    i32.lt_s
    if ;; label = @1
      local.get 1
      i32.const 1
      i32.sub
      local.set 1
      local.get 2
      i32.const 27
      i32.add
      local.set 2
    end
    local.get 1
    i32.const -13
    i32.sub
    call 25
    local.set 12
    local.set 11
    local.get 2
    call 26
    local.set 3
    local.get 12
    i64.const 0
    i64.ne
    i64.extend_i32_u
    local.set 4
    local.get 11
    local.get 4
    i64.sub
    local.set 5
    i64.const 0
    local.get 12
    i64.sub
    local.set 6
    local.get 5
    local.get 3
    i64.mul_wide_u
    local.set 14
    local.set 13
    local.get 6
    local.get 3
    i64.mul_wide_u
    local.set 16
    local.set 15
    local.get 13
    local.get 16
    i64.add
    local.set 7
    local.get 7
    local.get 13
    i64.lt_u
    i64.extend_i32_u
    local.set 8
    local.get 7
    local.set 9
    local.get 14
    local.get 8
    i64.add
    local.set 10
    local.get 15
    i64.const 0
    i64.ne
    if ;; label = @1
      local.get 9
      i64.const 1
      i64.add
      local.set 9
      local.get 9
      i64.eqz
      if ;; label = @2
        local.get 10
        i64.const 1
        i64.add
        local.set 10
      end
    end
    local.get 10
    i64.const 63
    i64.shr_u
    i64.eqz
    if ;; label = @1
      local.get 10
      i64.const 1
      i64.shl
      local.get 9
      i64.const 63
      i64.shr_u
      i64.or
      local.set 10
      local.get 9
      i64.const 1
      i64.shl
      local.set 9
    end
    local.get 9
    i64.const 0
    i64.ne
    if ;; label = @1
      local.get 10
      i64.const 1
      i64.add
      i64.const 0
      local.get 9
      i64.sub
      return
    end
    local.get 10
    i64.const 0
    return
    unreachable
  )
  (func (;28;) (type 52) (param i64 i64 i64 i32) (result i64)
    (local i64 i64 i64 i64 i64 i64 i64 i64)
    local.get 0
    local.get 1
    i64.mul_wide_u
    local.set 9
    local.set 8
    local.get 9
    local.set 4
    i64.const 1
    local.set 5
    local.get 3
    i32.const 63
    i32.and
    i64.extend_i32_s
    local.set 6
    i64.const 1
    local.get 6
    i64.shl
    i64.const 1
    i64.sub
    local.set 7
    local.get 4
    local.get 7
    i64.and
    i64.eqz
    if ;; label = @1
      local.get 0
      local.get 2
      i64.mul_wide_u
      local.set 11
      local.set 10
      local.get 8
      local.get 11
      i64.sub
      i64.const 1
      i64.gt_u
      i64.extend_i32_u
      local.set 5
      local.get 4
      local.get 8
      local.get 11
      i64.lt_u
      i64.extend_i32_u
      i64.sub
      local.set 4
    end
    local.get 4
    local.get 3
    i64.extend_i32_s
    i64.shr_u
    local.get 5
    i64.or
    return
    unreachable
  )
  (func (;29;) (type 53) (param f64 i32) (result i64 i32)
    (local i32 i32 i32 i32 i64 i64 i32 i32 i32 i32 i32 i32 i64 i64 i32 i64 (ref null 24) i64 i32 i64 i64 i64 i64)
    local.get 0
    call 23
    local.set 20
    local.set 19
    block (result i32) ;; label = @1
      local.get 20
      i32.const 63
      i32.add
      local.set 16
      local.get 16
      i32.const 78913
      i32.mul
      i32.const 18
      i32.shr_s
      br 0 (;@1;)
      unreachable
    end
    local.set 2
    i32.const 0
    local.get 2
    i32.sub
    local.set 3
    local.get 3
    i32.const 108853
    i32.mul
    i32.const 15
    i32.shr_s
    local.set 4
    local.get 3
    call 27
    local.set 22
    local.set 21
    i32.const 0
    local.get 20
    local.get 4
    i32.add
    i32.const 3
    i32.add
    i32.sub
    local.set 5
    local.get 19
    local.get 21
    local.get 22
    local.get 5
    call 28
    local.set 6
    local.get 6
    i64.const 0
    i64.add
    i64.const 2
    i64.shr_u
    local.set 7
    local.get 7
    i64.const 10
    i64.ge_u
    if (result i32) ;; label = @1
      i32.const 2
      local.get 3
      i32.sub
    else
      i32.const 1
      local.get 3
      i32.sub
    end
    local.set 8
    local.get 8
    local.get 1
    i32.add
    local.set 9
    local.get 9
    i32.const 18
    i32.gt_s
    if (result i32) ;; label = @1
      i32.const 18
    else
      i32.const 1
      local.get 9
      local.get 9
      i32.const 1
      i32.lt_s
      select (result i32)
    end
    local.set 10
    local.get 10
    i32.const 1
    i32.sub
    local.get 2
    i32.sub
    local.set 11
    local.get 11
    i32.const 108853
    i32.mul
    i32.const 15
    i32.shr_s
    local.set 12
    local.get 11
    call 27
    local.set 24
    local.set 23
    i32.const 0
    local.get 20
    local.get 12
    i32.add
    i32.const 3
    i32.add
    i32.sub
    local.set 13
    local.get 19
    local.get 23
    local.get 24
    local.get 13
    call 28
    local.set 14
    local.get 14
    i64.const 1
    i64.add
    local.get 14
    i64.const 2
    i64.shr_u
    i64.const 1
    i64.and
    i64.add
    i64.const 2
    i64.shr_u
    local.set 15
    local.get 15
    block (result i64) ;; label = @1
      global.get 0
      ref.as_non_null
      local.set 18
      local.get 10
      local.get 18
      struct.get 24 1
      i32.ge_s
      if ;; label = @2
        i32.const 0
        i32.const 19
        array.new_data 0 25
        i32.const 19
        struct.new 1
        call 18
        unreachable
      end
      local.get 18
      struct.get 24 0
      local.get 10
      array.get 8
      br 0 (;@1;)
      unreachable
    end
    i64.ge_u
    if ;; label = @1
      block (result i64) ;; label = @2
        local.get 14
        i64.const 10
        call 24
        local.set 17
        local.get 17
        i64.const 1
        i64.add
        local.get 17
        i64.const 2
        i64.shr_u
        i64.const 1
        i64.and
        i64.add
        i64.const 2
        i64.shr_u
        br 0 (;@2;)
        unreachable
      end
      local.set 15
      local.get 15
      i32.const 0
      local.get 11
      i32.sub
      i32.const 1
      i32.add
      return
    end
    local.get 15
    i32.const 0
    local.get 11
    i32.sub
    return
    unreachable
  )
  (func (;30;) (type 54) (param f64) (result i64 i32)
    (local i64 i32 i32 i32 i64 i32 i32 i32 i64 i64 i64 i32 i64 i32 i32 i64 i64 i64 i64 i32 i64 i64 i32 i64 i64 i64 i32)
    local.get 0
    call 23
    local.set 23
    local.set 22
    i64.const 0
    local.set 1
    i32.const 11
    local.set 2
    i32.const 0
    local.set 3
    local.get 22
    i64.const -9223372036854775808
    i64.eq
    local.set 4
    local.get 4
    if (result i32) ;; label = @1
      local.get 23
      i32.const -1085
      i32.gt_s
    else
      i32.const 0
    end
    if ;; label = @1
      i32.const 0
      block (result i32) ;; label = @2
        local.get 23
        i32.const 11
        i32.add
        local.set 14
        local.get 14
        i32.const 631305
        i32.mul
        i32.const 261663
        i32.sub
        i32.const 21
        i32.shr_s
        br 0 (;@2;)
        unreachable
      end
      i32.sub
      local.set 3
      local.get 22
      i64.const 512
      i64.sub
      local.set 1
    else
      local.get 23
      i32.const -1085
      i32.lt_s
      if ;; label = @2
        i32.const 11
        i32.const -1085
        local.get 23
        i32.sub
        i32.add
        local.set 2
      end
      i32.const 0
      block (result i32) ;; label = @2
        local.get 23
        local.get 2
        i32.add
        local.set 15
        local.get 15
        i32.const 78913
        i32.mul
        i32.const 18
        i32.shr_s
        br 0 (;@2;)
        unreachable
      end
      i32.sub
      local.set 3
      local.get 22
      i64.const 1
      local.get 2
      i32.const 1
      i32.sub
      i64.extend_i32_s
      i64.shl
      i64.sub
      local.set 1
    end
    local.get 22
    i64.const 1
    local.get 2
    i32.const 1
    i32.sub
    i64.extend_i32_s
    i64.shl
    i64.add
    local.set 5
    local.get 22
    local.get 2
    i64.extend_i32_s
    i64.shr_u
    i64.const 1
    i64.and
    i32.wrap_i64
    local.set 6
    local.get 3
    i32.const 108853
    i32.mul
    i32.const 15
    i32.shr_s
    local.set 7
    local.get 3
    call 27
    local.set 25
    local.set 24
    i32.const 0
    local.get 23
    local.get 7
    i32.add
    i32.const 3
    i32.add
    i32.sub
    local.set 8
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 1
        local.get 24
        local.get 25
        local.get 8
        call 28
        local.set 17
        local.get 17
        local.get 6
        i64.extend_i32_s
        i64.add
        br 0 (;@2;)
        unreachable
      end
      local.set 16
      local.get 16
      i64.const 3
      i64.add
      i64.const 2
      i64.shr_u
      br 0 (;@1;)
      unreachable
    end
    local.set 9
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 5
        local.get 24
        local.get 25
        local.get 8
        call 28
        local.set 19
        i32.const 0
        local.get 6
        i32.sub
        local.set 20
        local.get 19
        local.get 20
        i64.extend_i32_s
        i64.add
        br 0 (;@2;)
        unreachable
      end
      local.set 18
      local.get 18
      i64.const 0
      i64.add
      i64.const 2
      i64.shr_u
      br 0 (;@1;)
      unreachable
    end
    local.set 10
    local.get 10
    i64.const 10
    i64.div_u
    local.set 11
    local.get 11
    i64.const 10
    i64.mul
    local.get 9
    i64.ge_u
    local.set 12
    local.get 12
    if ;; label = @1
      local.get 11
      i32.const 0
      local.get 3
      i32.const 1
      i32.sub
      i32.sub
      call 31
      local.set 27
      local.set 26
      local.get 26
      local.get 27
      return
    end
    local.get 9
    local.set 13
    local.get 9
    local.get 10
    i64.lt_u
    if ;; label = @1
      block (result i64) ;; label = @2
        local.get 22
        local.get 24
        local.get 25
        local.get 8
        call 28
        local.set 21
        local.get 21
        i64.const 1
        i64.add
        local.get 21
        i64.const 2
        i64.shr_u
        i64.const 1
        i64.and
        i64.add
        i64.const 2
        i64.shr_u
        br 0 (;@2;)
        unreachable
      end
      local.set 13
    end
    local.get 13
    i32.const 0
    local.get 3
    i32.sub
    return
    unreachable
  )
  (func (;31;) (type 55) (param i64 i32) (result i64 i32)
    (local i64 i32 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)
    local.get 0
    local.set 2
    local.get 1
    local.set 3
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 2
        i64.const -3689348814741910323
        i64.mul_wide_u
        local.set 15
        local.set 14
        local.get 14
        br 0 (;@2;)
        unreachable
      end
      local.set 9
      local.get 9
      i64.const 1
      i64.shr_u
      local.get 9
      i64.const 63
      i64.shl
      i64.or
      br 0 (;@1;)
      unreachable
    end
    local.set 4
    local.get 4
    i64.const 1844674407370955161
    i64.le_u
    if ;; label = @1
      local.get 4
      local.set 2
      local.get 3
      i32.const 1
      i32.add
      local.set 3
    else
      local.get 2
      local.get 3
      return
    end
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 2
        i64.const -4078282918271054303
        i64.mul_wide_u
        local.set 17
        local.set 16
        local.get 16
        br 0 (;@2;)
        unreachable
      end
      local.set 10
      local.get 10
      i64.const 8
      i64.shr_u
      local.get 10
      i64.const 56
      i64.shl
      i64.or
      br 0 (;@1;)
      unreachable
    end
    local.set 5
    local.get 5
    i64.const 184467440737
    i64.le_u
    if ;; label = @1
      local.get 5
      local.set 2
      local.get 3
      i32.const 8
      i32.add
      local.set 3
    end
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 2
        i64.const -3276141747490816367
        i64.mul_wide_u
        local.set 19
        local.set 18
        local.get 18
        br 0 (;@2;)
        unreachable
      end
      local.set 11
      local.get 11
      i64.const 4
      i64.shr_u
      local.get 11
      i64.const 60
      i64.shl
      i64.or
      br 0 (;@1;)
      unreachable
    end
    local.set 6
    local.get 6
    i64.const 1844674407370955
    i64.le_u
    if ;; label = @1
      local.get 6
      local.set 2
      local.get 3
      i32.const 4
      i32.add
      local.set 3
    end
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 2
        i64.const -8116567392432202711
        i64.mul_wide_u
        local.set 21
        local.set 20
        local.get 20
        br 0 (;@2;)
        unreachable
      end
      local.set 12
      local.get 12
      i64.const 2
      i64.shr_u
      local.get 12
      i64.const 62
      i64.shl
      i64.or
      br 0 (;@1;)
      unreachable
    end
    local.set 7
    local.get 7
    i64.const 184467440737095516
    i64.le_u
    if ;; label = @1
      local.get 7
      local.set 2
      local.get 3
      i32.const 2
      i32.add
      local.set 3
    end
    block (result i64) ;; label = @1
      block (result i64) ;; label = @2
        local.get 2
        i64.const -3689348814741910323
        i64.mul_wide_u
        local.set 23
        local.set 22
        local.get 22
        br 0 (;@2;)
        unreachable
      end
      local.set 13
      local.get 13
      i64.const 1
      i64.shr_u
      local.get 13
      i64.const 63
      i64.shl
      i64.or
      br 0 (;@1;)
      unreachable
    end
    local.set 8
    local.get 8
    i64.const 1844674407370955161
    i64.le_u
    if ;; label = @1
      local.get 8
      local.set 2
      local.get 3
      i32.const 1
      i32.add
      local.set 3
    end
    local.get 2
    local.get 3
    return
    unreachable
  )
  (func (;32;) (type 56) (param (ref 1) i32 i64 i32)
    (local i64 i32 i32 (ref null 0))
    local.get 2
    local.set 4
    local.get 1
    local.get 3
    i32.add
    i32.const 1
    i32.sub
    local.set 5
    local.get 0
    struct.get 1 0
    local.set 7
    block ;; label = @1
      loop ;; label = @2
        local.get 5
        local.get 1
        i32.lt_s
        if ;; label = @3
          br 2 (;@1;)
        end
        i32.const 48
        local.get 4
        i64.const 10
        i64.rem_u
        i32.wrap_i64
        i32.const 255
        i32.and
        i32.add
        i32.const 255
        i32.and
        local.set 6
        local.get 7
        local.get 5
        local.get 6
        array.set 0
        local.get 4
        i64.const 10
        i64.div_u
        local.set 4
        local.get 5
        i32.const 1
        i32.sub
        local.set 5
        br 0 (;@2;)
      end
    end
  )
  (func (;33;) (type 57) (param (ref 1) i64 i32 i32)
    (local i32 i32 i32 i32 (ref null 0) i32 i32 i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 3
    local.get 2
    i32.add
    local.set 4
    local.get 4
    i32.const 0
    i32.le_s
    if ;; label = @1
      local.get 0
      i32.const 48
      call 56
      local.get 0
      i32.const 46
      call 56
      i32.const 0
      local.get 4
      i32.sub
      local.set 9
      local.get 0
      i32.const 48
      local.get 9
      call 53
      local.get 0
      struct.get 1 1
      local.set 5
      local.get 0
      i32.const 48
      local.get 3
      call 53
      local.get 0
      local.get 5
      local.get 1
      local.get 3
      call 32
    else
      local.get 4
      local.get 3
      i32.ge_s
      if ;; label = @2
        local.get 0
        struct.get 1 1
        local.set 6
        local.get 0
        i32.const 48
        local.get 3
        call 53
        local.get 0
        local.get 6
        local.get 1
        local.get 3
        call 32
        local.get 4
        local.get 3
        i32.sub
        local.set 10
        local.get 0
        i32.const 48
        local.get 10
        call 53
      else
        local.get 0
        struct.get 1 1
        local.set 7
        local.get 3
        i32.const 1
        i32.add
        local.set 11
        local.get 0
        i32.const 48
        local.get 11
        call 53
        local.get 0
        local.get 7
        local.get 1
        local.get 3
        call 32
        local.get 0
        struct.get 1 0
        local.set 8
        local.get 8
        ref.as_non_null
        local.set 13
        local.get 7
        local.get 4
        i32.add
        i32.const 1
        i32.add
        local.set 15
        local.get 8
        ref.as_non_null
        local.set 14
        local.get 7
        local.get 4
        i32.add
        local.set 16
        local.get 3
        local.get 4
        i32.sub
        local.set 17
        local.get 15
        local.get 16
        i32.gt_s
        if ;; label = @3
          local.get 17
          local.set 18
          block ;; label = @4
            loop ;; label = @5
              local.get 18
              i32.const 0
              i32.le_s
              br_if 1 (;@4;)
              local.get 18
              i32.const 1
              i32.sub
              local.set 18
              local.get 13
              local.get 15
              local.get 18
              i32.add
              local.get 14
              local.get 16
              local.get 18
              i32.add
              array.get_u 0
              array.set 0
              br 0 (;@5;)
            end
          end
        else
          i32.const 0
          local.set 18
          block ;; label = @4
            loop ;; label = @5
              local.get 18
              local.get 17
              i32.ge_s
              br_if 1 (;@4;)
              local.get 13
              local.get 15
              local.get 18
              i32.add
              local.get 14
              local.get 16
              local.get 18
              i32.add
              array.get_u 0
              array.set 0
              local.get 18
              i32.const 1
              i32.add
              local.set 18
              br 0 (;@5;)
            end
          end
        end
        local.get 7
        local.get 4
        i32.add
        local.set 12
        local.get 0
        struct.get 1 0
        local.get 12
        i32.const 46
        array.set 0
      end
    end
  )
  (func (;34;) (type 58) (param (ref 1) i64 i32 i32 i32)
    (local i32 i32 (ref null 0) i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 2
    local.get 3
    i32.add
    i32.const 1
    i32.sub
    local.set 5
    local.get 3
    i32.const 1
    i32.gt_s
    if ;; label = @1
      local.get 0
      struct.get 1 1
      local.set 6
      local.get 3
      i32.const 1
      i32.add
      local.set 10
      local.get 0
      i32.const 48
      local.get 10
      call 53
      local.get 0
      local.get 6
      local.get 1
      local.get 3
      call 32
      local.get 0
      struct.get 1 0
      local.set 7
      local.get 7
      ref.as_non_null
      local.set 20
      local.get 6
      i32.const 2
      i32.add
      local.set 22
      local.get 7
      ref.as_non_null
      local.set 21
      local.get 6
      i32.const 1
      i32.add
      local.set 23
      local.get 3
      i32.const 1
      i32.sub
      local.set 24
      local.get 22
      local.get 23
      i32.gt_s
      if ;; label = @2
        local.get 24
        local.set 25
        block ;; label = @3
          loop ;; label = @4
            local.get 25
            i32.const 0
            i32.le_s
            br_if 1 (;@3;)
            local.get 25
            i32.const 1
            i32.sub
            local.set 25
            local.get 20
            local.get 22
            local.get 25
            i32.add
            local.get 21
            local.get 23
            local.get 25
            i32.add
            array.get_u 0
            array.set 0
            br 0 (;@4;)
          end
        end
      else
        i32.const 0
        local.set 25
        block ;; label = @3
          loop ;; label = @4
            local.get 25
            local.get 24
            i32.ge_s
            br_if 1 (;@3;)
            local.get 20
            local.get 22
            local.get 25
            i32.add
            local.get 21
            local.get 23
            local.get 25
            i32.add
            array.get_u 0
            array.set 0
            local.get 25
            i32.const 1
            i32.add
            local.set 25
            br 0 (;@4;)
          end
        end
      end
      local.get 6
      i32.const 1
      i32.add
      local.set 11
      local.get 0
      struct.get 1 0
      local.get 11
      i32.const 46
      array.set 0
    else
      local.get 0
      struct.get 1 1
      local.set 8
      local.get 0
      i32.const 48
      i32.const 1
      call 53
      local.get 0
      local.get 8
      local.get 1
      i32.const 1
      call 32
    end
    local.get 0
    local.get 4
    if (result (ref 1)) ;; label = @1
      i32.const 0
      i32.const 1
      array.new_data 0 13
      i32.const 1
      struct.new 1
    else
      i32.const 0
      i32.const 1
      array.new_data 0 14
      i32.const 1
      struct.new 1
    end
    call 54
    local.get 5
    i32.const 0
    i32.lt_s
    if ;; label = @1
      local.get 0
      i32.const 45
      call 56
    end
    local.get 5
    i32.const 0
    i32.lt_s
    if (result i32) ;; label = @1
      i32.const 0
      local.get 5
      i32.sub
    else
      local.get 5
    end
    local.set 9
    local.get 9
    i32.const 10
    i32.lt_s
    if ;; label = @1
      local.get 0
      block (result i32) ;; label = @2
        i32.const 48
        local.get 9
        i32.add
        local.set 12
        local.get 12
        br 0 (;@2;)
        unreachable
      end
      call 56
    else
      local.get 9
      i32.const 100
      i32.lt_s
      if ;; label = @2
        local.get 0
        block (result i32) ;; label = @3
          i32.const 48
          local.get 9
          i32.const 10
          i32.div_s
          i32.add
          local.set 16
          local.get 16
          br 0 (;@3;)
          unreachable
        end
        call 56
        local.get 0
        block (result i32) ;; label = @3
          i32.const 48
          local.get 9
          i32.const 10
          i32.rem_s
          i32.add
          local.set 17
          local.get 17
          br 0 (;@3;)
          unreachable
        end
        call 56
      else
        local.get 0
        block (result i32) ;; label = @3
          i32.const 48
          local.get 9
          i32.const 100
          i32.div_s
          i32.add
          local.set 13
          local.get 13
          br 0 (;@3;)
          unreachable
        end
        call 56
        local.get 0
        block (result i32) ;; label = @3
          local.get 9
          i32.const 100
          i32.rem_s
          local.set 14
          block (result i32) ;; label = @4
            i32.const 48
            local.get 14
            i32.const 10
            i32.div_s
            i32.add
            local.set 18
            local.get 18
            br 0 (;@4;)
            unreachable
          end
          br 0 (;@3;)
          unreachable
        end
        call 56
        local.get 0
        block (result i32) ;; label = @3
          local.get 9
          i32.const 100
          i32.rem_s
          local.set 15
          block (result i32) ;; label = @4
            i32.const 48
            local.get 15
            i32.const 10
            i32.rem_s
            i32.add
            local.set 19
            local.get 19
            br 0 (;@4;)
            unreachable
          end
          br 0 (;@3;)
          unreachable
        end
        call 56
      end
    end
  )
  (func (;35;) (type 59) (param (ref 1) i64 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 i64 i32 i32 i32 (ref null 0) i32 i32 (ref null 0) i32 i32 i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 4
    i32.const 0
    i32.lt_s
    if ;; label = @1
      local.get 0
      local.get 1
      local.get 2
      local.get 3
      call 33
      return
    end
    local.get 3
    local.get 2
    i32.add
    local.set 5
    local.get 5
    i32.const 0
    i32.le_s
    if ;; label = @1
      i32.const 0
      local.get 5
      i32.sub
      local.set 6
      local.get 0
      i32.const 48
      call 56
      local.get 0
      i32.const 46
      call 56
      local.get 4
      local.get 6
      i32.le_s
      if ;; label = @2
        local.get 0
        i32.const 48
        local.get 4
        call 53
        return
      end
      local.get 0
      i32.const 48
      local.get 6
      call 53
      local.get 4
      local.get 6
      i32.sub
      local.set 7
      local.get 7
      local.get 3
      local.get 7
      local.get 3
      i32.lt_s
      select (result i32)
      local.set 8
      local.get 4
      local.get 6
      i32.sub
      local.get 8
      i32.sub
      local.set 9
      local.get 1
      local.set 10
      local.get 3
      local.get 8
      i32.sub
      local.set 11
      block ;; label = @2
        loop ;; label = @3
          local.get 11
          i32.const 0
          i32.le_s
          if ;; label = @4
            br 2 (;@2;)
          end
          local.get 10
          i64.const 10
          i64.div_u
          local.set 10
          local.get 11
          i32.const 1
          i32.sub
          local.set 11
          br 0 (;@3;)
        end
      end
      local.get 0
      struct.get 1 1
      local.set 12
      local.get 0
      i32.const 48
      local.get 8
      call 53
      local.get 0
      local.get 12
      local.get 10
      local.get 8
      call 32
      local.get 0
      i32.const 48
      local.get 9
      call 53
    else
      local.get 5
      local.get 3
      i32.ge_s
      if ;; label = @2
        local.get 0
        struct.get 1 1
        local.set 13
        local.get 0
        i32.const 48
        local.get 3
        call 53
        local.get 0
        local.get 13
        local.get 1
        local.get 3
        call 32
        local.get 5
        local.get 3
        i32.sub
        local.set 24
        local.get 0
        i32.const 48
        local.get 24
        call 53
        local.get 4
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 0
          i32.const 46
          call 56
          local.get 0
          i32.const 48
          local.get 4
          call 53
        end
      else
        local.get 3
        local.get 5
        i32.sub
        local.set 14
        local.get 4
        local.get 14
        i32.le_s
        if ;; label = @3
          local.get 5
          local.get 4
          i32.add
          local.set 15
          local.get 1
          local.set 16
          local.get 3
          local.get 15
          i32.sub
          local.set 17
          block ;; label = @4
            loop ;; label = @5
              local.get 17
              i32.const 0
              i32.le_s
              if ;; label = @6
                br 2 (;@4;)
              end
              local.get 16
              i64.const 10
              i64.div_u
              local.set 16
              local.get 17
              i32.const 1
              i32.sub
              local.set 17
              br 0 (;@5;)
            end
          end
          local.get 15
          i32.const 1
          i32.add
          local.set 18
          local.get 0
          struct.get 1 1
          local.set 19
          local.get 0
          i32.const 48
          local.get 18
          call 53
          local.get 0
          local.get 19
          local.get 16
          local.get 15
          call 32
          local.get 0
          struct.get 1 0
          local.set 20
          local.get 20
          ref.as_non_null
          local.set 28
          local.get 19
          local.get 5
          i32.add
          i32.const 1
          i32.add
          local.set 30
          local.get 20
          ref.as_non_null
          local.set 29
          local.get 19
          local.get 5
          i32.add
          local.set 31
          local.get 15
          local.get 5
          i32.sub
          local.set 32
          local.get 30
          local.get 31
          i32.gt_s
          if ;; label = @4
            local.get 32
            local.set 33
            block ;; label = @5
              loop ;; label = @6
                local.get 33
                i32.const 0
                i32.le_s
                br_if 1 (;@5;)
                local.get 33
                i32.const 1
                i32.sub
                local.set 33
                local.get 28
                local.get 30
                local.get 33
                i32.add
                local.get 29
                local.get 31
                local.get 33
                i32.add
                array.get_u 0
                array.set 0
                br 0 (;@6;)
              end
            end
          else
            i32.const 0
            local.set 33
            block ;; label = @5
              loop ;; label = @6
                local.get 33
                local.get 32
                i32.ge_s
                br_if 1 (;@5;)
                local.get 28
                local.get 30
                local.get 33
                i32.add
                local.get 29
                local.get 31
                local.get 33
                i32.add
                array.get_u 0
                array.set 0
                local.get 33
                i32.const 1
                i32.add
                local.set 33
                br 0 (;@6;)
              end
            end
          end
          local.get 19
          local.get 5
          i32.add
          local.set 25
          local.get 0
          struct.get 1 0
          local.get 25
          i32.const 46
          array.set 0
          return
        end
        local.get 4
        local.get 14
        i32.sub
        local.set 21
        local.get 0
        struct.get 1 1
        local.set 22
        local.get 3
        i32.const 1
        i32.add
        local.set 26
        local.get 0
        i32.const 48
        local.get 26
        call 53
        local.get 0
        local.get 22
        local.get 1
        local.get 3
        call 32
        local.get 0
        struct.get 1 0
        local.set 23
        local.get 23
        ref.as_non_null
        local.set 28
        local.get 22
        local.get 5
        i32.add
        i32.const 1
        i32.add
        local.set 30
        local.get 23
        ref.as_non_null
        local.set 29
        local.get 22
        local.get 5
        i32.add
        local.set 31
        local.get 3
        local.get 5
        i32.sub
        local.set 32
        local.get 30
        local.get 31
        i32.gt_s
        if ;; label = @3
          local.get 32
          local.set 33
          block ;; label = @4
            loop ;; label = @5
              local.get 33
              i32.const 0
              i32.le_s
              br_if 1 (;@4;)
              local.get 33
              i32.const 1
              i32.sub
              local.set 33
              local.get 28
              local.get 30
              local.get 33
              i32.add
              local.get 29
              local.get 31
              local.get 33
              i32.add
              array.get_u 0
              array.set 0
              br 0 (;@5;)
            end
          end
        else
          i32.const 0
          local.set 33
          block ;; label = @4
            loop ;; label = @5
              local.get 33
              local.get 32
              i32.ge_s
              br_if 1 (;@4;)
              local.get 28
              local.get 30
              local.get 33
              i32.add
              local.get 29
              local.get 31
              local.get 33
              i32.add
              array.get_u 0
              array.set 0
              local.get 33
              i32.const 1
              i32.add
              local.set 33
              br 0 (;@5;)
            end
          end
        end
        local.get 22
        local.get 5
        i32.add
        local.set 27
        local.get 0
        struct.get 1 0
        local.get 27
        i32.const 46
        array.set 0
        local.get 0
        i32.const 48
        local.get 21
        call 53
      end
    end
  )
  (func (;36;) (type 60) (param f64) (result i32 i32 i32)
    (local i64 i32)
    local.get 0
    i64.reinterpret_f64
    local.set 1
    local.get 1
    i64.eqz
    if ;; label = @1
      i32.const 1
      i32.const 0
      i32.const 1
      return
    end
    local.get 1
    i64.const -9223372036854775808
    i64.eq
    if ;; label = @1
      i32.const 1
      i32.const 1
      i32.const 1
      return
    end
    local.get 1
    i64.const 0
    i64.lt_s
    local.set 2
    local.get 1
    i64.const 9218868437227405312
    i64.and
    i64.const 9218868437227405312
    i64.eq
    if ;; label = @1
      local.get 1
      i64.const 4503599627370495
      i64.and
      i64.const 0
      i64.ne
      if ;; label = @2
        i32.const 1
        i32.const 0
        i32.const 3
        return
      end
      i32.const 1
      local.get 2
      i32.const 2
      return
    end
    i32.const 0
    local.get 2
    i32.const 0
    return
    unreachable
  )
  (func (;37;) (type 61) (param i64 i32) (result f64)
    (local i64 i64 i64)
    local.get 0
    i64.const 4503599627370496
    i64.and
    i64.eqz
    if ;; label = @1
      block (result f64) ;; label = @2
        local.get 0
        f64.reinterpret_i64
        br 0 (;@2;)
        unreachable
      end
      return
    end
    local.get 0
    i64.const -4503599627370497
    i64.and
    local.set 2
    i32.const 1075
    local.get 1
    i32.add
    i64.extend_i32_s
    i64.const 52
    i64.shl
    local.set 3
    block (result f64) ;; label = @1
      local.get 2
      local.get 3
      i64.or
      local.set 4
      local.get 4
      f64.reinterpret_i64
      br 0 (;@1;)
      unreachable
    end
    return
    unreachable
  )
  (func (;38;) (type 62) (param i64 i32) (result f64)
    (local i32 i32 i32 i64 i32 i64 i64 i32 i64 i64)
    i32.const 64
    local.get 0
    i64.clz
    i32.wrap_i64
    i32.sub
    local.set 2
    local.get 1
    i32.const 108853
    i32.mul
    i32.const 15
    i32.shr_s
    local.set 3
    block (result i32) ;; label = @1
      i32.const 53
      local.get 2
      i32.sub
      local.get 3
      i32.sub
      local.set 9
      i32.const 1074
      local.get 9
      i32.const 1074
      local.get 9
      i32.lt_s
      select (result i32)
      br 0 (;@1;)
      unreachable
    end
    local.set 4
    local.get 0
    i32.const 64
    local.get 2
    i32.sub
    i64.extend_i32_s
    i64.shl
    local.set 5
    local.get 1
    call 27
    local.set 11
    local.set 10
    i32.const 0
    local.get 4
    i32.const 64
    local.get 2
    i32.sub
    i32.sub
    local.get 3
    i32.add
    i32.const 3
    i32.add
    i32.sub
    local.set 6
    local.get 5
    local.get 10
    local.get 11
    local.get 6
    call 28
    local.set 7
    local.get 7
    i64.const 36028797018963966
    i64.ge_u
    i64.extend_i32_u
    local.set 8
    local.get 7
    local.get 8
    i64.shr_u
    local.get 7
    i64.const 1
    i64.and
    i64.or
    local.set 7
    local.get 4
    local.get 8
    i32.wrap_i64
    i32.sub
    local.set 4
    local.get 7
    i64.const 1
    i64.add
    local.get 7
    i64.const 2
    i64.shr_u
    i64.const 1
    i64.and
    i64.add
    i64.const 2
    i64.shr_u
    i32.const 0
    local.get 4
    i32.sub
    call 37
    return
    unreachable
  )
  (func (;39;) (type 63) (param i64) (result i32)
    (local i32 i64)
    local.get 0
    i64.eqz
    if ;; label = @1
      i32.const 1
      return
    end
    i32.const 0
    local.set 1
    block ;; label = @1
      local.get 0
      local.set 2
      block ;; label = @2
        loop ;; label = @3
          local.get 2
          i64.const 0
          i64.le_s
          if ;; label = @4
            br 3 (;@1;)
          end
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          i64.const 10
          i64.div_s
          local.set 2
          br 0 (;@3;)
        end
      end
    end
    local.get 1
    return
    unreachable
  )
  (func (;40;) (type 64) (param (ref 0) i32 i64 i32)
    (local i32 i64)
    local.get 1
    local.get 3
    i32.add
    local.set 4
    local.get 2
    i64.eqz
    if ;; label = @1
      local.get 0
      local.get 1
      i32.const 48
      array.set 0
    else
      block ;; label = @2
        local.get 2
        local.set 5
        block ;; label = @3
          loop ;; label = @4
            local.get 5
            i64.const 0
            i64.le_s
            if ;; label = @5
              br 3 (;@2;)
            end
            local.get 4
            i32.const 1
            i32.sub
            local.set 4
            local.get 0
            local.get 4
            i32.const 48
            local.get 5
            i64.const 10
            i64.rem_s
            i32.wrap_i64
            i32.add
            i32.const 255
            i32.and
            array.set 0
            local.get 5
            i64.const 10
            i64.div_s
            local.set 5
            br 0 (;@4;)
          end
        end
      end
    end
  )
  (func (;41;) (type 65) (param (ref 5) i32 i32 (ref 1))
    (local i32 (ref null 1))
    block (result i32) ;; label = @1
      local.get 0
      struct.get 5 7
      local.set 5
      local.get 5
      struct.get 1 1
      br 0 (;@1;)
      unreachable
    end
    local.set 4
    local.get 2
    i32.const 3
    i32.eq
    if (result i32) ;; label = @1
      i32.const 1
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      struct.get 5 7
      i32.const 78
      call 56
      local.get 0
      struct.get 5 7
      i32.const 97
      call 56
      local.get 0
      struct.get 5 7
      i32.const 78
      call 56
    else
      local.get 2
      i32.const 2
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 1
        if (result (ref 1)) ;; label = @3
          i32.const 0
          i32.const 4
          array.new_data 0 20
          i32.const 4
          struct.new 1
        else
          i32.const 0
          i32.const 3
          array.new_data 0 21
          i32.const 3
          struct.new 1
        end
        call 54
      else
        local.get 0
        struct.get 5 7
        local.get 1
        if (result (ref 1)) ;; label = @3
          i32.const 0
          i32.const 1
          array.new_data 0 15
          i32.const 1
          struct.new 1
        else
          i32.const 0
          array.new_default 0
          i32.const 0
          struct.new 1
        end
        call 54
        local.get 0
        struct.get 5 7
        local.get 3
        call 54
      end
    end
    local.get 0
    local.get 4
    call 59
  )
  (func (;42;) (type 93) (param (ref 1)) (result i32 (ref null 7) (ref null 4))
    (local (ref null 2) (ref null 7) (ref null 4) (ref null 7) i64 (ref null 15))
    local.get 0
    i32.const 0
    struct.new 2
    local.set 1
    local.get 1
    ref.as_non_null
    call 74
    local.set 6
    local.get 6
    ref.test (ref 16)
    if (result (ref 7)) ;; label = @1
      local.get 6
      ref.cast (ref 16)
      struct.get 16 1
      local.set 2
      local.get 2
      ref.as_non_null
    else
      local.get 6
      ref.cast (ref 17)
      struct.get 17 1
      local.set 3
      i32.const 1
      ref.null none
      local.get 3
      ref.as_non_null
      return
    end
    local.set 4
    local.get 1
    ref.as_non_null
    call 61
    local.get 1
    struct.get 2 1
    local.get 1
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if ;; label = @1
      i32.const 1
      ref.null none
      block (result (ref 4)) ;; label = @2
        local.get 1
        struct.get 2 1
        i64.extend_i32_s
        local.set 5
        i32.const 7
        i32.const 0
        i32.const 25
        array.new_data 0 45
        i32.const 25
        struct.new 1
        local.get 5
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    i32.const 0
    local.get 4
    ref.as_non_null
    ref.null none
    return
    unreachable
  )
  (func (;43;) (type 66)
    (local (ref null 24))
    block (result (ref 24)) ;; label = @1
      i64.const 1
      i64.const 10
      i64.const 100
      i64.const 1000
      i64.const 10000
      i64.const 100000
      i64.const 1000000
      i64.const 10000000
      i64.const 100000000
      i64.const 1000000000
      i64.const 10000000000
      i64.const 100000000000
      i64.const 1000000000000
      i64.const 10000000000000
      i64.const 100000000000000
      i64.const 1000000000000000
      i64.const 10000000000000000
      i64.const 100000000000000000
      i64.const 1000000000000000000
      i64.const -8446744073709551616
      array.new_fixed 8 20
      i32.const 20
      struct.new 24
      local.set 0
      local.get 0
      ref.as_non_null
      br 0 (;@1;)
      unreachable
    end
    global.set 0
  )
  (func (;44;) (type 67) (param i32) (result (ref 9))
    local.get 0
    i32.const 1114111
    i32.gt_u
    if ;; label = @1
      i32.const 1
      struct.new 9
      return
    end
    local.get 0
    i32.const 55296
    i32.ge_u
    if (result i32) ;; label = @1
      local.get 0
      i32.const 57343
      i32.le_u
    else
      i32.const 0
    end
    if ;; label = @1
      i32.const 1
      struct.new 9
      return
    end
    i32.const 0
    local.get 0
    struct.new 10
    return
    unreachable
  )
  (func (;45;) (type 97) (param i32) (result i32)
    local.get 0
    i32.const 48
    i32.ge_u
    if (result i32) ;; label = @1
      local.get 0
      i32.const 57
      i32.le_u
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 0
      i32.const 97
      i32.ge_u
      if (result i32) ;; label = @2
        local.get 0
        i32.const 102
        i32.le_u
      else
        i32.const 0
      end
    end
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 0
      i32.const 65
      i32.ge_u
      if (result i32) ;; label = @2
        local.get 0
        i32.const 70
        i32.le_u
      else
        i32.const 0
      end
    end
    return
    unreachable
  )
  (func (;46;) (type 98) (param i32) (result i32)
    local.get 0
    i32.const 48
    i32.ge_u
    if (result i32) ;; label = @1
      local.get 0
      i32.const 57
      i32.le_u
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      i32.const 48
      i32.sub
      return
    end
    local.get 0
    i32.const 97
    i32.ge_u
    if (result i32) ;; label = @1
      local.get 0
      i32.const 102
      i32.le_u
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      i32.const 97
      i32.sub
      i32.const 10
      i32.add
      return
    end
    local.get 0
    i32.const 65
    i32.ge_u
    if (result i32) ;; label = @1
      local.get 0
      i32.const 70
      i32.le_u
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      i32.const 65
      i32.sub
      i32.const 10
      i32.add
      return
    end
    i32.const 0
    i32.const 38
    array.new_data 0 17
    i32.const 38
    struct.new 1
    call 18
    unreachable
    unreachable
  )
  (func (;47;) (type 99) (param i32 (ref 5))
    (local i32 i64 i32 i32 (ref null 1))
    local.get 0
    i32.const 0
    i32.lt_s
    local.set 2
    local.get 2
    if (result i64) ;; label = @1
      i64.const 0
      local.get 0
      i64.extend_i32_s
      i64.sub
    else
      local.get 0
      i64.extend_i32_s
    end
    local.set 3
    local.get 3
    call 39
    local.set 4
    local.get 1
    local.get 2
    i32.const 0
    array.new_default 0
    i32.const 0
    struct.new 1
    local.get 4
    call 60
    local.set 5
    block (result (ref 0)) ;; label = @1
      local.get 1
      struct.get 5 7
      local.set 6
      local.get 6
      struct.get 1 0
      br 0 (;@1;)
      unreachable
    end
    local.get 5
    local.get 3
    local.get 4
    call 40
  )
  (func (;48;) (type 100) (param f64 (ref 5))
    (local f64 i32 i32 i32 i32 i32 (ref null 1) (ref null 24) i32 i32 i32 i64 i32)
    local.get 1
    struct.get 5 5
    i32.const 0
    i32.ge_s
    if ;; label = @1
      local.get 0
      local.get 1
      struct.get 5 5
      local.get 1
      call 49
      return
    end
    local.get 0
    call 36
    local.set 12
    local.set 11
    local.set 10
    local.get 10
    if ;; label = @1
      local.get 1
      local.get 11
      local.get 12
      i32.const 0
      i32.const 3
      array.new_data 0 22
      i32.const 3
      struct.new 1
      call 41
      return
    end
    local.get 11
    if (result f64) ;; label = @1
      local.get 0
      f64.neg
    else
      local.get 0
    end
    local.set 2
    local.get 2
    call 30
    local.set 14
    local.set 13
    block (result i32) ;; label = @1
      block (result i32) ;; label = @2
        i32.const 64
        local.get 13
        i64.clz
        i32.wrap_i64
        i32.sub
        local.set 7
        local.get 7
        i32.const 78913
        i32.mul
        i32.const 18
        i32.shr_s
        br 0 (;@2;)
        unreachable
      end
      local.set 6
      local.get 6
      local.get 13
      block (result i64) ;; label = @2
        global.get 0
        ref.as_non_null
        local.set 9
        local.get 6
        local.get 9
        struct.get 24 1
        i32.ge_s
        if ;; label = @3
          i32.const 0
          i32.const 19
          array.new_data 0 25
          i32.const 19
          struct.new 1
          call 18
          unreachable
        end
        local.get 9
        struct.get 24 0
        local.get 6
        array.get 8
        br 0 (;@2;)
        unreachable
      end
      i64.ge_u
      i32.add
      br 0 (;@1;)
      unreachable
    end
    local.set 3
    local.get 14
    local.get 3
    i32.add
    i32.const 1
    i32.sub
    local.set 4
    block (result i32) ;; label = @1
      local.get 1
      struct.get 5 7
      local.set 8
      local.get 8
      struct.get 1 1
      br 0 (;@1;)
      unreachable
    end
    local.set 5
    local.get 11
    if ;; label = @1
      local.get 1
      struct.get 5 7
      i32.const 45
      call 56
    else
      local.get 1
      struct.get_u 5 2
      if ;; label = @2
        local.get 1
        struct.get 5 7
        i32.const 43
        call 56
      end
    end
    local.get 4
    i32.const -4
    i32.lt_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 4
      i32.const 16
      i32.ge_s
    end
    if ;; label = @1
      local.get 1
      struct.get 5 7
      local.get 13
      local.get 14
      local.get 3
      i32.const 0
      call 34
    else
      local.get 14
      i32.const 0
      i32.ge_s
      if ;; label = @2
        local.get 1
        struct.get 5 7
        local.get 13
        local.get 14
        local.get 3
        call 33
        local.get 1
        struct.get 5 7
        i32.const 46
        call 56
        local.get 1
        struct.get 5 7
        i32.const 48
        call 56
      else
        local.get 1
        struct.get 5 7
        local.get 13
        local.get 14
        local.get 3
        call 33
      end
    end
    local.get 1
    local.get 5
    call 59
  )
  (func (;49;) (type 101) (param f64 i32 (ref 5))
    (local i32 f64 i32 i32 (ref null 1) i32 i32 (ref null 1) (ref null 24) i32 i32 i32 i64 i32)
    local.get 0
    call 36
    local.set 14
    local.set 13
    local.set 12
    local.get 12
    if ;; label = @1
      local.get 14
      i32.const 3
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
      if (result i32) ;; label = @2
        i32.const 1
      else
        local.get 14
        i32.const 2
        i32.eq
        if (result i32) ;; label = @3
          i32.const 1
        else
          i32.const 0
        end
      end
      if ;; label = @2
        local.get 2
        local.get 13
        local.get 14
        i32.const 0
        i32.const 1
        array.new_data 0 26
        i32.const 1
        struct.new 1
        call 41
        return
      end
      block (result i32) ;; label = @2
        local.get 2
        struct.get 5 7
        local.set 7
        local.get 7
        struct.get 1 1
        br 0 (;@2;)
        unreachable
      end
      local.set 3
      local.get 13
      if ;; label = @2
        local.get 2
        struct.get 5 7
        i32.const 45
        call 56
      else
        local.get 2
        struct.get_u 5 2
        if ;; label = @3
          local.get 2
          struct.get 5 7
          i32.const 43
          call 56
        end
      end
      local.get 2
      struct.get 5 7
      i32.const 48
      call 56
      local.get 1
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 2
        struct.get 5 7
        i32.const 46
        call 56
        local.get 2
        struct.get 5 7
        i32.const 48
        local.get 1
        call 53
      end
      local.get 2
      local.get 3
      call 59
      return
    end
    local.get 13
    if (result f64) ;; label = @1
      local.get 0
      f64.neg
    else
      local.get 0
    end
    local.set 4
    local.get 4
    local.get 1
    call 29
    local.set 16
    local.set 15
    block (result i32) ;; label = @1
      block (result i32) ;; label = @2
        i32.const 64
        local.get 15
        i64.clz
        i32.wrap_i64
        i32.sub
        local.set 9
        local.get 9
        i32.const 78913
        i32.mul
        i32.const 18
        i32.shr_s
        br 0 (;@2;)
        unreachable
      end
      local.set 8
      local.get 8
      local.get 15
      block (result i64) ;; label = @2
        global.get 0
        ref.as_non_null
        local.set 11
        local.get 8
        local.get 11
        struct.get 24 1
        i32.ge_s
        if ;; label = @3
          i32.const 0
          i32.const 19
          array.new_data 0 25
          i32.const 19
          struct.new 1
          call 18
          unreachable
        end
        local.get 11
        struct.get 24 0
        local.get 8
        array.get 8
        br 0 (;@2;)
        unreachable
      end
      i64.ge_u
      i32.add
      br 0 (;@1;)
      unreachable
    end
    local.set 5
    block (result i32) ;; label = @1
      local.get 2
      struct.get 5 7
      local.set 10
      local.get 10
      struct.get 1 1
      br 0 (;@1;)
      unreachable
    end
    local.set 6
    local.get 13
    if ;; label = @1
      local.get 2
      struct.get 5 7
      i32.const 45
      call 56
    else
      local.get 2
      struct.get_u 5 2
      if ;; label = @2
        local.get 2
        struct.get 5 7
        i32.const 43
        call 56
      end
    end
    local.get 2
    struct.get 5 7
    local.get 15
    local.get 16
    local.get 5
    local.get 1
    call 35
    local.get 2
    local.get 6
    call 59
  )
  (func (;50;) (type 102) (param i32 (ref 5))
    (local (ref null 1))
    local.get 1
    struct.get 5 4
    i32.const 0
    i32.le_s
    if ;; label = @1
      local.get 1
      struct.get 5 7
      local.get 0
      call 56
    else
      i32.const 4
      array.new_default 0
      i32.const 0
      struct.new 1
      local.set 2
      local.get 2
      ref.as_non_null
      local.get 0
      call 56
      local.get 1
      local.get 2
      ref.as_non_null
      call 58
    end
  )
  (func (;51;) (type 68) (param (ref 1) i32)
    (local i32 i32 (ref null 0) i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 0
    struct.get 1 0
    array.len
    local.set 2
    local.get 1
    local.get 2
    i32.le_s
    if ;; label = @1
      return
    end
    block (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 2
        i32.const 2
        i32.mul
        local.set 6
        local.get 6
        local.get 1
        local.get 6
        local.get 1
        i32.gt_s
        select (result i32)
        br 0 (;@2;)
        unreachable
      end
      local.set 5
      local.get 5
      i32.const 8
      local.get 5
      i32.const 8
      i32.gt_s
      select (result i32)
      br 0 (;@1;)
      unreachable
    end
    local.set 3
    local.get 3
    array.new_default 0
    local.set 4
    local.get 4
    ref.as_non_null
    local.set 7
    i32.const 0
    local.set 9
    local.get 0
    struct.get 1 0
    ref.as_non_null
    local.set 8
    i32.const 0
    local.set 10
    local.get 0
    struct.get 1 1
    local.set 11
    local.get 9
    local.get 10
    i32.gt_s
    if ;; label = @1
      local.get 11
      local.set 12
      block ;; label = @2
        loop ;; label = @3
          local.get 12
          i32.const 0
          i32.le_s
          br_if 1 (;@2;)
          local.get 12
          i32.const 1
          i32.sub
          local.set 12
          local.get 7
          local.get 9
          local.get 12
          i32.add
          local.get 8
          local.get 10
          local.get 12
          i32.add
          array.get_u 0
          array.set 0
          br 0 (;@3;)
        end
      end
    else
      i32.const 0
      local.set 12
      block ;; label = @2
        loop ;; label = @3
          local.get 12
          local.get 11
          i32.ge_s
          br_if 1 (;@2;)
          local.get 7
          local.get 9
          local.get 12
          i32.add
          local.get 8
          local.get 10
          local.get 12
          i32.add
          array.get_u 0
          array.set 0
          local.get 12
          i32.const 1
          i32.add
          local.set 12
          br 0 (;@3;)
        end
      end
    end
    local.get 0
    local.get 4
    ref.as_non_null
    struct.set 1 0
  )
  (func (;52;) (type 69) (param (ref 1) i32) (result i32)
    (local i32 i32)
    local.get 0
    struct.get 1 1
    local.get 1
    i32.add
    local.set 2
    local.get 2
    local.get 0
    struct.get 1 0
    array.len
    i32.gt_s
    if ;; label = @1
      local.get 0
      local.get 2
      call 51
    end
    local.get 0
    struct.get 1 1
    local.set 3
    local.get 0
    local.get 2
    struct.set 1 1
    local.get 3
    return
    unreachable
  )
  (func (;53;) (type 70) (param (ref 1) i32 i32)
    (local i32)
    local.get 2
    i32.const 0
    i32.le_s
    if ;; label = @1
      return
    end
    local.get 0
    struct.get 1 1
    local.get 2
    i32.add
    local.set 3
    local.get 3
    local.get 0
    struct.get 1 0
    array.len
    i32.gt_s
    if ;; label = @1
      local.get 0
      local.get 3
      call 51
    end
    local.get 0
    struct.get 1 0
    local.get 0
    struct.get 1 1
    local.get 1
    local.get 2
    array.fill 0
    local.get 0
    local.get 3
    struct.set 1 1
  )
  (func (;54;) (type 71) (param (ref 1) (ref 1))
    (local i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 1
    struct.get 1 1
    local.set 2
    local.get 2
    i32.eqz
    if ;; label = @1
      return
    end
    local.get 0
    struct.get 1 1
    local.get 2
    i32.add
    local.set 3
    local.get 3
    local.get 0
    struct.get 1 0
    array.len
    i32.gt_s
    if ;; label = @1
      local.get 0
      local.get 3
      call 51
    end
    local.get 0
    struct.get 1 0
    ref.as_non_null
    local.set 4
    local.get 0
    struct.get 1 1
    local.set 6
    local.get 1
    struct.get 1 0
    ref.as_non_null
    local.set 5
    i32.const 0
    local.set 7
    local.get 2
    local.set 8
    local.get 6
    local.get 7
    i32.gt_s
    if ;; label = @1
      local.get 8
      local.set 9
      block ;; label = @2
        loop ;; label = @3
          local.get 9
          i32.const 0
          i32.le_s
          br_if 1 (;@2;)
          local.get 9
          i32.const 1
          i32.sub
          local.set 9
          local.get 4
          local.get 6
          local.get 9
          i32.add
          local.get 5
          local.get 7
          local.get 9
          i32.add
          array.get_u 0
          array.set 0
          br 0 (;@3;)
        end
      end
    else
      i32.const 0
      local.set 9
      block ;; label = @2
        loop ;; label = @3
          local.get 9
          local.get 8
          i32.ge_s
          br_if 1 (;@2;)
          local.get 4
          local.get 6
          local.get 9
          i32.add
          local.get 5
          local.get 7
          local.get 9
          i32.add
          array.get_u 0
          array.set 0
          local.get 9
          i32.const 1
          i32.add
          local.set 9
          br 0 (;@3;)
        end
      end
    end
    local.get 0
    local.get 3
    struct.set 1 1
  )
  (func (;55;) (type 72) (param (ref 1) (ref 1) i32 i32)
    (local i32 i32 (ref 0) (ref 0) i32 i32 i32 i32)
    local.get 3
    local.get 2
    i32.sub
    local.set 4
    local.get 4
    i32.const 0
    i32.le_s
    if ;; label = @1
      return
    end
    local.get 0
    struct.get 1 1
    local.get 4
    i32.add
    local.set 5
    local.get 5
    local.get 0
    struct.get 1 0
    array.len
    i32.gt_s
    if ;; label = @1
      local.get 0
      local.get 5
      call 51
    end
    local.get 0
    struct.get 1 0
    ref.as_non_null
    local.set 6
    local.get 0
    struct.get 1 1
    local.set 8
    local.get 1
    struct.get 1 0
    ref.as_non_null
    local.set 7
    local.get 2
    local.set 9
    local.get 4
    local.set 10
    local.get 8
    local.get 9
    i32.gt_s
    if ;; label = @1
      local.get 10
      local.set 11
      block ;; label = @2
        loop ;; label = @3
          local.get 11
          i32.const 0
          i32.le_s
          br_if 1 (;@2;)
          local.get 11
          i32.const 1
          i32.sub
          local.set 11
          local.get 6
          local.get 8
          local.get 11
          i32.add
          local.get 7
          local.get 9
          local.get 11
          i32.add
          array.get_u 0
          array.set 0
          br 0 (;@3;)
        end
      end
    else
      i32.const 0
      local.set 11
      block ;; label = @2
        loop ;; label = @3
          local.get 11
          local.get 10
          i32.ge_s
          br_if 1 (;@2;)
          local.get 6
          local.get 8
          local.get 11
          i32.add
          local.get 7
          local.get 9
          local.get 11
          i32.add
          array.get_u 0
          array.set 0
          local.get 11
          i32.const 1
          i32.add
          local.set 11
          br 0 (;@3;)
        end
      end
    end
    local.get 0
    local.get 5
    struct.set 1 1
  )
  (func (;56;) (type 73) (param (ref 1) i32)
    local.get 0
    struct.get 1 1
    i32.const 4
    i32.add
    local.get 0
    struct.get 1 0
    array.len
    i32.gt_s
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 1 1
      i32.const 4
      i32.add
      call 51
    end
    local.get 1
    i32.const 128
    i32.lt_u
    if ;; label = @1
      local.get 0
      struct.get 1 0
      local.get 0
      struct.get 1 1
      local.get 1
      i32.const 255
      i32.and
      array.set 0
      local.get 0
      local.get 0
      struct.get 1 1
      i32.const 1
      i32.add
      struct.set 1 1
    else
      local.get 1
      i32.const 2048
      i32.lt_u
      if ;; label = @2
        local.get 0
        struct.get 1 0
        local.get 0
        struct.get 1 1
        i32.const 192
        local.get 1
        i32.const 6
        i32.shr_u
        i32.or
        i32.const 255
        i32.and
        array.set 0
        local.get 0
        struct.get 1 0
        local.get 0
        struct.get 1 1
        i32.const 1
        i32.add
        i32.const 128
        local.get 1
        i32.const 63
        i32.and
        i32.or
        i32.const 255
        i32.and
        array.set 0
        local.get 0
        local.get 0
        struct.get 1 1
        i32.const 2
        i32.add
        struct.set 1 1
      else
        local.get 1
        i32.const 65536
        i32.lt_u
        if ;; label = @3
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 224
          local.get 1
          i32.const 12
          i32.shr_u
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 1
          i32.add
          i32.const 128
          local.get 1
          i32.const 6
          i32.shr_u
          i32.const 63
          i32.and
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 2
          i32.add
          i32.const 128
          local.get 1
          i32.const 63
          i32.and
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          local.get 0
          struct.get 1 1
          i32.const 3
          i32.add
          struct.set 1 1
        else
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 240
          local.get 1
          i32.const 18
          i32.shr_u
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 1
          i32.add
          i32.const 128
          local.get 1
          i32.const 12
          i32.shr_u
          i32.const 63
          i32.and
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 2
          i32.add
          i32.const 128
          local.get 1
          i32.const 6
          i32.shr_u
          i32.const 63
          i32.and
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          struct.get 1 0
          local.get 0
          struct.get 1 1
          i32.const 3
          i32.add
          i32.const 128
          local.get 1
          i32.const 63
          i32.and
          i32.or
          i32.const 255
          i32.and
          array.set 0
          local.get 0
          local.get 0
          struct.get 1 1
          i32.const 4
          i32.add
          struct.set 1 1
        end
      end
    end
  )
  (func (;57;) (type 74) (param (ref 5) i32 i32)
    (local i32 (ref null 1))
    block ;; label = @1
      i32.const 0
      local.set 3
      local.get 0
      struct.get 5 7
      local.set 4
      block ;; label = @2
        loop ;; label = @3
          local.get 3
          local.get 2
          i32.ge_s
          if ;; label = @4
            br 3 (;@1;)
          end
          local.get 4
          ref.as_non_null
          local.get 1
          call 56
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          br 0 (;@3;)
        end
      end
    end
  )
  (func (;58;) (type 75) (param (ref 5) (ref 1))
    (local i32 i32 i32 i32 i32)
    local.get 1
    struct.get 1 1
    local.set 2
    local.get 0
    struct.get 5 4
    i32.const 0
    i32.le_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 2
      local.get 0
      struct.get 5 4
      i32.ge_s
    end
    if ;; label = @1
      local.get 0
      struct.get 5 7
      local.get 1
      call 54
      return
    end
    local.get 0
    struct.get 5 4
    local.get 2
    i32.sub
    local.set 3
    local.get 0
    struct.get 5 1
    local.set 4
    local.get 4
    i32.eqz
    if (result i32) ;; label = @1
      i32.const 1
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      struct.get 5 7
      local.get 1
      call 54
      local.get 0
      local.get 0
      struct.get 5 0
      local.get 3
      call 57
    else
      local.get 4
      i32.const 1
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
      if ;; label = @2
        local.get 3
        i32.const 2
        i32.div_s
        local.set 5
        local.get 3
        local.get 5
        i32.sub
        local.set 6
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 5
        call 57
        local.get 0
        struct.get 5 7
        local.get 1
        call 54
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 6
        call 57
      else
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 3
        call 57
        local.get 0
        struct.get 5 7
        local.get 1
        call 54
      end
    end
  )
  (func (;59;) (type 76) (param (ref 5) i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 (ref null 1) i32 i32 i32 i32 i32 i32 i32 i32 (ref null 1) (ref null 1) (ref null 1) (ref null 1) (ref null 0) (ref null 0) (ref null 0) (ref null 0))
    block (result i32) ;; label = @1
      local.get 0
      struct.get 5 7
      local.set 12
      local.get 12
      struct.get 1 1
      br 0 (;@1;)
      unreachable
    end
    local.get 1
    i32.sub
    local.set 2
    local.get 0
    struct.get 5 4
    i32.const 0
    i32.le_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 2
      local.get 0
      struct.get 5 4
      i32.ge_s
    end
    if ;; label = @1
      return
    end
    local.get 0
    struct.get 5 4
    local.get 2
    i32.sub
    local.set 3
    local.get 0
    struct.get 5 0
    i32.const 255
    i32.and
    local.set 4
    local.get 0
    struct.get 5 1
    local.set 5
    local.get 5
    i32.eqz
    if (result i32) ;; label = @1
      i32.const 1
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      struct.get 5 7
      local.get 4
      local.get 3
      call 53
    else
      local.get 5
      i32.const 1
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
      if ;; label = @2
        local.get 3
        i32.const 2
        i32.div_s
        local.set 6
        local.get 3
        local.get 6
        i32.sub
        local.set 7
        local.get 0
        struct.get 5 7
        local.get 4
        local.get 6
        call 53
        local.get 2
        i32.const 1
        i32.sub
        local.set 8
        local.get 0
        struct.get 5 7
        local.set 21
        local.get 21
        struct.get 1 0
        local.set 25
        block ;; label = @3
          loop ;; label = @4
            local.get 8
            i32.const 0
            i32.lt_s
            if ;; label = @5
              br 2 (;@3;)
            end
            local.get 1
            local.get 6
            i32.add
            local.get 8
            i32.add
            local.set 13
            block (result i32) ;; label = @5
              local.get 1
              local.get 8
              i32.add
              local.set 15
              local.get 25
              local.get 15
              array.get_u 0
              br 0 (;@5;)
              unreachable
            end
            local.set 14
            local.get 25
            local.get 13
            local.get 14
            array.set 0
            local.get 8
            i32.const 1
            i32.sub
            local.set 8
            br 0 (;@4;)
          end
        end
        block ;; label = @3
          i32.const 0
          local.set 9
          local.get 0
          struct.get 5 7
          local.set 22
          local.get 22
          struct.get 1 0
          local.set 26
          block ;; label = @4
            loop ;; label = @5
              local.get 9
              local.get 6
              i32.ge_s
              if ;; label = @6
                br 3 (;@3;)
              end
              local.get 1
              local.get 9
              i32.add
              local.set 16
              local.get 26
              local.get 16
              local.get 4
              array.set 0
              local.get 9
              i32.const 1
              i32.add
              local.set 9
              br 0 (;@5;)
            end
          end
        end
        local.get 0
        struct.get 5 7
        local.get 4
        local.get 7
        call 53
      else
        local.get 0
        struct.get 5 7
        local.get 4
        local.get 3
        call 53
        local.get 2
        i32.const 1
        i32.sub
        local.set 10
        local.get 0
        struct.get 5 7
        local.set 23
        local.get 23
        struct.get 1 0
        local.set 27
        block ;; label = @3
          loop ;; label = @4
            local.get 10
            i32.const 0
            i32.lt_s
            if ;; label = @5
              br 2 (;@3;)
            end
            local.get 1
            local.get 3
            i32.add
            local.get 10
            i32.add
            local.set 17
            block (result i32) ;; label = @5
              local.get 1
              local.get 10
              i32.add
              local.set 19
              local.get 27
              local.get 19
              array.get_u 0
              br 0 (;@5;)
              unreachable
            end
            local.set 18
            local.get 27
            local.get 17
            local.get 18
            array.set 0
            local.get 10
            i32.const 1
            i32.sub
            local.set 10
            br 0 (;@4;)
          end
        end
        block ;; label = @3
          i32.const 0
          local.set 11
          local.get 0
          struct.get 5 7
          local.set 24
          local.get 24
          struct.get 1 0
          local.set 28
          block ;; label = @4
            loop ;; label = @5
              local.get 11
              local.get 3
              i32.ge_s
              if ;; label = @6
                br 3 (;@3;)
              end
              local.get 1
              local.get 11
              i32.add
              local.set 20
              local.get 28
              local.get 20
              local.get 4
              array.set 0
              local.get 11
              i32.const 1
              i32.add
              local.set 11
              br 0 (;@5;)
            end
          end
        end
      end
    end
  )
  (func (;60;) (type 77) (param (ref 5) i32 (ref 1) i32) (result i32)
    (local (ref null 1) i32 i32 i32 i32 i32 i32 i32 i32 i32)
    i32.const 0
    array.new_default 0
    i32.const 0
    struct.new 1
    local.set 4
    local.get 1
    if ;; label = @1
      i32.const 0
      i32.const 1
      array.new_data 0 15
      i32.const 1
      struct.new 1
      local.set 4
    else
      local.get 0
      struct.get_u 5 2
      if ;; label = @2
        i32.const 0
        i32.const 1
        array.new_data 0 24
        i32.const 1
        struct.new 1
        local.set 4
      end
    end
    local.get 4
    struct.get 1 1
    local.set 5
    local.get 2
    struct.get 1 1
    local.set 6
    local.get 5
    local.get 6
    i32.add
    local.get 3
    i32.add
    local.set 7
    local.get 0
    struct.get 5 4
    i32.const 0
    i32.le_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 7
      local.get 0
      struct.get 5 4
      i32.ge_s
    end
    if ;; label = @1
      local.get 5
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 4
        ref.as_non_null
        call 54
      end
      local.get 6
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 2
        call 54
      end
      local.get 0
      struct.get 5 7
      local.get 3
      call 52
      return
    end
    local.get 0
    struct.get 5 4
    local.get 7
    i32.sub
    local.set 8
    local.get 0
    struct.get_u 5 3
    if ;; label = @1
      local.get 5
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 4
        ref.as_non_null
        call 54
      end
      local.get 6
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 2
        call 54
      end
      local.get 0
      i32.const 48
      local.get 8
      call 57
      local.get 0
      struct.get 5 7
      local.get 3
      call 52
      return
    end
    local.get 0
    struct.get 5 1
    local.set 9
    local.get 9
    i32.eqz
    if (result i32) ;; label = @1
      i32.const 1
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 5
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 4
        ref.as_non_null
        call 54
      end
      local.get 6
      i32.const 0
      i32.gt_s
      if ;; label = @2
        local.get 0
        struct.get 5 7
        local.get 2
        call 54
      end
      local.get 0
      struct.get 5 7
      local.get 3
      call 52
      local.set 10
      local.get 0
      local.get 0
      struct.get 5 0
      local.get 8
      call 57
      local.get 10
      return
    else
      local.get 9
      i32.const 1
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        i32.const 0
      end
      if ;; label = @2
        local.get 8
        i32.const 2
        i32.div_s
        local.set 11
        local.get 8
        local.get 11
        i32.sub
        local.set 12
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 11
        call 57
        local.get 5
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 0
          struct.get 5 7
          local.get 4
          ref.as_non_null
          call 54
        end
        local.get 6
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 0
          struct.get 5 7
          local.get 2
          call 54
        end
        local.get 0
        struct.get 5 7
        local.get 3
        call 52
        local.set 13
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 12
        call 57
        local.get 13
        return
      else
        local.get 0
        local.get 0
        struct.get 5 0
        local.get 8
        call 57
        local.get 5
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 0
          struct.get 5 7
          local.get 4
          ref.as_non_null
          call 54
        end
        local.get 6
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 0
          struct.get 5 7
          local.get 2
          call 54
        end
        local.get 0
        struct.get 5 7
        local.get 3
        call 52
        return
      end
    end
    unreachable
  )
  (func (;61;) (type 78) (param (ref 2))
    (local i32 i32 (ref null 1) i32 (ref null 0) i32)
    local.get 0
    struct.get 2 0
    local.set 3
    local.get 3
    struct.get 1 1
    local.set 4
    local.get 3
    struct.get 1 0
    local.set 5
    local.get 0
    struct.get 2 1
    local.set 6
    block ;; label = @1
      loop ;; label = @2
        local.get 6
        local.get 4
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        block (result i32) ;; label = @3
          local.get 6
          local.set 2
          local.get 5
          local.get 2
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 1
        local.get 1
        i32.const 32
        i32.gt_s
        if ;; label = @3
          return
        end
        local.get 1
        i32.const 32
        i32.eq
        if (result i32) ;; label = @3
          i32.const 1
        else
          local.get 1
          i32.const 9
          i32.eq
        end
        if (result i32) ;; label = @3
          i32.const 1
        else
          local.get 1
          i32.const 10
          i32.eq
        end
        if (result i32) ;; label = @3
          i32.const 1
        else
          local.get 1
          i32.const 13
          i32.eq
        end
        if ;; label = @3
          local.get 6
          i32.const 1
          i32.add
          local.set 6
        else
          return
        end
        local.get 0
        local.get 6
        struct.set 2 1
        br 0 (;@2;)
      end
    end
  )
  (func (;62;) (type 79) (param (ref 2) i32) (result (ref null 4))
    (local i32 (ref null 1) (ref null 5) i64 i32 (ref null 1) i64)
    local.get 0
    call 61
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if ;; label = @1
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 5
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 5
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    block (result i32) ;; label = @1
      local.get 0
      struct.get 2 1
      local.set 6
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 6
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    local.set 2
    local.get 2
    local.get 1
    i32.ne
    if ;; label = @1
      block (result (ref 4)) ;; label = @2
        block (result (ref 1)) ;; label = @3
          i32.const 53
          array.new_default 0
          i32.const 0
          struct.new 1
          local.set 3
          local.get 3
          ref.as_non_null
          i32.const 0
          i32.const 10
          array.new_data 0 27
          i32.const 10
          struct.new 1
          call 54
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 3
          ref.as_non_null
          struct.new 5
          local.set 4
          local.get 1
          i32.const 255
          i32.and
          local.get 4
          ref.as_non_null
          call 50
          local.get 3
          ref.as_non_null
          i32.const 0
          i32.const 10
          array.new_data 0 28
          i32.const 10
          struct.new 1
          call 54
          i32.const 32
          i32.const 2
          i32.const 0
          i32.const 0
          i32.const -1
          i32.const -1
          i32.const 0
          local.get 3
          ref.as_non_null
          struct.new 5
          local.set 4
          local.get 2
          i32.const 255
          i32.and
          local.get 4
          ref.as_non_null
          call 50
          local.get 3
          ref.as_non_null
          i32.const 39
          call 56
          local.get 3
          ref.as_non_null
          br 0 (;@3;)
          unreachable
        end
        local.set 7
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 8
        i32.const 6
        local.get 7
        ref.as_non_null
        local.get 8
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    ref.null none
    return
    unreachable
  )
  (func (;63;) (type 80) (param (ref 2)) (result (ref 21))
    (local i32 i32 i32 i32 i32 (ref null 1) (ref null 1) i32 i32 i32 i32 i32 i32 (ref null 4) (ref null 1) (ref null 5) i64 i32 (ref null 1) i64 i32 i32 i64 i32 i64 i32 (ref null 1) i64 (ref null 1) (ref null 0) (ref null 1) i32 (ref null 0) i32 i32 (ref null 18))
    local.get 0
    call 61
    local.get 0
    struct.get 2 0
    struct.get 1 1
    local.set 1
    local.get 0
    struct.get 2 1
    local.get 1
    i32.ge_s
    if ;; label = @1
      i32.const 1
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 17
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 17
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      struct.new 23
      return
    end
    block (result i32) ;; label = @1
      local.get 0
      struct.get 2 1
      local.set 18
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 18
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    i32.const 34
    i32.ne
    if ;; label = @1
      i32.const 1
      block (result (ref 4)) ;; label = @2
        i32.const 0
        i32.const 15
        array.new_data 0 31
        i32.const 15
        struct.new 1
        local.set 19
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 20
        i32.const 0
        local.get 19
        ref.as_non_null
        local.get 20
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      struct.new 23
      return
    end
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    local.get 0
    struct.get 2 1
    local.set 2
    local.get 0
    struct.get 2 1
    local.set 3
    local.get 0
    struct.get 2 0
    local.set 29
    local.get 29
    struct.get 1 0
    local.set 30
    block ;; label = @1
      loop ;; label = @2
        local.get 3
        local.get 1
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        local.get 30
        local.get 3
        array.get_u 0
        local.set 4
        local.get 4
        i32.const 34
        i32.eq
        if (result i32) ;; label = @3
          i32.const 1
        else
          local.get 4
          i32.const 92
          i32.eq
        end
        if ;; label = @3
          br 2 (;@1;)
        end
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br 0 (;@2;)
      end
    end
    local.get 3
    local.get 2
    i32.sub
    local.set 5
    local.get 3
    local.get 1
    i32.lt_s
    if (result i32) ;; label = @1
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 3
      array.get_u 0
      i32.const 34
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 5
      array.new_default 0
      i32.const 0
      struct.new 1
      local.set 6
      local.get 6
      ref.as_non_null
      local.get 0
      struct.get 2 0
      local.get 2
      local.get 2
      local.get 5
      i32.add
      call 55
      local.get 0
      local.get 3
      i32.const 1
      i32.add
      struct.set 2 1
      i32.const 0
      local.get 6
      ref.as_non_null
      struct.new 22
      return
    end
    block (result (ref 1)) ;; label = @1
      local.get 5
      i32.const 32
      i32.add
      local.set 21
      local.get 21
      array.new_default 0
      i32.const 0
      struct.new 1
      br 0 (;@1;)
      unreachable
    end
    local.set 7
    local.get 7
    ref.as_non_null
    local.get 0
    struct.get 2 0
    local.get 2
    local.get 2
    local.get 5
    i32.add
    call 55
    local.get 0
    local.get 3
    struct.set 2 1
    local.get 0
    struct.get 2 1
    local.set 35
    block ;; label = @1
      loop ;; label = @2
        local.get 35
        local.set 8
        local.get 0
        struct.get 2 0
        local.set 31
        local.get 31
        struct.get 1 1
        local.set 32
        local.get 31
        struct.get 1 0
        local.set 33
        local.get 35
        local.set 34
        block ;; label = @3
          loop ;; label = @4
            local.get 34
            local.get 32
            i32.ge_s
            if ;; label = @5
              br 2 (;@3;)
            end
            block (result i32) ;; label = @5
              local.get 34
              local.set 22
              local.get 33
              local.get 22
              array.get_u 0
              br 0 (;@5;)
              unreachable
            end
            local.set 9
            local.get 9
            i32.const 34
            i32.eq
            if (result i32) ;; label = @5
              i32.const 1
            else
              local.get 9
              i32.const 92
              i32.eq
            end
            if ;; label = @5
              br 2 (;@3;)
            end
            local.get 34
            i32.const 1
            i32.add
            local.set 34
            local.get 34
            local.set 35
            local.get 0
            local.get 35
            struct.set 2 1
            br 0 (;@4;)
          end
        end
        local.get 35
        local.get 8
        i32.sub
        local.set 10
        local.get 10
        i32.const 0
        i32.gt_s
        if ;; label = @3
          local.get 7
          ref.as_non_null
          local.get 0
          struct.get 2 0
          local.get 8
          local.get 35
          call 55
        end
        local.get 35
        local.get 0
        struct.get 2 0
        struct.get 1 1
        i32.ge_s
        if ;; label = @3
          local.get 0
          local.get 35
          struct.set 2 1
          i32.const 1
          block (result (ref 4)) ;; label = @4
            local.get 35
            i64.extend_i32_s
            local.set 23
            i32.const 8
            i32.const 0
            i32.const 23
            array.new_data 0 30
            i32.const 23
            struct.new 1
            local.get 23
            struct.new 4
            br 0 (;@4;)
            unreachable
          end
          ref.as_non_null
          struct.new 23
          return
        end
        block (result i32) ;; label = @3
          local.get 35
          local.set 24
          local.get 0
          struct.get 2 0
          struct.get 1 0
          local.get 24
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 11
        local.get 11
        i32.const 34
        i32.eq
        if ;; label = @3
          local.get 35
          i32.const 1
          i32.add
          local.set 35
          local.get 0
          local.get 35
          struct.set 2 1
          i32.const 0
          local.get 7
          ref.as_non_null
          struct.new 22
          return
        end
        local.get 35
        i32.const 1
        i32.add
        local.set 35
        local.get 35
        local.get 0
        struct.get 2 0
        struct.get 1 1
        i32.ge_s
        if ;; label = @3
          local.get 0
          local.get 35
          struct.set 2 1
          i32.const 1
          block (result (ref 4)) ;; label = @4
            local.get 35
            i64.extend_i32_s
            local.set 25
            i32.const 8
            i32.const 0
            i32.const 23
            array.new_data 0 30
            i32.const 23
            struct.new 1
            local.get 25
            struct.new 4
            br 0 (;@4;)
            unreachable
          end
          ref.as_non_null
          struct.new 23
          return
        end
        block (result i32) ;; label = @3
          local.get 35
          local.set 26
          local.get 0
          struct.get 2 0
          struct.get 1 0
          local.get 26
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        i32.const 255
        i32.and
        local.set 12
        local.get 12
        i32.const 34
        i32.eq
        if ;; label = @3
          local.get 7
          ref.as_non_null
          i32.const 34
          call 56
        else
          local.get 12
          i32.const 92
          i32.eq
          if ;; label = @4
            local.get 7
            ref.as_non_null
            i32.const 92
            call 56
          else
            local.get 12
            i32.const 47
            i32.eq
            if ;; label = @5
              local.get 7
              ref.as_non_null
              i32.const 47
              call 56
            else
              local.get 12
              i32.const 110
              i32.eq
              if ;; label = @6
                local.get 7
                ref.as_non_null
                i32.const 10
                call 56
              else
                local.get 12
                i32.const 114
                i32.eq
                if ;; label = @7
                  local.get 7
                  ref.as_non_null
                  i32.const 13
                  call 56
                else
                  local.get 12
                  i32.const 116
                  i32.eq
                  if ;; label = @8
                    local.get 7
                    ref.as_non_null
                    i32.const 9
                    call 56
                  else
                    local.get 12
                    i32.const 98
                    i32.eq
                    if ;; label = @9
                      local.get 7
                      ref.as_non_null
                      i32.const 8
                      call 56
                    else
                      local.get 12
                      i32.const 102
                      i32.eq
                      if ;; label = @10
                        local.get 7
                        ref.as_non_null
                        i32.const 12
                        call 56
                      else
                        local.get 12
                        i32.const 117
                        i32.eq
                        if ;; label = @11
                          local.get 0
                          local.get 35
                          struct.set 2 1
                          local.get 7
                          ref.as_non_null
                          local.get 0
                          call 64
                          local.set 36
                          local.get 36
                          ref.test (ref 19)
                          if (result i32) ;; label = @12
                            local.get 36
                            ref.cast (ref 19)
                            struct.get 19 1
                            local.set 13
                            local.get 13
                          else
                            local.get 36
                            ref.cast (ref 20)
                            struct.get 20 1
                            local.set 14
                            i32.const 1
                            local.get 14
                            ref.as_non_null
                            struct.new 23
                            return
                          end
                          call 56
                          local.get 0
                          struct.get 2 1
                          local.set 35
                        else
                          local.get 0
                          local.get 35
                          struct.set 2 1
                          i32.const 1
                          block (result (ref 4)) ;; label = @12
                            block (result (ref 1)) ;; label = @13
                              i32.const 34
                              array.new_default 0
                              i32.const 0
                              struct.new 1
                              local.set 15
                              local.get 15
                              ref.as_non_null
                              i32.const 0
                              i32.const 17
                              array.new_data 0 32
                              i32.const 17
                              struct.new 1
                              call 54
                              i32.const 32
                              i32.const 2
                              i32.const 0
                              i32.const 0
                              i32.const -1
                              i32.const -1
                              i32.const 0
                              local.get 15
                              ref.as_non_null
                              struct.new 5
                              local.set 16
                              local.get 12
                              local.get 16
                              ref.as_non_null
                              call 50
                              local.get 15
                              ref.as_non_null
                              i32.const 39
                              call 56
                              local.get 15
                              ref.as_non_null
                              br 0 (;@13;)
                              unreachable
                            end
                            local.set 27
                            local.get 35
                            i64.extend_i32_s
                            local.set 28
                            i32.const 6
                            local.get 27
                            ref.as_non_null
                            local.get 28
                            struct.new 4
                            br 0 (;@12;)
                            unreachable
                          end
                          ref.as_non_null
                          struct.new 23
                          return
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        local.get 35
        i32.const 1
        i32.add
        local.set 35
        local.get 0
        local.get 35
        struct.set 2 1
        br 0 (;@2;)
      end
    end
    unreachable
  )
  (func (;64;) (type 81) (param (ref 2)) (result (ref 18))
    (local i32 i32 i32 i32 i32 i64 i32 (ref null 1) i64 (ref null 1) i64 i32 (ref null 1) (ref null 0) (ref null 9))
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    local.get 0
    struct.get 2 1
    local.set 1
    local.get 0
    struct.get 2 1
    i32.const 4
    i32.add
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.gt_s
    if ;; label = @1
      i32.const 1
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 6
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 6
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      struct.new 20
      return
    end
    i32.const 0
    local.set 2
    block ;; label = @1
      i32.const 0
      local.set 3
      local.get 0
      struct.get 2 1
      local.set 12
      local.get 0
      struct.get 2 0
      local.set 13
      local.get 13
      struct.get 1 0
      local.set 14
      block ;; label = @2
        loop ;; label = @3
          local.get 3
          i32.const 4
          i32.ge_s
          if ;; label = @4
            br 3 (;@1;)
          end
          block (result i32) ;; label = @4
            local.get 12
            local.get 3
            i32.add
            local.set 7
            local.get 14
            local.get 7
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          i32.const 255
          i32.and
          local.set 4
          local.get 4
          call 45
          i32.eqz
          if ;; label = @4
            i32.const 1
            block (result (ref 4)) ;; label = @5
              i32.const 0
              i32.const 22
              array.new_data 0 33
              i32.const 22
              struct.new 1
              local.set 8
              local.get 1
              i64.extend_i32_s
              local.set 9
              i32.const 6
              local.get 8
              ref.as_non_null
              local.get 9
              struct.new 4
              br 0 (;@5;)
              unreachable
            end
            ref.as_non_null
            struct.new 20
            return
          end
          local.get 2
          i32.const 16
          i32.mul
          local.get 4
          call 46
          i32.add
          local.set 2
          local.get 3
          i32.const 1
          i32.add
          local.set 3
          br 0 (;@3;)
        end
      end
    end
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 3
    i32.add
    struct.set 2 1
    local.get 2
    call 44
    local.set 15
    local.get 15
    ref.test (ref 10)
    if (result (ref 18)) ;; label = @1
      local.get 15
      ref.cast (ref 10)
      struct.get 10 1
      local.set 5
      i32.const 0
      local.get 5
      struct.new 19
    else
      i32.const 1
      block (result (ref 4)) ;; label = @2
        i32.const 0
        i32.const 25
        array.new_data 0 34
        i32.const 25
        struct.new 1
        local.set 10
        local.get 1
        i64.extend_i32_s
        local.set 11
        i32.const 6
        local.get 10
        ref.as_non_null
        local.get 11
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      struct.new 20
    end
    return
    unreachable
  )
  (func (;65;) (type 82) (param (ref 2))
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 (ref null 1) i32 (ref null 0) (ref null 1) i32 (ref null 0) (ref null 1) i32 (ref null 0) i32 i32 i32)
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        local.set 6
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 6
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 45
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
    end
    local.get 0
    struct.get 2 0
    local.set 13
    local.get 13
    struct.get 1 1
    local.set 14
    local.get 13
    struct.get 1 0
    local.set 15
    local.get 0
    struct.get 2 1
    local.set 22
    block ;; label = @1
      loop ;; label = @2
        local.get 22
        local.get 14
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        block (result i32) ;; label = @3
          local.get 22
          local.set 7
          local.get 15
          local.get 7
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 1
        i32.const 48
        local.get 1
        i32.le_s
        if (result i32) ;; label = @3
          local.get 1
          i32.const 57
          i32.le_s
        else
          i32.const 0
        end
        if ;; label = @3
          local.get 22
          i32.const 1
          i32.add
          local.set 22
        else
          br 2 (;@1;)
        end
        local.get 0
        local.get 22
        struct.set 2 1
        br 0 (;@2;)
      end
    end
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        local.set 8
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 8
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 46
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
      local.get 0
      struct.get 2 0
      local.set 16
      local.get 16
      struct.get 1 1
      local.set 17
      local.get 16
      struct.get 1 0
      local.set 18
      local.get 0
      struct.get 2 1
      local.set 23
      block ;; label = @2
        loop ;; label = @3
          local.get 23
          local.get 17
          i32.ge_s
          if ;; label = @4
            br 2 (;@2;)
          end
          block (result i32) ;; label = @4
            local.get 23
            local.set 9
            local.get 18
            local.get 9
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          local.set 2
          i32.const 48
          local.get 2
          i32.le_s
          if (result i32) ;; label = @4
            local.get 2
            i32.const 57
            i32.le_s
          else
            i32.const 0
          end
          if ;; label = @4
            local.get 23
            i32.const 1
            i32.add
            local.set 23
          else
            br 2 (;@2;)
          end
          local.get 0
          local.get 23
          struct.set 2 1
          br 0 (;@3;)
        end
      end
    end
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        local.set 10
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 10
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      local.set 3
      local.get 3
      i32.const 101
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        local.get 3
        i32.const 69
        i32.eq
      end
      if ;; label = @2
        local.get 0
        local.get 0
        struct.get 2 1
        i32.const 1
        i32.add
        struct.set 2 1
        local.get 0
        struct.get 2 1
        local.get 0
        struct.get 2 0
        struct.get 1 1
        i32.lt_s
        if ;; label = @3
          block (result i32) ;; label = @4
            local.get 0
            struct.get 2 1
            local.set 11
            local.get 0
            struct.get 2 0
            struct.get 1 0
            local.get 11
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          local.set 4
          local.get 4
          i32.const 43
          i32.eq
          if (result i32) ;; label = @4
            i32.const 1
          else
            local.get 4
            i32.const 45
            i32.eq
          end
          if ;; label = @4
            local.get 0
            local.get 0
            struct.get 2 1
            i32.const 1
            i32.add
            struct.set 2 1
          end
        end
        local.get 0
        struct.get 2 0
        local.set 19
        local.get 19
        struct.get 1 1
        local.set 20
        local.get 19
        struct.get 1 0
        local.set 21
        local.get 0
        struct.get 2 1
        local.set 24
        block ;; label = @3
          loop ;; label = @4
            local.get 24
            local.get 20
            i32.ge_s
            if ;; label = @5
              br 2 (;@3;)
            end
            block (result i32) ;; label = @5
              local.get 24
              local.set 12
              local.get 21
              local.get 12
              array.get_u 0
              br 0 (;@5;)
              unreachable
            end
            local.set 5
            i32.const 48
            local.get 5
            i32.le_s
            if (result i32) ;; label = @5
              local.get 5
              i32.const 57
              i32.le_s
            else
              i32.const 0
            end
            if ;; label = @5
              local.get 24
              i32.const 1
              i32.add
              local.set 24
            else
              br 2 (;@3;)
            end
            local.get 0
            local.get 24
            struct.set 2 1
            br 0 (;@4;)
          end
        end
      end
    end
  )
  (func (;66;) (type 94) (param (ref 2)) (result i32 f64 (ref null 4))
    (local i64 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 f64 f64 i32 i64 i32 (ref null 1) i64 i32 i32 i32 i32 i32 i32 (ref null 1) i32 (ref null 0) (ref null 1) i32 (ref null 0) (ref null 1) i32 (ref null 0) i32 i32 i32)
    local.get 0
    call 61
    local.get 0
    struct.get 2 1
    i64.extend_i32_s
    local.set 1
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if ;; label = @1
      i32.const 1
      f64.const 0x0p+0 (;=0;)
      i32.const 8
      i32.const 0
      i32.const 23
      array.new_data 0 30
      i32.const 23
      struct.new 1
      local.get 1
      struct.new 4
      return
    end
    i32.const 0
    local.set 2
    block (result i32) ;; label = @1
      local.get 0
      struct.get 2 1
      local.set 18
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 18
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    i32.const 45
    i32.eq
    if ;; label = @1
      i32.const 1
      local.set 2
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
    end
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if ;; label = @1
      i32.const 1
      f64.const 0x0p+0 (;=0;)
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 19
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 19
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    block (result i32) ;; label = @1
      local.get 0
      struct.get 2 1
      local.set 20
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 20
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    local.set 3
    local.get 3
    i32.const 48
    i32.lt_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      local.get 3
      i32.const 57
      i32.gt_s
    end
    if ;; label = @1
      i32.const 1
      f64.const 0x0p+0 (;=0;)
      block (result (ref 4)) ;; label = @2
        i32.const 0
        i32.const 15
        array.new_data 0 35
        i32.const 15
        struct.new 1
        local.set 21
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 22
        i32.const 0
        local.get 21
        ref.as_non_null
        local.get 22
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    local.get 3
    i32.const 48
    i32.sub
    i64.extend_i32_s
    local.set 4
    i32.const 1
    local.set 5
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    local.get 0
    struct.get 2 0
    local.set 29
    local.get 29
    struct.get 1 1
    local.set 30
    local.get 29
    struct.get 1 0
    local.set 31
    local.get 0
    struct.get 2 1
    local.set 38
    block ;; label = @1
      loop ;; label = @2
        local.get 38
        local.get 30
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        block (result i32) ;; label = @3
          local.get 38
          local.set 23
          local.get 31
          local.get 23
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 6
        i32.const 48
        local.get 6
        i32.le_s
        if (result i32) ;; label = @3
          local.get 6
          i32.const 57
          i32.le_s
        else
          i32.const 0
        end
        if ;; label = @3
          local.get 5
          i32.const 19
          i32.lt_s
          if ;; label = @4
            local.get 4
            i64.const 10
            i64.mul
            local.get 6
            i32.const 48
            i32.sub
            i64.extend_i32_s
            i64.add
            local.set 4
          end
          local.get 5
          i32.const 1
          i32.add
          local.set 5
          local.get 38
          i32.const 1
          i32.add
          local.set 38
        else
          br 2 (;@1;)
        end
        local.get 0
        local.get 38
        struct.set 2 1
        br 0 (;@2;)
      end
    end
    i32.const 0
    local.set 7
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        local.set 24
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 24
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 46
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
      local.get 0
      struct.get 2 0
      local.set 32
      local.get 32
      struct.get 1 1
      local.set 33
      local.get 32
      struct.get 1 0
      local.set 34
      local.get 0
      struct.get 2 1
      local.set 39
      block ;; label = @2
        loop ;; label = @3
          local.get 39
          local.get 33
          i32.ge_s
          if ;; label = @4
            br 2 (;@2;)
          end
          block (result i32) ;; label = @4
            local.get 39
            local.set 25
            local.get 34
            local.get 25
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          local.set 8
          i32.const 48
          local.get 8
          i32.le_s
          if (result i32) ;; label = @4
            local.get 8
            i32.const 57
            i32.le_s
          else
            i32.const 0
          end
          if ;; label = @4
            local.get 5
            i32.const 19
            i32.lt_s
            if ;; label = @5
              local.get 4
              i64.const 10
              i64.mul
              local.get 8
              i32.const 48
              i32.sub
              i64.extend_i32_s
              i64.add
              local.set 4
              local.get 7
              i32.const 1
              i32.add
              local.set 7
            end
            local.get 5
            i32.const 1
            i32.add
            local.set 5
            local.get 39
            i32.const 1
            i32.add
            local.set 39
          else
            br 2 (;@2;)
          end
          local.get 0
          local.get 39
          struct.set 2 1
          br 0 (;@3;)
        end
      end
    end
    i32.const 0
    local.set 9
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.lt_s
    if ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        local.set 26
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 26
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      local.set 10
      local.get 10
      i32.const 101
      i32.eq
      if (result i32) ;; label = @2
        i32.const 1
      else
        local.get 10
        i32.const 69
        i32.eq
      end
      if ;; label = @2
        local.get 0
        local.get 0
        struct.get 2 1
        i32.const 1
        i32.add
        struct.set 2 1
        i32.const 0
        local.set 11
        local.get 0
        struct.get 2 1
        local.get 0
        struct.get 2 0
        struct.get 1 1
        i32.lt_s
        if ;; label = @3
          block (result i32) ;; label = @4
            local.get 0
            struct.get 2 1
            local.set 27
            local.get 0
            struct.get 2 0
            struct.get 1 0
            local.get 27
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          local.set 12
          local.get 12
          i32.const 45
          i32.eq
          if ;; label = @4
            i32.const 1
            local.set 11
            local.get 0
            local.get 0
            struct.get 2 1
            i32.const 1
            i32.add
            struct.set 2 1
          else
            local.get 12
            i32.const 43
            i32.eq
            if ;; label = @5
              local.get 0
              local.get 0
              struct.get 2 1
              i32.const 1
              i32.add
              struct.set 2 1
            end
          end
        end
        local.get 0
        struct.get 2 0
        local.set 35
        local.get 35
        struct.get 1 1
        local.set 36
        local.get 35
        struct.get 1 0
        local.set 37
        local.get 0
        struct.get 2 1
        local.set 40
        block ;; label = @3
          loop ;; label = @4
            local.get 40
            local.get 36
            i32.ge_s
            if ;; label = @5
              br 2 (;@3;)
            end
            block (result i32) ;; label = @5
              local.get 40
              local.set 28
              local.get 37
              local.get 28
              array.get_u 0
              br 0 (;@5;)
              unreachable
            end
            local.set 13
            i32.const 48
            local.get 13
            i32.le_s
            if (result i32) ;; label = @5
              local.get 13
              i32.const 57
              i32.le_s
            else
              i32.const 0
            end
            if ;; label = @5
              local.get 9
              i32.const 10
              i32.mul
              local.get 13
              i32.const 48
              i32.sub
              i32.add
              local.set 9
              local.get 40
              i32.const 1
              i32.add
              local.set 40
            else
              br 2 (;@3;)
            end
            local.get 0
            local.get 40
            struct.set 2 1
            br 0 (;@4;)
          end
        end
        local.get 11
        if ;; label = @3
          i32.const 0
          local.get 9
          i32.sub
          local.set 9
        end
      end
    end
    local.get 4
    i64.eqz
    if ;; label = @1
      i32.const 0
      f64.const -0x0p+0 (;=-0;)
      ref.null none
      return
    end
    local.get 5
    local.get 7
    i32.sub
    i32.const 19
    i32.gt_s
    if (result i32) ;; label = @1
      local.get 5
      local.get 7
      i32.sub
      i32.const 19
      i32.sub
    else
      i32.const 0
    end
    local.set 14
    local.get 9
    local.get 7
    i32.sub
    local.get 14
    i32.add
    local.set 15
    local.get 15
    i32.const 350
    i32.gt_s
    if ;; label = @1
      f64.const -inf (;=-inf;)
      f64.const inf (;=inf;)
      local.get 2
      select (result f64)
      local.set 16
      i32.const 0
      local.get 16
      ref.null none
      return
    end
    local.get 15
    i32.const -351
    i32.lt_s
    if ;; label = @1
      i32.const 0
      f64.const -0x0p+0 (;=-0;)
      ref.null none
      return
    end
    local.get 4
    local.get 15
    call 38
    local.set 17
    local.get 2
    if ;; label = @1
      i32.const 0
      local.get 17
      f64.neg
      ref.null none
      return
    end
    i32.const 0
    local.get 17
    ref.null none
    return
    unreachable
  )
  (func (;67;) (type 83) (param (ref 2)) (result (ref null 4))
    (local i32 i32 i32 i64 i32 i64 (ref null 1) i32 (ref null 0) i32)
    local.get 0
    local.get 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    local.get 0
    struct.get 2 0
    local.set 7
    local.get 7
    struct.get 1 1
    local.set 8
    local.get 7
    struct.get 1 0
    local.set 9
    local.get 0
    struct.get 2 1
    local.set 10
    block ;; label = @1
      loop ;; label = @2
        local.get 10
        local.get 8
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        block (result i32) ;; label = @3
          local.get 10
          local.set 3
          local.get 9
          local.get 3
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 1
        local.get 1
        i32.const 34
        i32.eq
        if ;; label = @3
          local.get 10
          i32.const 1
          i32.add
          local.set 10
          local.get 0
          local.get 10
          struct.set 2 1
          ref.null none
          return
        end
        local.get 1
        i32.const 92
        i32.eq
        if ;; label = @3
          local.get 10
          i32.const 1
          i32.add
          local.set 10
          local.get 10
          local.get 8
          i32.ge_s
          if ;; label = @4
            local.get 0
            local.get 10
            struct.set 2 1
            block (result (ref 4)) ;; label = @5
              local.get 10
              i64.extend_i32_s
              local.set 4
              i32.const 8
              i32.const 0
              i32.const 23
              array.new_data 0 30
              i32.const 23
              struct.new 1
              local.get 4
              struct.new 4
              br 0 (;@5;)
              unreachable
            end
            ref.as_non_null
            return
          end
          block (result i32) ;; label = @4
            local.get 10
            local.set 5
            local.get 9
            local.get 5
            array.get_u 0
            br 0 (;@4;)
            unreachable
          end
          local.set 2
          local.get 2
          i32.const 117
          i32.eq
          if ;; label = @4
            local.get 10
            i32.const 4
            i32.add
            local.set 10
          end
        else
        end
        local.get 10
        i32.const 1
        i32.add
        local.set 10
        local.get 0
        local.get 10
        struct.set 2 1
        br 0 (;@2;)
      end
    end
    block (result (ref 4)) ;; label = @1
      local.get 0
      struct.get 2 1
      i64.extend_i32_s
      local.set 6
      i32.const 8
      i32.const 0
      i32.const 23
      array.new_data 0 30
      i32.const 23
      struct.new 1
      local.get 6
      struct.new 4
      br 0 (;@1;)
      unreachable
    end
    ref.as_non_null
    return
    unreachable
  )
  (func (;68;) (type 84) (param (ref 2)) (result (ref null 4))
    (local i32 i32 i32 (ref null 1) i64)
    local.get 0
    struct.get 2 1
    i32.const 4
    i32.add
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.le_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 1
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 114
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 2
        i32.add
        local.set 2
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 2
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 117
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 3
        i32.add
        local.set 3
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 3
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 101
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 4
      i32.add
      struct.set 2 1
      ref.null none
      return
    end
    block (result (ref 4)) ;; label = @1
      i32.const 0
      i32.const 15
      array.new_data 0 36
      i32.const 15
      struct.new 1
      local.set 4
      local.get 0
      struct.get 2 1
      i64.extend_i32_s
      local.set 5
      i32.const 6
      local.get 4
      ref.as_non_null
      local.get 5
      struct.new 4
      br 0 (;@1;)
      unreachable
    end
    ref.as_non_null
    return
    unreachable
  )
  (func (;69;) (type 85) (param (ref 2)) (result (ref null 4))
    (local i32 i32 i32 i32 (ref null 1) i64)
    local.get 0
    struct.get 2 1
    i32.const 5
    i32.add
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.le_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 1
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 97
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 2
        i32.add
        local.set 2
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 2
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 108
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 3
        i32.add
        local.set 3
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 3
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 115
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 4
        i32.add
        local.set 4
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 4
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 101
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 5
      i32.add
      struct.set 2 1
      ref.null none
      return
    end
    block (result (ref 4)) ;; label = @1
      i32.const 0
      i32.const 16
      array.new_data 0 37
      i32.const 16
      struct.new 1
      local.set 5
      local.get 0
      struct.get 2 1
      i64.extend_i32_s
      local.set 6
      i32.const 6
      local.get 5
      ref.as_non_null
      local.get 6
      struct.new 4
      br 0 (;@1;)
      unreachable
    end
    ref.as_non_null
    return
    unreachable
  )
  (func (;70;) (type 86) (param (ref 2)) (result (ref null 4))
    (local i32 i32 i32 (ref null 1) i64)
    local.get 0
    struct.get 2 1
    i32.const 4
    i32.add
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.le_s
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 1
        i32.add
        local.set 1
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 1
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 117
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 2
        i32.add
        local.set 2
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 2
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 108
      i32.eq
    else
      i32.const 0
    end
    if (result i32) ;; label = @1
      block (result i32) ;; label = @2
        local.get 0
        struct.get 2 1
        i32.const 3
        i32.add
        local.set 3
        local.get 0
        struct.get 2 0
        struct.get 1 0
        local.get 3
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 108
      i32.eq
    else
      i32.const 0
    end
    if ;; label = @1
      local.get 0
      local.get 0
      struct.get 2 1
      i32.const 4
      i32.add
      struct.set 2 1
      ref.null none
      return
    end
    block (result (ref 4)) ;; label = @1
      i32.const 0
      i32.const 15
      array.new_data 0 38
      i32.const 15
      struct.new 1
      local.set 4
      local.get 0
      struct.get 2 1
      i64.extend_i32_s
      local.set 5
      i32.const 6
      local.get 4
      ref.as_non_null
      local.get 5
      struct.new 4
      br 0 (;@1;)
      unreachable
    end
    ref.as_non_null
    return
    unreachable
  )
  (func (;71;) (type 87) (param (ref 2)) (result (ref null 4))
    (local i32 (ref null 4) i32 (ref null 4) (ref null 4) (ref null 4) i32 (ref null 4) (ref null 4) (ref null 4) (ref null 4) i64 i32 i32 i64 i32 (ref null 1) i64 i32 i32 (ref null 1) i64 i64 i32 (ref null 1) i64 (ref null 1) i64)
    local.get 0
    call 61
    local.get 0
    struct.get 2 1
    local.get 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if ;; label = @1
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 12
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 12
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    block (result i32) ;; label = @1
      local.get 0
      struct.get 2 1
      local.set 13
      local.get 0
      struct.get 2 0
      struct.get 1 0
      local.get 13
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    i32.const 255
    i32.and
    local.set 1
    local.get 1
    i32.const 34
    i32.eq
    if ;; label = @1
      local.get 0
      call 67
      return
    else
      local.get 1
      i32.const 116
      i32.eq
      if ;; label = @2
        local.get 0
        call 68
        return
      else
        local.get 1
        i32.const 102
        i32.eq
        if ;; label = @3
          local.get 0
          call 69
          return
        else
          local.get 1
          i32.const 110
          i32.eq
          if ;; label = @4
            local.get 0
            call 70
            return
          else
            local.get 1
            i32.const 91
            i32.eq
            if ;; label = @5
              local.get 0
              local.get 0
              struct.get 2 1
              i32.const 1
              i32.add
              struct.set 2 1
              local.get 0
              call 61
              local.get 0
              struct.get 2 1
              local.get 0
              struct.get 2 0
              struct.get 1 1
              i32.lt_s
              if (result i32) ;; label = @6
                block (result i32) ;; label = @7
                  local.get 0
                  struct.get 2 1
                  local.set 14
                  local.get 0
                  struct.get 2 0
                  struct.get 1 0
                  local.get 14
                  array.get_u 0
                  br 0 (;@7;)
                  unreachable
                end
                i32.const 93
                i32.eq
              else
                i32.const 0
              end
              if ;; label = @6
                local.get 0
                local.get 0
                struct.get 2 1
                i32.const 1
                i32.add
                struct.set 2 1
                ref.null none
                return
              end
              block ;; label = @6
                loop ;; label = @7
                  local.get 0
                  call 71
                  local.set 8
                  local.get 8
                  ref.is_null
                  if ;; label = @8
                  else
                    local.get 8
                    ref.as_non_null
                    local.set 2
                    local.get 2
                    ref.as_non_null
                    return
                  end
                  local.get 0
                  call 61
                  local.get 0
                  struct.get 2 1
                  local.get 0
                  struct.get 2 0
                  struct.get 1 1
                  i32.ge_s
                  if ;; label = @8
                    block (result (ref 4)) ;; label = @9
                      local.get 0
                      struct.get 2 1
                      i64.extend_i32_s
                      local.set 15
                      i32.const 8
                      i32.const 0
                      i32.const 23
                      array.new_data 0 30
                      i32.const 23
                      struct.new 1
                      local.get 15
                      struct.new 4
                      br 0 (;@9;)
                      unreachable
                    end
                    ref.as_non_null
                    return
                  end
                  block (result i32) ;; label = @8
                    local.get 0
                    struct.get 2 1
                    local.set 16
                    local.get 0
                    struct.get 2 0
                    struct.get 1 0
                    local.get 16
                    array.get_u 0
                    br 0 (;@8;)
                    unreachable
                  end
                  local.set 3
                  local.get 3
                  i32.const 93
                  i32.eq
                  if ;; label = @8
                    local.get 0
                    local.get 0
                    struct.get 2 1
                    i32.const 1
                    i32.add
                    struct.set 2 1
                    ref.null none
                    return
                  end
                  local.get 3
                  i32.const 44
                  i32.eq
                  if ;; label = @8
                    local.get 0
                    local.get 0
                    struct.get 2 1
                    i32.const 1
                    i32.add
                    struct.set 2 1
                  else
                    block (result (ref 4)) ;; label = @9
                      i32.const 0
                      i32.const 19
                      array.new_data 0 39
                      i32.const 19
                      struct.new 1
                      local.set 17
                      local.get 0
                      struct.get 2 1
                      i64.extend_i32_s
                      local.set 18
                      i32.const 6
                      local.get 17
                      ref.as_non_null
                      local.get 18
                      struct.new 4
                      br 0 (;@9;)
                      unreachable
                    end
                    ref.as_non_null
                    return
                  end
                  br 0 (;@7;)
                end
              end
            else
              local.get 1
              i32.const 123
              i32.eq
              if ;; label = @6
                local.get 0
                local.get 0
                struct.get 2 1
                i32.const 1
                i32.add
                struct.set 2 1
                local.get 0
                call 61
                local.get 0
                struct.get 2 1
                local.get 0
                struct.get 2 0
                struct.get 1 1
                i32.lt_s
                if (result i32) ;; label = @7
                  block (result i32) ;; label = @8
                    local.get 0
                    struct.get 2 1
                    local.set 19
                    local.get 0
                    struct.get 2 0
                    struct.get 1 0
                    local.get 19
                    array.get_u 0
                    br 0 (;@8;)
                    unreachable
                  end
                  i32.const 125
                  i32.eq
                else
                  i32.const 0
                end
                if ;; label = @7
                  local.get 0
                  local.get 0
                  struct.get 2 1
                  i32.const 1
                  i32.add
                  struct.set 2 1
                  ref.null none
                  return
                end
                block ;; label = @7
                  loop ;; label = @8
                    local.get 0
                    call 61
                    local.get 0
                    struct.get 2 1
                    local.get 0
                    struct.get 2 0
                    struct.get 1 1
                    i32.ge_s
                    if (result i32) ;; label = @9
                      i32.const 1
                    else
                      block (result i32) ;; label = @10
                        local.get 0
                        struct.get 2 1
                        local.set 20
                        local.get 0
                        struct.get 2 0
                        struct.get 1 0
                        local.get 20
                        array.get_u 0
                        br 0 (;@10;)
                        unreachable
                      end
                      i32.const 34
                      i32.ne
                    end
                    if ;; label = @9
                      block (result (ref 4)) ;; label = @10
                        i32.const 0
                        i32.const 19
                        array.new_data 0 40
                        i32.const 19
                        struct.new 1
                        local.set 21
                        local.get 0
                        struct.get 2 1
                        i64.extend_i32_s
                        local.set 22
                        i32.const 6
                        local.get 21
                        ref.as_non_null
                        local.get 22
                        struct.new 4
                        br 0 (;@10;)
                        unreachable
                      end
                      ref.as_non_null
                      return
                    end
                    local.get 0
                    call 67
                    local.set 9
                    local.get 9
                    ref.is_null
                    if ;; label = @9
                    else
                      local.get 9
                      ref.as_non_null
                      local.set 4
                      local.get 4
                      ref.as_non_null
                      return
                    end
                    local.get 0
                    i32.const 58
                    call 62
                    local.set 10
                    local.get 10
                    ref.is_null
                    if ;; label = @9
                    else
                      local.get 10
                      ref.as_non_null
                      local.set 5
                      local.get 5
                      ref.as_non_null
                      return
                    end
                    local.get 0
                    call 71
                    local.set 11
                    local.get 11
                    ref.is_null
                    if ;; label = @9
                    else
                      local.get 11
                      ref.as_non_null
                      local.set 6
                      local.get 6
                      ref.as_non_null
                      return
                    end
                    local.get 0
                    call 61
                    local.get 0
                    struct.get 2 1
                    local.get 0
                    struct.get 2 0
                    struct.get 1 1
                    i32.ge_s
                    if ;; label = @9
                      block (result (ref 4)) ;; label = @10
                        local.get 0
                        struct.get 2 1
                        i64.extend_i32_s
                        local.set 23
                        i32.const 8
                        i32.const 0
                        i32.const 23
                        array.new_data 0 30
                        i32.const 23
                        struct.new 1
                        local.get 23
                        struct.new 4
                        br 0 (;@10;)
                        unreachable
                      end
                      ref.as_non_null
                      return
                    end
                    block (result i32) ;; label = @9
                      local.get 0
                      struct.get 2 1
                      local.set 24
                      local.get 0
                      struct.get 2 0
                      struct.get 1 0
                      local.get 24
                      array.get_u 0
                      br 0 (;@9;)
                      unreachable
                    end
                    local.set 7
                    local.get 7
                    i32.const 125
                    i32.eq
                    if ;; label = @9
                      local.get 0
                      local.get 0
                      struct.get 2 1
                      i32.const 1
                      i32.add
                      struct.set 2 1
                      ref.null none
                      return
                    end
                    local.get 7
                    i32.const 44
                    i32.eq
                    if ;; label = @9
                      local.get 0
                      local.get 0
                      struct.get 2 1
                      i32.const 1
                      i32.add
                      struct.set 2 1
                    else
                      block (result (ref 4)) ;; label = @10
                        i32.const 0
                        i32.const 19
                        array.new_data 0 41
                        i32.const 19
                        struct.new 1
                        local.set 25
                        local.get 0
                        struct.get 2 1
                        i64.extend_i32_s
                        local.set 26
                        i32.const 6
                        local.get 25
                        ref.as_non_null
                        local.get 26
                        struct.new 4
                        br 0 (;@10;)
                        unreachable
                      end
                      ref.as_non_null
                      return
                    end
                    br 0 (;@8;)
                  end
                end
              else
                local.get 1
                i32.const 45
                i32.eq
                if ;; label = @7
                  local.get 0
                  call 65
                  ref.null none
                  return
                else
                  local.get 1
                  i32.const 48
                  i32.ge_u
                  if (result i32) ;; label = @8
                    local.get 1
                    i32.const 57
                    i32.le_u
                  else
                    i32.const 0
                  end
                  if ;; label = @8
                    local.get 0
                    call 65
                    ref.null none
                    return
                  else
                    block (result (ref 4)) ;; label = @9
                      i32.const 0
                      i32.const 34
                      array.new_data 0 42
                      i32.const 34
                      struct.new 1
                      local.set 27
                      local.get 0
                      struct.get 2 1
                      i64.extend_i32_s
                      local.set 28
                      i32.const 6
                      local.get 27
                      ref.as_non_null
                      local.get 28
                      struct.new 4
                      br 0 (;@9;)
                      unreachable
                    end
                    ref.as_non_null
                    return
                  end
                end
              end
            end
          end
        end
      end
    end
    unreachable
  )
  (func (;72;) (type 95) (param (ref 3)) (result i32 (ref null 12) (ref null 4))
    (local i32 i32 i32 i32 i32 (ref null 4) i32 i32 (ref null 1) (ref null 4) (ref null 1) (ref null 4) i32 i32 (ref null 4) (ref null 4) i64 i32 (ref null 1) i64 i32 (ref null 1) i64 i32 i32 (ref null 12) (ref null 26) (ref null 21) (ref null 12) (ref null 26))
    local.get 0
    struct.get 3 0
    call 61
    local.get 0
    struct.get 3 0
    struct.get 2 1
    local.get 0
    struct.get 3 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if ;; label = @1
      i32.const 1
      ref.null none
      block (result (ref 4)) ;; label = @2
        local.get 0
        struct.get 3 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 17
        i32.const 8
        i32.const 0
        i32.const 23
        array.new_data 0 30
        i32.const 23
        struct.new 1
        local.get 17
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    block (result i32) ;; label = @1
      local.get 0
      struct.get 3 0
      struct.get 2 1
      local.set 18
      local.get 0
      struct.get 3 0
      struct.get 2 0
      struct.get 1 0
      local.get 18
      array.get_u 0
      br 0 (;@1;)
      unreachable
    end
    local.set 1
    local.get 1
    i32.const 125
    i32.eq
    if ;; label = @1
      i32.const 0
      i32.const 1
      struct.new 12
      ref.null none
      return
    end
    local.get 0
    struct.get_u 3 2
    i32.eqz
    if ;; label = @1
      local.get 1
      i32.const 44
      i32.ne
      if ;; label = @2
        i32.const 1
        ref.null none
        block (result (ref 4)) ;; label = @3
          i32.const 0
          i32.const 19
          array.new_data 0 41
          i32.const 19
          struct.new 1
          local.set 19
          local.get 0
          struct.get 3 0
          struct.get 2 1
          i64.extend_i32_s
          local.set 20
          i32.const 6
          local.get 19
          ref.as_non_null
          local.get 20
          struct.new 4
          br 0 (;@3;)
          unreachable
        end
        ref.as_non_null
        return
      end
      local.get 0
      struct.get 3 0
      local.get 0
      struct.get 3 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
      local.get 0
      struct.get 3 0
      call 61
    end
    local.get 0
    i32.const 0
    struct.set 3 2
    local.get 0
    struct.get 3 0
    struct.get 2 1
    local.get 0
    struct.get 3 0
    struct.get 2 0
    struct.get 1 1
    i32.ge_s
    if (result i32) ;; label = @1
      i32.const 1
    else
      block (result i32) ;; label = @2
        local.get 0
        struct.get 3 0
        struct.get 2 1
        local.set 21
        local.get 0
        struct.get 3 0
        struct.get 2 0
        struct.get 1 0
        local.get 21
        array.get_u 0
        br 0 (;@2;)
        unreachable
      end
      i32.const 34
      i32.ne
    end
    if ;; label = @1
      i32.const 1
      ref.null none
      block (result (ref 4)) ;; label = @2
        i32.const 0
        i32.const 19
        array.new_data 0 40
        i32.const 19
        struct.new 1
        local.set 22
        local.get 0
        struct.get 3 0
        struct.get 2 1
        i64.extend_i32_s
        local.set 23
        i32.const 0
        local.get 22
        ref.as_non_null
        local.get 23
        struct.new 4
        br 0 (;@2;)
        unreachable
      end
      ref.as_non_null
      return
    end
    local.get 0
    struct.get 3 0
    local.get 0
    struct.get 3 0
    struct.get 2 1
    i32.const 1
    i32.add
    struct.set 2 1
    local.get 0
    struct.get 3 0
    struct.get 2 1
    local.set 2
    i32.const 0
    local.set 3
    block ;; label = @1
      loop ;; label = @2
        local.get 0
        struct.get 3 0
        struct.get 2 1
        local.get 0
        struct.get 3 0
        struct.get 2 0
        struct.get 1 1
        i32.ge_s
        if ;; label = @3
          br 2 (;@1;)
        end
        block (result i32) ;; label = @3
          local.get 0
          struct.get 3 0
          struct.get 2 1
          local.set 24
          local.get 0
          struct.get 3 0
          struct.get 2 0
          struct.get 1 0
          local.get 24
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        local.set 4
        local.get 4
        i32.const 34
        i32.eq
        if ;; label = @3
          br 2 (;@1;)
        end
        local.get 4
        i32.const 92
        i32.eq
        if ;; label = @3
          i32.const 1
          local.set 3
          br 2 (;@1;)
        end
        local.get 0
        struct.get 3 0
        local.get 0
        struct.get 3 0
        struct.get 2 1
        i32.const 1
        i32.add
        struct.set 2 1
        br 0 (;@2;)
      end
    end
    local.get 3
    i32.eqz
    if ;; label = @1
      local.get 0
      struct.get 3 0
      struct.get 2 1
      local.set 5
      local.get 0
      struct.get 3 0
      local.get 0
      struct.get 3 0
      struct.get 2 1
      i32.const 1
      i32.add
      struct.set 2 1
      local.get 0
      struct.get 3 0
      struct.get 2 1
      local.get 0
      struct.get 3 0
      struct.get 2 0
      struct.get 1 1
      i32.lt_s
      if (result i32) ;; label = @2
        block (result i32) ;; label = @3
          local.get 0
          struct.get 3 0
          struct.get 2 1
          local.set 25
          local.get 0
          struct.get 3 0
          struct.get 2 0
          struct.get 1 0
          local.get 25
          array.get_u 0
          br 0 (;@3;)
          unreachable
        end
        i32.const 58
        i32.eq
      else
        i32.const 0
      end
      if ;; label = @2
        local.get 0
        struct.get 3 0
        local.get 0
        struct.get 3 0
        struct.get 2 1
        i32.const 1
        i32.add
        struct.set 2 1
      else
        local.get 0
        struct.get 3 0
        i32.const 58
        call 62
        local.set 15
        local.get 15
        ref.is_null
        if ;; label = @3
        else
          local.get 15
          ref.as_non_null
          local.set 6
          i32.const 1
          ref.null none
          local.get 6
          ref.as_non_null
          return
        end
      end
      block (result (ref 12)) ;; label = @2
        local.get 0
        struct.get 3 1
        ref.cast (ref 26)
        local.set 27
        local.get 27
        struct.get 26 0
        local.get 0
        struct.get 3 0
        struct.get 2 0
        local.get 2
        local.get 5
        local.get 27
        struct.get 26 1
        call_ref 25
      end
      local.set 26
      local.get 26
      ref.test (ref 13)
      if (result i32) ;; label = @2
        local.get 26
        ref.cast (ref 13)
        struct.get 13 1
        local.set 7
        local.get 7
      else
        i32.const -1
      end
      local.set 8
      i32.const 0
      i32.const 0
      local.get 8
      struct.new 13
      ref.null none
      return
    end
    local.get 0
    struct.get 3 0
    local.get 2
    i32.const 1
    i32.sub
    struct.set 2 1
    local.get 0
    struct.get 3 0
    call 63
    local.set 28
    local.get 28
    ref.test (ref 22)
    if (result (ref 1)) ;; label = @1
      local.get 28
      ref.cast (ref 22)
      struct.get 22 1
      local.set 9
      local.get 9
      ref.as_non_null
    else
      local.get 28
      ref.cast (ref 23)
      struct.get 23 1
      local.set 10
      i32.const 1
      ref.null none
      local.get 10
      ref.as_non_null
      return
    end
    call 14
    local.set 11
    local.get 0
    struct.get 3 0
    i32.const 58
    call 62
    local.set 16
    local.get 16
    ref.is_null
    if ;; label = @1
    else
      local.get 16
      ref.as_non_null
      local.set 12
      i32.const 1
      ref.null none
      local.get 12
      ref.as_non_null
      return
    end
    block (result (ref 12)) ;; label = @1
      local.get 0
      struct.get 3 1
      ref.cast (ref 26)
      local.set 30
      local.get 30
      struct.get 26 0
      local.get 11
      ref.as_non_null
      i32.const 0
      local.get 11
      struct.get 1 1
      local.get 30
      struct.get 26 1
      call_ref 25
    end
    local.set 29
    local.get 29
    ref.test (ref 13)
    if (result i32) ;; label = @1
      local.get 29
      ref.cast (ref 13)
      struct.get 13 1
      local.set 13
      local.get 13
    else
      i32.const -1
    end
    local.set 14
    i32.const 0
    i32.const 0
    local.get 14
    struct.new 13
    ref.null none
    return
    unreachable
  )
  (func (;73;) (type 96) (param (ref 2) (ref 1) i32 (ref struct)) (result i32 (ref null 3) (ref null 4))
    (local (ref null 4) (ref null 4))
    local.get 0
    i32.const 123
    call 62
    local.set 5
    local.get 5
    ref.is_null
    if ;; label = @1
    else
      local.get 5
      ref.as_non_null
      local.set 4
      i32.const 1
      ref.null none
      local.get 4
      ref.as_non_null
      return
    end
    i32.const 0
    local.get 0
    local.get 3
    i32.const 1
    struct.new 3
    ref.null none
    return
    unreachable
  )
  (func (;74;) (type 88) (param (ref 2)) (result (ref 15))
    (local (ref null 3) i32 f64 f64 (ref null 12) i32 (ref null 2) (ref null 2) i32 (ref null 3) (ref null 4) i32 (ref null 12) (ref null 4) i32 f64 (ref null 4) i32 f64 (ref null 4))
    local.get 0
    i32.const 0
    i32.const 5
    array.new_data 0 43
    i32.const 5
    struct.new 1
    i32.const 2
    struct.new 6
    ref.func 76
    ref.as_non_null
    struct.new 26
    call 73
    local.set 11
    local.set 10
    local.set 9
    local.get 9
    i32.eqz
    if ;; label = @1
      local.get 10
      ref.as_non_null
      local.set 1
      i32.const 0
      local.set 2
      f64.const 0x0p+0 (;=0;)
      local.set 3
      f64.const 0x0p+0 (;=0;)
      local.set 4
      block ;; label = @2
        loop ;; label = @3
          local.get 1
          ref.as_non_null
          call 72
          local.set 14
          local.set 13
          local.set 12
          local.get 12
          i32.eqz
          if ;; label = @4
            local.get 13
            ref.as_non_null
            local.set 5
            local.get 5
            ref.test (ref 13)
            if ;; label = @5
              local.get 5
              ref.cast (ref 13)
              struct.get 13 1
              local.set 6
              local.get 6
              i32.eqz
              if ;; label = @6
                local.get 1
                struct.get 3 0
                local.set 7
                local.get 7
                ref.as_non_null
                call 66
                local.set 17
                local.set 16
                local.set 15
                local.get 15
                i32.eqz
                if ;; label = @7
                  local.get 16
                  local.set 3
                  local.get 2
                  i32.const 1
                  i32.or
                  local.set 2
                else
                  i32.const 1
                  local.get 17
                  ref.as_non_null
                  struct.new 17
                  return
                end
              else
                local.get 6
                i32.const 1
                i32.eq
                if ;; label = @7
                  local.get 1
                  struct.get 3 0
                  local.set 8
                  local.get 8
                  ref.as_non_null
                  call 66
                  local.set 20
                  local.set 19
                  local.set 18
                  local.get 18
                  i32.eqz
                  if ;; label = @8
                    local.get 19
                    local.set 4
                    local.get 2
                    i32.const 2
                    i32.or
                    local.set 2
                  else
                    i32.const 1
                    local.get 20
                    ref.as_non_null
                    struct.new 17
                    return
                  end
                else
                  local.get 1
                  struct.get 3 0
                  call 71
                  drop
                end
              end
            else
              br 3 (;@2;)
            end
          else
            i32.const 1
            local.get 14
            ref.as_non_null
            struct.new 17
            return
          end
          br 0 (;@3;)
        end
      end
      local.get 2
      i32.const 3
      i32.and
      i32.const 3
      i32.ne
      if ;; label = @2
        i32.const 1
        i32.const 1
        i32.const 0
        i32.const 22
        array.new_data 0 44
        i32.const 22
        struct.new 1
        i64.const -1
        struct.new 4
        struct.new 17
        return
      end
      local.get 1
      struct.get 3 0
      i32.const 125
      call 62
      drop
      i32.const 0
      local.get 3
      local.get 4
      struct.new 7
      struct.new 16
      return
    else
      i32.const 1
      local.get 11
      ref.as_non_null
      struct.new 17
      return
    end
    unreachable
  )
  (func (;75;) (type 89) (param (ref 1) i32 i32) (result (ref 12))
    local.get 0
    local.get 1
    local.get 2
    call 12
    return
    unreachable
  )
  (func (;76;) (type 25) (param structref (ref 1) i32 i32) (result (ref 12))
    local.get 1
    local.get 2
    local.get 3
    call 75
    return
    unreachable
  )
  (data (;0;) "{\22x\22:1.5,\22y\22:2.5}")
  (data (;1;) "Assertion failed in ")
  (data (;2;) "__test_0_synthesized_deserialize_point")
  (data (;3;) " at ")
  (data (;4;) "/tmp/min_deser.wado")
  (data (;5;) ":")
  (data (;6;) "\0acondition: p.x == 1.5\0a")
  (data (;7;) "p.x: ")
  (data (;8;) "\0a")
  (data (;9;) "\0acondition: p.y == 2.5\0a")
  (data (;10;) "p.y: ")
  (data (;11;) "deserialize Point failed")
  (data (;12;) "0.")
  (data (;13;) "E")
  (data (;14;) "e")
  (data (;15;) "-")
  (data (;16;) ".")
  (data (;17;) "char::hex_digit_value: not a hex digit")
  (data (;18;) "")
  (data (;19;) "NaN")
  (data (;20;) "-inf")
  (data (;21;) "inf")
  (data (;22;) "0.0")
  (data (;23;) ".0")
  (data (;24;) "+")
  (data (;25;) "index out of bounds")
  (data (;26;) "0")
  (data (;27;) "expected '")
  (data (;28;) "', found '")
  (data (;29;) "'")
  (data (;30;) "unexpected end of input")
  (data (;31;) "expected string")
  (data (;32;) "invalid escape '\5c")
  (data (;33;) "invalid unicode escape")
  (data (;34;) "invalid unicode codepoint")
  (data (;35;) "expected number")
  (data (;36;) "expected 'true'")
  (data (;37;) "expected 'false'")
  (data (;38;) "expected 'null'")
  (data (;39;) "expected ',' or ']'")
  (data (;40;) "expected string key")
  (data (;41;) "expected ',' or '}'")
  (data (;42;) "unexpected character in JSON value")
  (data (;43;) "Point")
  (data (;44;) "required field missing")
  (data (;45;) "trailing data after value")
)

(assert_return (invoke "run"))

// Code generated by command: go run sort_asm.go -pkg qsort -out ../qsort/sort_amd64.s -stubs ../qsort/sort_amd64.go. DO NOT EDIT.

#include "textflag.h"

// func distributeForward64(data []uint64, scratch []uint64, limit int, lo int, hi int) int
// Requires: CMOV
TEXT ·distributeForward64(SB), NOSPLIT, $0-80
	MOVQ data_base+0(FP), AX
	MOVQ scratch_base+24(FP), CX
	MOVQ limit+48(FP), DX
	MOVQ lo+56(FP), BX
	MOVQ hi+64(FP), SI
	LEAQ (AX)(BX*8), BX
	LEAQ (AX)(SI*8), SI
	LEAQ -8(CX)(DX*8), CX
	MOVQ (AX), DI
	XORQ R8, R8
	XORQ R9, R9
	NEGQ DX

loop:
	MOVQ    (BX), R10
	CMPQ    R10, DI
	MOVQ    BX, R11
	CMOVQCC CX, R11
	MOVQ    R10, (R11)(R8*8)
	CMC
	SBBQ    R9, R8
	ADDQ    $0x08, BX
	CMPQ    BX, SI
	JA      done
	CMPQ    R8, DX
	JNE     loop

done:
	SUBQ AX, BX
	LEAQ (BX)(R8*8), BX
	SHRQ $0x03, BX
	DECQ BX
	MOVQ BX, ret+72(FP)
	RET

// func distributeBackward64(data []uint64, scratch []uint64, limit int, lo int, hi int) int
// Requires: CMOV
TEXT ·distributeBackward64(SB), NOSPLIT, $0-80
	MOVQ data_base+0(FP), AX
	MOVQ scratch_base+24(FP), CX
	MOVQ limit+48(FP), DX
	MOVQ lo+56(FP), BX
	MOVQ hi+64(FP), SI
	LEAQ (AX)(BX*8), BX
	LEAQ (AX)(SI*8), SI
	MOVQ (AX), DI
	XORQ R8, R8
	XORQ R9, R9
	CMPQ SI, BX
	JBE  done

loop:
	MOVQ    (SI), R10
	CMPQ    R10, DI
	MOVQ    CX, R11
	CMOVQCC SI, R11
	MOVQ    R10, (R11)(R8*8)
	ADCQ    R9, R8
	SUBQ    $0x08, SI
	CMPQ    SI, BX
	JBE     done
	CMPQ    R8, DX
	JNE     loop

done:
	SUBQ AX, SI
	LEAQ (SI)(R8*8), SI
	SHRQ $0x03, SI
	MOVQ SI, ret+72(FP)
	RET

// func insertionsort128NoSwap(data [][2]uint64, base int, swap func(int, int))
// Requires: AVX, AVX2, SSE4.1
TEXT ·insertionsort128NoSwap(SB), NOSPLIT, $0-40
	MOVQ         data_base+0(FP), AX
	MOVQ         data_len+8(FP), CX
	SHLQ         $0x04, CX
	ADDQ         AX, CX
	TESTQ        AX, CX
	JE           done
	MOVQ         $0x8000000000000000, DX
	PINSRQ       $0x00, DX, X0
	VPBROADCASTQ X0, X0
	MOVQ         AX, DX

outer:
	ADDQ    $0x10, DX
	CMPQ    DX, CX
	JAE     done
	VMOVDQU (DX), X1
	MOVQ    DX, SI

inner:
	VMOVDQU   -16(SI), X2
	VPCMPEQQ  X1, X2, X3
	VPADDQ    X1, X0, X4
	VPADDQ    X2, X0, X5
	VPCMPGTQ  X4, X5, X4
	VMOVMSKPD X3, DI
	VMOVMSKPD X4, R8
	NOTL      DI
	BSFL      DI, BX
	BTSL      BX, R8
	JAE       outer
	VMOVDQU   X2, (SI)
	VMOVDQU   X1, -16(SI)
	SUBQ      $0x10, SI
	CMPQ      SI, AX
	JA        inner
	JMP       outer

done:
	RET

// func distributeForward128(data [][2]uint64, scratch [][2]uint64, limit int, lo int, hi int) int
// Requires: AVX, AVX2, CMOV, SSE4.1
TEXT ·distributeForward128(SB), NOSPLIT, $0-80
	MOVQ         data_base+0(FP), AX
	MOVQ         scratch_base+24(FP), CX
	MOVQ         limit+48(FP), DX
	MOVQ         lo+56(FP), BX
	MOVQ         hi+64(FP), SI
	SHLQ         $0x04, DX
	SHLQ         $0x04, BX
	SHLQ         $0x04, SI
	LEAQ         (AX)(BX*1), BX
	LEAQ         (AX)(SI*1), SI
	LEAQ         -16(CX)(DX*1), CX
	MOVQ         $0x8000000000000000, R8
	PINSRQ       $0x00, R8, X0
	VPBROADCASTQ X0, X0
	VMOVDQU      (AX), X1
	XORQ         R8, R8
	XORQ         R9, R9
	NEGQ         DX

loop:
	VMOVDQU   (BX), X2
	VPCMPEQQ  X2, X1, X3
	VPADDQ    X2, X0, X4
	VPADDQ    X1, X0, X5
	VPCMPGTQ  X4, X5, X4
	VMOVMSKPD X3, R10
	VMOVMSKPD X4, R11
	NOTL      R10
	BSFL      R10, DI
	BTSL      DI, R11
	MOVQ      BX, R10
	CMOVQCC   CX, R10
	VMOVDQU   X2, (R10)(R8*1)
	SETCC     R9
	SHLQ      $0x04, R9
	SUBQ      R9, R8
	ADDQ      $0x10, BX
	CMPQ      BX, SI
	JA        done
	CMPQ      R8, DX
	JNE       loop

done:
	SUBQ AX, BX
	LEAQ (BX)(R8*1), BX
	SHRQ $0x04, BX
	DECQ BX
	MOVQ BX, ret+72(FP)
	RET

// func distributeBackward128(data [][2]uint64, scratch [][2]uint64, limit int, lo int, hi int) int
// Requires: AVX, AVX2, CMOV, SSE4.1
TEXT ·distributeBackward128(SB), NOSPLIT, $0-80
	MOVQ         data_base+0(FP), AX
	MOVQ         scratch_base+24(FP), CX
	MOVQ         limit+48(FP), DX
	MOVQ         lo+56(FP), BX
	MOVQ         hi+64(FP), SI
	SHLQ         $0x04, DX
	SHLQ         $0x04, BX
	SHLQ         $0x04, SI
	LEAQ         (AX)(BX*1), BX
	LEAQ         (AX)(SI*1), SI
	MOVQ         $0x8000000000000000, R8
	PINSRQ       $0x00, R8, X0
	VPBROADCASTQ X0, X0
	VMOVDQU      (AX), X1
	XORQ         R8, R8
	XORQ         R9, R9
	CMPQ         SI, BX
	JBE          done

loop:
	VMOVDQU   (SI), X2
	VPCMPEQQ  X2, X1, X3
	VPADDQ    X2, X0, X4
	VPADDQ    X1, X0, X5
	VPCMPGTQ  X4, X5, X4
	VMOVMSKPD X3, R10
	VMOVMSKPD X4, R11
	NOTL      R10
	BSFL      R10, DI
	BTSL      DI, R11
	MOVQ      CX, R10
	CMOVQCC   SI, R10
	VMOVDQU   X2, (R10)(R8*1)
	SETCS     R9
	SHLQ      $0x04, R9
	ADDQ      R9, R8
	SUBQ      $0x10, SI
	CMPQ      SI, BX
	JBE       done
	CMPQ      R8, DX
	JNE       loop

done:
	SUBQ AX, SI
	LEAQ (SI)(R8*1), SI
	SHRQ $0x04, SI
	MOVQ SI, ret+72(FP)
	RET

// func insertionsort256NoSwap(data [][4]uint64, base int, swap func(int, int))
// Requires: AVX, AVX2, SSE4.1
TEXT ·insertionsort256NoSwap(SB), NOSPLIT, $0-40
	MOVQ         data_base+0(FP), AX
	MOVQ         data_len+8(FP), CX
	SHLQ         $0x05, CX
	ADDQ         AX, CX
	TESTQ        AX, CX
	JE           done
	MOVQ         $0x8000000000000000, DX
	PINSRQ       $0x00, DX, X0
	VPBROADCASTQ X0, Y0
	MOVQ         AX, DX

outer:
	ADDQ    $0x20, DX
	CMPQ    DX, CX
	JAE     done
	VMOVDQU (DX), Y1
	MOVQ    DX, SI

inner:
	VMOVDQU   -32(SI), Y2
	VPCMPEQQ  Y1, Y2, Y3
	VPADDQ    Y1, Y0, Y4
	VPADDQ    Y2, Y0, Y5
	VPCMPGTQ  Y4, Y5, Y4
	VMOVMSKPD Y3, DI
	VMOVMSKPD Y4, R8
	NOTL      DI
	BSFL      DI, BX
	BTSL      BX, R8
	JAE       outer
	VMOVDQU   Y2, (SI)
	VMOVDQU   Y1, -32(SI)
	SUBQ      $0x20, SI
	CMPQ      SI, AX
	JA        inner
	JMP       outer

done:
	VZEROUPPER
	RET

// func distributeForward256(data [][4]uint64, scratch [][4]uint64, limit int, lo int, hi int) int
// Requires: AVX, AVX2, CMOV, SSE4.1
TEXT ·distributeForward256(SB), NOSPLIT, $0-80
	MOVQ         data_base+0(FP), AX
	MOVQ         scratch_base+24(FP), CX
	MOVQ         limit+48(FP), DX
	MOVQ         lo+56(FP), BX
	MOVQ         hi+64(FP), SI
	SHLQ         $0x05, DX
	SHLQ         $0x05, BX
	SHLQ         $0x05, SI
	LEAQ         (AX)(BX*1), BX
	LEAQ         (AX)(SI*1), SI
	LEAQ         -32(CX)(DX*1), CX
	MOVQ         $0x8000000000000000, R8
	PINSRQ       $0x00, R8, X0
	VPBROADCASTQ X0, Y0
	VMOVDQU      (AX), Y1
	XORQ         R8, R8
	XORQ         R9, R9
	NEGQ         DX

loop:
	VMOVDQU   (BX), Y2
	VPCMPEQQ  Y2, Y1, Y3
	VPADDQ    Y2, Y0, Y4
	VPADDQ    Y1, Y0, Y5
	VPCMPGTQ  Y4, Y5, Y4
	VMOVMSKPD Y3, R10
	VMOVMSKPD Y4, R11
	NOTL      R10
	BSFL      R10, DI
	BTSL      DI, R11
	MOVQ      BX, R10
	CMOVQCC   CX, R10
	VMOVDQU   Y2, (R10)(R8*1)
	SETCC     R9
	SHLQ      $0x05, R9
	SUBQ      R9, R8
	ADDQ      $0x20, BX
	CMPQ      BX, SI
	JA        done
	CMPQ      R8, DX
	JNE       loop

done:
	SUBQ AX, BX
	LEAQ (BX)(R8*1), BX
	SHRQ $0x05, BX
	DECQ BX
	MOVQ BX, ret+72(FP)
	VZEROUPPER
	RET

// func distributeBackward256(data [][4]uint64, scratch [][4]uint64, limit int, lo int, hi int) int
// Requires: AVX, AVX2, CMOV, SSE4.1
TEXT ·distributeBackward256(SB), NOSPLIT, $0-80
	MOVQ         data_base+0(FP), AX
	MOVQ         scratch_base+24(FP), CX
	MOVQ         limit+48(FP), DX
	MOVQ         lo+56(FP), BX
	MOVQ         hi+64(FP), SI
	SHLQ         $0x05, DX
	SHLQ         $0x05, BX
	SHLQ         $0x05, SI
	LEAQ         (AX)(BX*1), BX
	LEAQ         (AX)(SI*1), SI
	MOVQ         $0x8000000000000000, R8
	PINSRQ       $0x00, R8, X0
	VPBROADCASTQ X0, Y0
	VMOVDQU      (AX), Y1
	XORQ         R8, R8
	XORQ         R9, R9
	CMPQ         SI, BX
	JBE          done

loop:
	VMOVDQU   (SI), Y2
	VPCMPEQQ  Y2, Y1, Y3
	VPADDQ    Y2, Y0, Y4
	VPADDQ    Y1, Y0, Y5
	VPCMPGTQ  Y4, Y5, Y4
	VMOVMSKPD Y3, R10
	VMOVMSKPD Y4, R11
	NOTL      R10
	BSFL      R10, DI
	BTSL      DI, R11
	MOVQ      CX, R10
	CMOVQCC   SI, R10
	VMOVDQU   Y2, (R10)(R8*1)
	SETCS     R9
	SHLQ      $0x05, R9
	ADDQ      R9, R8
	SUBQ      $0x20, SI
	CMPQ      SI, BX
	JBE       done
	CMPQ      R8, DX
	JNE       loop

done:
	SUBQ AX, SI
	LEAQ (SI)(R8*1), SI
	SHRQ $0x05, SI
	MOVQ SI, ret+72(FP)
	VZEROUPPER
	RET

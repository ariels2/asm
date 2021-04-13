// Code generated by command: go run copy_asm.go -pkg bloom -out ../bloom/copy_amd64.s -stubs ../bloom/copy_amd64.go. DO NOT EDIT.

package bloom

// Copies the one-bits of src to dst, using SIMD instructions as an optimization.
func copyAVX2(dst *byte, src *byte, count int)

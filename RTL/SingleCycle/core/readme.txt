the interconnect of all the modules in CPU

2021.07.09

ver 1.0:

·do not support operations:
	type-U operations
	fence
	fence.i
	ecall
	ebreak
	csrrw
	csrrs
	csrrc
	csrrwi
	cssrrsi
	csrrci

·based on RV32I

ver 1.1:
·improve the structure of memory
·use $readmemh to initialize memory


ver 1.3:
·type-U operations supported

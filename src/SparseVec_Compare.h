#ifndef _SPARSEVEC_COMPARE_H_
#define _SPARSEVEC_COMPARE_H_

#include <Rdefines.h>

#include "SparseVec.h"

/* Operations from 'Compare' group */
#define	EQ_OPCODE	1  /* "==" */
#define	NE_OPCODE	2  /* "!=" */
#define	LE_OPCODE	3  /* "<=" */
#define	GE_OPCODE	4  /* ">=" */
#define	LT_OPCODE	5  /* "<" */
#define	GT_OPCODE	6  /* ">" */

static inline int flip_opcode(int opcode)
{
	switch (opcode) {
	    case NE_OPCODE: return opcode;
	    case LT_OPCODE: return GT_OPCODE;
	    case GT_OPCODE: return LT_OPCODE;
	}
	error("SparseArray internal error in flip_opcode():\n"
	      "    unsupported 'opcode'");
	return 0;  /* will never reach this */
}

int _get_Compare_opcode(SEXP op);

int _Compare_sv1_zero(
	int opcode,
	const SparseVec *sv1,
	int *out_nzvals,
	int *out_nzoffs
);

int _Compare_sv1_scalar(
	int opcode,
	const SparseVec *sv1,
	SEXP scalar,
	int *out_nzvals,
	int *out_nzoffs
);

int _Compare_sv1_sv2(
	int opcode,
	const SparseVec *sv1,
	const SparseVec *sv2,
	int *out_nzvals,
	int *out_nzoffs
);

#endif  /* _SPARSEVEC_COMPARE_H_ */


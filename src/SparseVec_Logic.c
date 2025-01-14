/****************************************************************************
 *                   'Logic' operations on sparse vectors                   *
 ****************************************************************************/
#include "SparseVec_Logic.h"

#include "SparseVec.h"


int _get_Logic_opcode(SEXP op)
{
	const char *s;

	if (!IS_CHARACTER(op) || LENGTH(op) != 1)
		error("SparseArray internal error in _get_Logic_opcode():\n"
		      "    'op' must be a single string");
	op = STRING_ELT(op, 0);
	if (op == NA_STRING)
		error("SparseArray internal error in _get_Logic_opcode():\n"
		      "    'op' cannot be NA");
	s = CHAR(op);
	if (strcmp(s, "&") == 0)
		return AND_OPCODE;
	if (strcmp(s, "|") == 0)
		return OR_OPCODE;
	error("SparseArray internal error in _get_Logic_opcode():\n"
	      "    invalid op: \"%s\"", s);
	return 0;  /* will never reach this */
}

static inline int Logic_int_int(int x, int y, int opcode)
{
	switch (opcode) {
	    case AND_OPCODE:
		if (x == 0 || y == 0)
			return 0;
		if (x == NA_INTEGER || y == NA_INTEGER)
			return NA_INTEGER;
		return 1;
	    case OR_OPCODE:
		if (x == 1 || y == 1)
			return 1;
		if (x == NA_INTEGER || y == NA_INTEGER)
			return NA_INTEGER;
		return 0;
	}
	error("SparseArray internal error in Logic_int_int():\n"
	      "    unsupported 'opcode'");
	return 0;  /* will never reach this */
}

int _Logic_intSV_intSV(int opcode, const SparseVec *sv1, const SparseVec *sv2,
		int *out_nzvals, int *out_nzoffs)
{
	int out_nzcount = 0, k1 = 0, k2 = 0, off, x, y;
	while (next_2SV_vals_int_int(sv1, sv2,
				&k1, &k2, &off, &x, &y))
	{
		int v = Logic_int_int(x, y, opcode);
		if (v != int0) {
			out_nzvals[out_nzcount] = v;
			out_nzoffs[out_nzcount] = off;
			out_nzcount++;
		}
	}
	return out_nzcount;
}


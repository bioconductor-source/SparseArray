#ifndef _SPARSEARRAY_SUBASSIGNMENT_H_
#define _SPARSEARRAY_SUBASSIGNMENT_H_

#include <Rdefines.h>

SEXP C_subassign_SVT_by_Lindex(
	SEXP x_dim,
	SEXP x_type,
	SEXP x_SVT,
	SEXP Lindex,
	SEXP vals,
	SEXP na_background
);

SEXP C_subassign_SVT_by_Mindex(
	SEXP x_dim,
	SEXP x_type,
	SEXP x_SVT,
	SEXP Mindex,
	SEXP vals
);

SEXP C_subassign_SVT_with_short_Rvector(
	SEXP x_dim,
	SEXP x_type,
	SEXP x_SVT,
	SEXP Nindex,
	SEXP Rvector
);

SEXP C_subassign_SVT_with_Rarray(
	SEXP x_dim,
	SEXP x_type,
	SEXP x_SVT,
	SEXP Nindex,
	SEXP Rarray
);

SEXP C_subassign_SVT_with_SVT(
	SEXP x_dim,
	SEXP x_type,
	SEXP x_SVT,
	SEXP Nindex,
	SEXP v_dim,
	SEXP v_type,
	SEXP v_SVT
);

#endif  /* _SPARSEARRAY_SUBASSIGNMENT_H_ */


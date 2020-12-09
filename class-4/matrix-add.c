/* **********************************************************************
 *
 * MATRIX-ADD
 * ----------------------------------------------------------------------
 *
 *   Simple program to showcase the difference between column major
 *   and row major access of given matrices in cache behavior.
 *
 * NOTES
 *
 *   Matrices are given as 1-D arrays.
 *
 * ARGS
 *
 *   m: number of rows          [required]
 *   n: number of cols          [required]
 *
 * ********************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/time.h>

/*
 * sub2ind - Column-major indexing of linear-storage 2D arrays
 */
inline int sub2ind( int i, int j, int height ) {

  return (i + height * j );

} // end function 'sub2ind'

/*
 * matrixAddRow - Elementwise addition of 2 matrices in row major
 * access order
 */
void matrixAddRow(float * const C,            /* output matrix */
                  float const * const A,      /* first matrix */
                  float const * const B,      /* second matrix */
                  int const n,                /* number of rows */
                  int const m) {              /* number of cols */

  for (int i = 0; i < n; i++)                 /* rows */
    for (int j = 0; j < m; j++)               /* cols */
      C[ sub2ind(i,j,n) ] = A[ sub2ind(i,j,n) ] + B[ sub2ind(i,j,n) ];

} // end function 'matrixAddRow'


/*
 * matrixAddCol - Elementwise addition of 2 matrices in column major
 * access order
 */
void matrixAddCol(float * const C,            /* output matrix */
                  float const * const A,      /* first matrix */
                  float const * const B,      /* second matrix */
                  int const n,                /* number of rows */
                  int const m) {              /* number of cols */

  for (int j = 0; j < m; j++)                 /* cols */
    for (int i = 0; i < n; i++)               /* rows */
      C[ sub2ind(i,j,n) ] = A[ sub2ind(i,j,n) ] + B[ sub2ind(i,j,n) ];

} // end function 'matrixAddCol'

/*
 * matrixInitAdd - Initialize matrix by summing indices
 */
void matrixInitAdd(float * const M,        /* matrix pointer */
                   int const n,            /* number of rows */
                   int const m) {          /* number of cols */

  for (int j = 0; j < m; j++)              /* cols */
    for (int i = 0; i < n; i++)            /* rows */
      M[ sub2ind(i,j,n) ] = i + j;

} // end function 'matrixInitAdd'


/*
 * matrixInitSub - Initialize matrix by substracting indices
 */
void matrixInitSub(float * const M,        /* matrix pointer */
                   int const n,            /* number of rows */
                   int const m) {          /* number of cols */

  for (int j = 0; j < m; j++)              /* cols */
    for (int i = 0; i < n; i++)            /* rows */
      M[ sub2ind(i,j,n) ] = i - j;

} // end function 'matrixInitSub'

int main(int argc, char **argv) {

  float *A, *B, *C, *D;         /* matrix declarations */
  int n, m;                     /* matrix dimensions */
  struct timeval start, end;    /* time structs */
  double timeRow, timeCol;      /* execution time in ms */

  if (argc != 3) {
    fprintf(stderr, "Call program with the following command line args\n" );
    fprintf(stderr, "  m: number of rows\n" );
    fprintf(stderr, "  n: number of cols\n" );
    exit(1);
  }
  
  /* get dimensions */
  n = atoi( argv[1] );
  m = atoi( argv[2] );

  /* allocate matrices */
  A = (float *) malloc( n*m*sizeof(float) );
  B = (float *) malloc( n*m*sizeof(float) );
  C = (float *) malloc( n*m*sizeof(float) );
  D = (float *) malloc( n*m*sizeof(float) );
  
  /* initialize matrices */
  matrixInitAdd( A, n, m );      /* A(i,j) = i+j */
  matrixInitSub( B, n, m );      /* B(i,j) = i-j */

  /* compute row major matrix addition */
  gettimeofday(&start, NULL);
  matrixAddRow( C, A, B, n, m ); /* C(i,j) = A(i,j) + B(i,j) */
  gettimeofday(&end, NULL);

  timeRow = ( (end.tv_sec - start.tv_sec) * 1000.0 +    /* sec to ms */
              (end.tv_usec - start.tv_usec) / 1000.0 ); /* us to ms */

  /* compute column major matrix addition */
  gettimeofday(&start, NULL);
  matrixAddCol( D, A, B, n, m ); /* D(i,j) = A(i,j) + B(i,j) */
  gettimeofday(&end, NULL);

  timeCol = ( (end.tv_sec - start.tv_sec) * 1000.0 +    /* sec to ms */
              (end.tv_usec - start.tv_usec) / 1000.0 ); /* us to ms */
  
  /* validation */
  for (int j = 0; j < m; j++)           /* cols */
    for (int i = 0; i < n; i++) {       /* rows */
      assert( C[ sub2ind(i,j,n) ] == 2 * i );
      assert( D[ sub2ind(i,j,n) ] == 2 * i );
    }

  printf( "\n" );
  printf( "  Validation        PASS\n" );

  /* output times */
  printf( "\n" );
  printf( "  Row-major   %7.2f ms\n", timeRow );
  printf( "  Col-major   %7.2f ms\n", timeCol );
  
  printf( "\n" );  
  return 0;
  
}

/* **********************************************************************
 *
 * AUTHORS
 *
 *   Dimitris Floros                         fcdimitr@auth.gr
 *
 * VERSION
 *
 *   0.1 - May 09, 2017
 *
 * CHANGELOG
 *
 *   0.1 (May 09, 2017) - Dimitris
 *       * initial implementation
 *
 * ********************************************************************** */
